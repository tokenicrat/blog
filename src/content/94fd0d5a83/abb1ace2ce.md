---
title: "sing-box 白话文指南（零）"
summary: "为什么（不）选择自建；选购 VPS 和域名"
topics: ["科学上网"]
date: "2025-07-10T15:37:19+08:00"
draft: false
katex: false
typora-root-url: ../../static
typora-copy-images-to: ../../static/img/${filename}
---

章节目标：

- 坚定或放弃自建的决心，清楚自建的优劣。
- 大致了解 VPS 的重要参数。
- 购买 VPS 和域名。

## 对比自建和机场

作为科学上网的两种主要方案，自建和机场的优劣势基本是互补的。词元先列一个常规的表格：

| 项目     | 自建                           | 机场                            |
| -------- | ------------------------------ | ------------------------------- |
| 速度[^1] | 优质线路很贵                   | ✅ 平摊成本肯定便宜              |
| 纯净     | ✅ 独享固定 IP                  | 万人骑，家宽能玩成高风险[^2]    |
| 隐私     | ✅ 自己掌握日志                 | 机场主可以看到 URL 和 HTTP 明文 |
| 折腾     | 需要前置知识，花时间搭建和调试 | ✅ 拿到订阅链接直接用            |
| 稳定     | 单 IP，抗风险能力差            | ✅ 多节点，IP 资源丰富           |
| 灵活     | ✅ 自选协议和出站               | 只能使用机场提供的              |

[^1]: 默认同价位比较。如果您不缺钱，自建的上限肯定是比较高的。
[^2]: 本文面对初学者，因此不考虑链式代理等取长补短的高端玩法。如果您会用链式代理，大概也不会来看词元的教程了。

如果是三四年前，词元会毫不犹豫地推荐您选择机场，因为自建条件不充足：IP 被封家常便饭，廉价 VPS 质量奇差、频繁跑路，稍好一点的 VPS 又过于昂贵。这导致与机场相比，钱没少花，使用体验还变差了。

但是在今天，关键因素都凑齐了：

- VLESS-Vision-REALITY 直连几乎免封[^3]。
- Hysteria2 极大提升烂线路 VPS 体验。
- 硬件上，RackNerd 等质量尚可的平价 VPS 商家出现。

[^3]: 截至 2025 年 7 月，词元没有发现 GFW 识别和封禁该协议组合的迹象。

自建的体验与成本对比可以接受，结合其原有 IP 独立、协议灵活等优势，可以说，如果什么时候最适合选择自建的话，那就是现在了 😎

另外，近期（2025 年 7 月），运营商开始大规模封停境内中转和专线服务器，针对机场的 DDoS 增多，许多大型机场出现服务不稳定的情况。词元提醒谨慎订阅大型中转和专线机场。~~说起来也挺魔幻的，反而是直连更稳定了。~~

话说回来，选择哪一种方案还是要看您自己的需求。如果您极端追求稳定性和速度，大可关掉页面，继续放心使用机场。如果您下定决心要自建，那就接着看。

## VPS 参数词典

选购 **作为代理服务器**[^4] 的 VPS，一般来说看重以下参数（重要性递减）：

[^4]: 如果您有建站的计划，那么重点就不一样了（落地 IP 没那么重要，但是性能值得关注）。

- 线路
- 落地 IP
- 流量和速率限制
- 售后、退款等服务
- 处理器、硬盘、内存性能

简要解释一下。注意 VPS 的坑是很多的，以下仅作科普，您看完后再去阅读词元提供的参考资料，会有更深的理解。

### 线路

您访问境外服务器，数据包会一路通过市级、省级、国际出口，经过一系列运营商的路由节点。具体经过哪些节点，就是我们所说的 **线路**。

用户数量多、容量较小的线路就会堵塞。例如 ~~臭名昭著的~~ 电信 163 骨干网，在晚高峰时段（18:00 至 23:00）由于运营商 QoS（故意丢包、限速，减轻压力[^5]），丢包率能达到不可接受的级别。

[^5]: 这个说法是不准确的。QoS 是 ISP 识别流量类别并针对性优化的技术，优质线路都有真正的 QoS 提升体验。

为了提升体验，某些 VPS 商家会花钱接入三大运营商的优质线路，然后出售所谓「中国大陆优化」的 VPS。常见的优质线路如电信 CN2 GIA。当然更牛的「云计算平台」（Microsoft Azure、Google Cloud Platform、Amazon Web Service 等）会自己搭建线路 💰

