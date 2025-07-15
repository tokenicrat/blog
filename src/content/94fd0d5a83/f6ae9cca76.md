---
title: "使用 TCP Brutal 加速 TCP 系协议"
summary: "安装 TCP Brutal 内核模块，sing-box 适配"
topics: ["sing-box"]
date: "2025-07-15T18:15:33+08:00"
draft: false
katex: false
typora-root-url: ../../static
typora-copy-images-to: ../../static/img/${filename}
---

引自 [TCP Brutal README](https://github.com/apernet/tcp-brutal/blob/master/README.zh.md)：

> TCP Brutal 是 Hysteria 中的同名拥塞控制算法移植到 TCP 的版本，作为一个 Linux 内核模块……作为 Hysteria 官方子项目，TCP Brutal 会保持与 Hysteria 中的 Brutal 同步更新。

Hysteria(2) 是基于 UDP 的，TCP Brutal 则是它的 TCP 移植。

简单来说：

- 原始 TCP 拥塞控制算法，如果丢包率较高，会减速发包，减轻网络压力。
- Google 开发的 BBR 拥塞控制算法，结合多种因素判定丢包率高的原因，如果是网络拥堵，则减速；否则相应调整速率，维持带宽。
- Brutal 则无论在什么情况下，都尽力达到用户设定的带宽，加速发包。

因此有些人觉得 Brutal 不道德，在网络拥堵时还加速发包，让别人的原始 TCP 减速。词元道德感没这么强——把目标带宽调到 50Mbps，可用就行。

## 更新系统

```bash
sudo dnf update
sudo reboot
```

尤其注意要更新内核，使 `kernel-devel` 和 `kernel` 版本号相同，否则安装会报错。

## 用一键脚本安装

```bash
bash <(curl -fsSL https://tcp.hy2.sh/)
```

这个脚本会自动补全依赖并安装 TCP Brutal 的 DKMS 模块。不出意外，应该是正常安装。不需要重启即可使用。

## 调整 sing-box 设置

sing-box 原生支持 TCP Brutal。在（除 Hysteria2 等 UDP 协议）每一个入站配置中添加：

```json
{
    "inbound": [
        {
            ...
            "multiplex": {
                "enabled": true,
                "padding": false,
                "brutal": {
                    "enabled": true,
                    "up_mbps": 50,
                    "down_mbps": 50
                }
            }
        }
    ]
}
```

其中带宽上行和下行目标可以自行修改。然后重启 sing-box 即可。

如果您的客户端是 NekoRay，您应该很容易找到关于 Brutal 的设置，相应填写即可。
