# 安全经验教训

## 背景
OpenClaw 安全事件后总结的经验教训，以后用 OpenClaw 时要特别注意。

## 核心原则
OpenClaw 本身安全性很好（沙箱隔离、权限分级、Token 加密存储），但搭建的应用和服务安全性取决于自己。AI 编程 10 倍速出活 = 安全债务 10 倍速累积。

## 6 条实用建议

### 1. .env 文件权限改 600
- OpenClaw 配置文件和环境变量存着所有 API Key
- 运行：`chmod 600 ~/.openclaw/*.json` 和 `chmod 600 .env`
- 只允许当前用户读写

### 2. 不要在聊天里发明文 Key
- 在 Telegram/飞书等聊天里给 Agent 发 API Key 会被记录到文件里
- **正确做法**：直接写进 .env 或用 `openclaw config` 设置

### 3. 远程访问绑内网
- VNC、远程桌面或调试端口一定绑到内网 IP 或 Tailscale 网络
- 不要暴露在公网（**不要绑定 0.0.0.0**）
- 之前 VNC 绑 0.0.0.0 = 全世界都能连

### 4. 开 fail2ban
- SSH 暴力破解是最常见的攻击手段
- 安装：`apt install fail2ban`
- 建议配置：3 次失败封 24 小时

### 5. Agent 不要用 root 跑
- 给 OpenClaw 创建专用用户
- 限制文件系统访问范围
- 万一 Agent 被诱导执行恶意命令，损害范围可控

### 6. 定期检查开放端口
- 运行：`ss -tlnp` 查看服务器对外暴露的端口
- **绝对不应该对公网开放的端口**：
  - 数据库端口（5432、3306）
  - 调试端口（9229、18800）

## 关键认知
- OpenClaw 给了你 10 倍生产力 = 10 倍攻击面
- Agent 能帮你写代码、调接口、操作数据库 → 权限没控好，攻击者也能通过 Agent 做这些事
- **代码能跑 ≠ 代码安全**

## 启示
希望不用等到收到黑客邮件那天才明白这个道理。

---

## 🚨 避免自残式翻车：自动回滚机制

### 问题背景
AI 把自己改崩的根本原因：它在锯掉自己坐的那根树枝。
任何涉及 gateway 重启的操作都有风险：
- 改 openclaw.json
- 改 channel 配置（Telegram、Discord 权限）
- 升级插件
- 操作完 → 重启 → 如果出错 → AI 用来接收消息的通道断了 → 它没法告诉你"出错了"

### 解决方案：系统级定时回滚

**原理**：改配置前先设一个 5 分钟后自动恢复原配置的定时任务。
- 改完之后，如果一切正常，手动取消
- 如果改坏了，什么都不用管——5 分钟后自动还原

**关键**：定时任务必须是系统级的（macOS at 命令、Linux crontab），不能依赖被改的程序本身。

### 约定口令

跟 OpenClaw 约定口令：**"自动回滚"**

只要说出这四个字，它就知道要做什么：
1. 备份当前配置：`cp ~/.openclaw/openclaw.json ~/.openclaw/openclaw.json.bak`
2. 设系统级定时任务（5分钟后）：`echo "cp ~/.openclaw/openclaw.json.bak ~/.openclaw/openclaw.json && openclaw gateway restart" | at now + 5 minutes`
3. 告诉你回滚任务的 ID
4. 然后才去改配置、重启

改完确认没问题后：`atrm <job-id>` 撤销

### 高危操作清单（必须用自动回滚）
- 改 openclaw.json 里的 channel 配置
- 改代理路由
- 更新插件
- 修改模型配置

### 额外保险：改配置前先 git commit

在 AGENTS.md 最顶部写一条规则：

```
⚠️ 修改前先 git commit
```

操作：
```bash
cd ~/.openclaw && git add -A && git commit -m "改动前快照"
```

改完如果没问题，再 commit 一次记录变更。
如果改炸了：`git checkout .` 回到上一个快照。

### 两层防护
- **回滚是保险丝**：5 分钟自动恢复
- **git 是黑匣子**：随时可查看改动、可还原

---
记录时间：2026-02-26
来源：微信公众号文章 - 如何避免 OpenClaw 把自己改死