对于初学者来说，不建议一上来就尝试优质线路，价格昂贵且落地 IP 差。

如果您使用联通宽带，其默认出境线路 4837 质量很不错，无优化可用；如果您使用移动宽带，随机性比较强，在某些地区访问某些国家（笑）效果堪比 CN2 GIA，其他就对标 163 晚高峰。

电信嘛……如果愿意花钱，有 CN2 GIA 用，效果是最好的；但是普通线路（163）基本全天不可用，上 Hysteria2 对轰也许勉强能用。如果有机会，请不要使用电信宽带。

![image-20250711104959992](/img/abb1ace2ce/image-20250711104959992.png)

可以看出来出境海底电缆集中于上海、广东和香港。（图源 [Submarine Cable Map](https://www.submarinecablemap.com/)）

> 参考资料：
>
> - [中国三大电信运营商国际网络互联相关资料](https://blog.sunflyer.cn/archives/594)（深入探究必读）
> - [各种线路详解 CN2/BGP/IPLC/GCP/AWS/Azure【硬核翻墙系列】第四期](https://www.youtube.com/watch?v=S_qo6qu4wm0)（略过时）

### 落地 IP

落地 IP，也就是您实际用于访问目标站点的代理服务器 IP。流媒体、AI、论坛等服务为了避免滥用，往往会对 IP 做严格限制，导致您被某些站点封禁。

IP 质量主要取决于 IP 类别和共用人数。普通 VPS 都是机房 IP，风险度取决于您的邻居（同 IP 段）和上一任机主的人品；家宽 IP 是国外运营商分配给普通住户的，质量远高于机房 IP，价格当然也更加昂贵，相当于您自己去国外又办了一条宽带。

对于初学者，一般的机房 IP 足够，虽然可能遇到 OpenAI 降智、Netflix 只能看自制剧，但是成本低。

另外还有一种特殊情况，由于某些 IP 段有用户故意开启定位使用 Google 服务，该 IP 段被标记为中国大陆，也就是「送中」。这会导致 Google 的 AI、付费服务不可用。这个问题词元待会儿会讲缓解方法。

> 参考资料：
>
> - [常见各种家宽提供商的推荐和吐槽](https://linux.do/t/topic/585764)（权限帖，注册一个账号）

### 流量和速率限制

这没啥好说的，有几个注意事项：

- 注意如果计算方法是上传、下载相加，作为代理使用时注意您的流量是双倍计算的。
- 某些商家有超售带宽行为，也就是在高峰时段无法达到最大速率。
- 如果长期保持高速率，您的 VPS 很可能被停机。

### 其他

另外两项没啥好说的，也没有一眼能看出来的判断方法。下面会说到怎么找参考信息。

## 选购 VPS

科普结束，问题来了，您怎么知道哪家 VPS 比较好？

推荐一个站点：[DigVPS](https://digvps.com/review)。这张榜单基本是客观公正的，而且有定时更新的延迟、速度测试等，购买之前可以参考。另外，NodeSeek 社区有 [NodeQuality](https://nodequality.com/) 工具，包含了用户自愿上传的测试结果，也可以看看，注意时效性。

您能购买的 VPS 质量和价格是基本成正比的，如果您的预算在 ¥150 以下，词元（在 2025 年 7 月）建议购买 RackNerd 的 VPS[^6]，属于廉价且质量尚可的类别。其落地 IP 还行，线路就是最普通的，略有超售。另外 RackNerd 支持支付宝付款，比较方便，不然还得折腾 PayPal 或者信用卡之类的。

[^6]: 词元倒希望这是广告。

词元接下来就以 RackNerd 为例操作，其他 VPS 商家基本一致。

RackNerd 的常年优惠 VPS 在其「社区」站 [RackNerd Club](https://racknerd.club/en/)，有很多配置组合。RackNerd 对中国大陆最好的机房是 Los Angeles DC-02，但是常年售罄，而且最低配置是没有这个地区的。

您可以等等 Los Angeles DC-02 机房补货；如果着急，也可以选择其次的 San Jose 机房。关于配置，如果您只是搭建代理，最低配置基本足够；如果需要建站和其他服务建议 2 核心、2GB 内存起步。

![image-20250711102528533](/img/abb1ace2ce/image-20250711102528533.png)

选定配置组合，然后可以选择地区和操作系统。词元接下来会以 Rocky Linux 为例操作，如果不熟悉 Linux 建议选择相同的，方便下面操作。

![image-20250711102729985](/img/abb1ace2ce/image-20250711102729985.png)

下面就是注册账号和付款了，这个没什么好说的，注意邮箱一定要输入正确，因为初始 SSH 用户和密码会通过邮件发送给您。

![image-20250711104551933](/img/abb1ace2ce/image-20250711104551933.png)

请重点记录以下信息：

- IP 地址
- root 账户密码
- NerdVM 面板用户名和密码
- 其他商家可能 SSH 端口、VPS 用户名也需要记录

如果您比较担心 VPS 的安全，可以在这里先跳至下一节，做 VPS 安全措施，然后再返回购买域名。

## 选购域名

关于域名的选择也有一个对比站点推荐：[TLD-List](https://tld-list.com/)。域名不仅仅可以用作代理，还可以在 Cloudflare 托管做博客、公共服务等，因此选择一个付费的域名有利于避免封禁和 DNS 污染。像 .dpdns.org 这种免费二级域名备用还差不多，在江苏、福建都基本被反诈封禁了。

另外提醒，近期 Cloudflare 将部分 .top 和 .xyz 解析到 .1 结尾的 CDN IP，在国内无法访问，因此不建议购买（虽然真的很便宜）。词元自己的旧博客就中招了。

词元这里以 [NameSilo](https://www.namesilo.com) 为例，搜索并注册自己想要的域名。

![image-20250711105942193](/img/abb1ace2ce/image-20250711105942193.png)

可以看到比较便宜的域名大概就是 ¥30 一年左右，同样注册一个账号直接支付宝付款购买。期间需要您填写地址等信息，可以用 [生成器](https://www.fakexy.com/) 随便填一组。

## 转移域名托管

Cloudflare 是一家著名的网络服务公司，民间俗称「大善人」，因为它提供无限 CDN 流量和 DDoS 防护，还有一堆有用的域名相关功能、无服务器计算服务，大多免费提供。Cloudflare 全球计算节点很多，总有那么一些可访问且速度较快。

我们这里将域名的 DNS 服务器转移到 Cloudflare，就可以享受其服务了。

先去 [Cloudflare](https://www.cloudflare.com) 注册一个账号，只需要邮箱即可。进入 Dashboard，添加域名。

![image-20250711111051800](/img/abb1ace2ce/image-20250711111051800.png)

输入自己的域名（根域名，不要添加 `www` 之类的），选择免费版。

![image-20250711111320481](/img/abb1ace2ce/image-20250711111320481.png)

然后 Cloudflare 将提供其 DNS 服务器，记录下来。

![image-20250711111418239](/img/abb1ace2ce/image-20250711111418239.png)

回到 NameSilo 的域名面板，进入 Domain Manager。

![image-20250711111623944](/img/abb1ace2ce/image-20250711111623944.png)

~~真怀旧啊……~~ 选择右侧像数据库管理一样的那个图标（实际上是 DNS 管理）。

![image-20250711111934306](/img/abb1ace2ce/image-20250711111934306.png)

将你刚刚记录的两个 Cloudflare DNS 服务器域名填入 1 和 2，然后删除其他所有记录。

![image-20250711111852954](/img/abb1ace2ce/image-20250711111852954.png)

等待一段时间，Cloudflare 就会发邮件提示您域名已经到位了。

### 发生了什么

您的域名注册商仍然是 NameSilo。在付钱之后，NameSilo 用这笔钱（的一部分？）向 ICAAN（一个域名管理机构）申请了您的域名，并记录自己的 DNS 服务器负责解析子域名。

ICAAN 负责顶级域名（TLD）的解析，但是您的域名实际上是二级，ICAAN 记录了二级域名应该向哪个 DNS 服务器寻求解析。当您将 NameSilo 这里的解析服务器修改为 Cloudflare，NameSilo 通知 ICAAN「Cloudflare 接手解析啦」，然后您就可以在 Cloudflare 那里管理 DNS。

但是，这并不是域名转交，因为续费、更改解析服务器这些需要 ICAAN 参与的项目还要在 NameSilo 做，因为 ICAAN 还是把 NameSilo 看作注册商。

## 恭喜

您已经完成了搭建的硬件基础部分！接下来不用花钱了 🤑

这里花里胡哨写了这么多，我们还没碰到代理的大门——但是别着急，待会儿有的是机会。

[📖 回到目录](/94fd0d5a83/)
