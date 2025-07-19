#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define color codes for output formatting
COLOR_RED="\e[31m"
COLOR_GREEN="\e[32m"
COLOR_BLUE="\e[34m"
COLOR_YELLOW="\e[33m"
COLOR_NONE="\e[0m"

# Hugo version to use
HUGO_VER="0.148.1"

# Build settings
BUILD_CACHE="build_cache"
HUGO_COMMAND="hugo"

# Function to display colored messages
print_message() {
    local color=$1
    local message=$2
    printf "${color}%s${COLOR_NONE}\n" "$message"
}

# Function to display info messages
info() {
    print_message "${COLOR_BLUE}INFO${COLOR_NONE} " "$1"
}

# Function to display success messages
success() {
    print_message "${COLOR_GREEN}SUCCESS${COLOR_NONE} " "$1"
}

# Function to display warning messages
warning() {
    print_message "${COLOR_YELLOW}WARNING${COLOR_NONE} " "$1"
}

# Function to display error messages and exit
error() {
    print_message "${COLOR_RED}ERROR${COLOR_NONE} " "$1"
    exit 1
}

# Function to show help message
show_help() {
    cat << EOF
Usage: $0 [options]

Options:
  -p, --preview    Preview the site using 'hugo serve'
  -h, --help       Show this help message
  
Without options, the script will build the site to the 'public' directory.
EOF
    exit 0
}

# Parse command line arguments
PREVIEW_MODE=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        -p|--preview)
            PREVIEW_MODE=true
            shift
            ;;
        -h|--help)
            show_help
            ;;
        *)
            warning "Unknown option: $1"
            show_help
            ;;
    esac
done

# Setup Hugo
info "Setting up Hugo"

# Check if Hugo is installed and has the correct version
if command -v hugo > /dev/null && [[ "$(hugo version)" == *"${HUGO_VER}"* ]]; then
    success "Detected compatible Hugo version"
else
    # Create build cache directory if it doesn't exist
    mkdir -p "${BUILD_CACHE}"
    
    # Download and extract Hugo
    HUGO_FILENAME="hugo_${HUGO_VER}_linux-amd64.tar.gz"
    HUGO_URL="https://github.com/gohugoio/hugo/releases/download/v${HUGO_VER}/${HUGO_FILENAME}"
    
    info "Downloading Hugo ${HUGO_VER}..."
    if curl -sS -L -o "${BUILD_CACHE}/hugo.tar.gz" "${HUGO_URL}"; then
        tar -xf "${BUILD_CACHE}/hugo.tar.gz" -C "${BUILD_CACHE}" || error "Failed to extract Hugo binary"
        success "Successfully downloaded Hugo ${HUGO_VER}"
        HUGO_COMMAND="${BUILD_CACHE}/hugo"
        chmod +x "${HUGO_COMMAND}" || error "Failed to make Hugo executable"
	HUGO_COMMAND="../${HUGO_COMMAND}"
    else
        error "Failed to download compatible Hugo binary"
    fi
fi

# Check if src directory exists
if [ ! -d "src" ]; then
    error "No 'src' directory found"
fi

if [ "$PREVIEW_MODE" = true ]; then
    info "Running in PREVIEW mode"
    
    # Create build_cache directory for the site content
    mkdir -p "${BUILD_CACHE}/site"
    
    # Copy configuration files to build_cache
    if [ -f "src/hugo.toml" ]; then
        cp "src/hugo.toml" "${BUILD_CACHE}/site/" || error "Failed to copy hugo.toml"
    elif [ -f "src/hugo.yaml" ]; then
        cp "src/hugo.yaml" "${BUILD_CACHE}/site/" || error "Failed to copy config.yaml"
    else
        warning "No Hugo configuration file found in src directory"
    fi
    
    # Copy content to build_cache
    for dir in content static layouts archetypes themes assets data i18n; do
        if [ -d "src/$dir" ]; then
            cp -r "src/$dir" "${BUILD_CACHE}/site/" || warning "Failed to copy $dir directory"
        fi
    done
    
    # Start the Hugo server
    info "Starting Hugo server from build_cache/site directory"
    cd "${BUILD_CACHE}/site" || error "Failed to change directory to ${BUILD_CACHE}/site"
    
    success "Preview server starting at http://localhost:1313/"
    info "Press Ctrl+C to stop the server"
    "${HUGO_COMMAND}" serve --buildDrafts --buildFuture || error "Failed to start Hugo server"
else
    # Build the site
    info "Building site to 'public' directory"
    cd "src" || error "Failed to change directory to 'src'"
    "${HUGO_COMMAND}" --destination ../public || error "Failed to build Hugo site"
    success "Build process completed successfully!"
fi
