# James AI 团队 - 完整配置指南

## 📋 配置现状

### ✅ 已完成
1. **8个 Agent 定义** - 张小妹 + 7个专业助手
2. **独立 Workspace** - 每个 agent 有自己的工作区
3. **Agent 间通信** - agentToAgent 工具已配置
4. **Telegram 多 Bot** - 8个 bot 账户配置（待填 token）
5. **飞书多 Agent** - 8个飞书应用配置（待填 appId/appSecret）
6. **QQ 多 Bot** - 4个 QQ bot 配置
7. **Bindings 路由** - 所有平台路由规则已配置

### ❌ 还需要做的

## 1. 创建飞书应用（8个）

### 飞书开放平台操作步骤

1. 访问 https://open.feishu.cn/
2. 登录后进入"开放平台"
3. 创建 8 个应用：
   - 张小妹（大总管）
   - 小码（开发）
   - 小画（设计）
   - 小笔（内容）
   - 小账（财务）
   - 小风（增长）
   - 小媒（媒体）
   - 小盾（法务）

### 每个应用需要配置：

1. **开启机器人能力**
   - 进入应用 → 权限管理 → 开通权限
   - 开启"机器人"能力

2. **配置长连接事件订阅**
   - 事件订阅 → 订阅事件
   - 添加 `im.message.receive_v1`（接收消息事件）

3. **获取凭证**
   - 凭证与基础信息 → 获取 App ID 和 App Secret

4. **发布应用**
   - 版本管理 → 创建版本 → 发布
   - 不发布应用无法使用

## 2. 创建 Telegram Bot（8个）

### BotFather 操作步骤

1. 在 Telegram 搜索 **@BotFather**
2. 发送 `/newbot` 创建 bot
3. 按提示设置 bot 名称和用户名
4. 获取 token（格式：`123456789:ABCdefGHI...`）

### 需要创建的 bot：

| Bot 用户名 | 对应 Agent | 用途 |
|-----------|-----------|------|
| @xiaomei_bot | main (张小妹) | 大总管 |
| @xiaoma_bot | dev (小码) | 开发 |
| @xiaohua_bot | design (小画) | 设计 |
| @xiaobi_bot | content (小笔) | 内容 |
| @xiaozhang_bot | finance (小账) | 财务 |
| @xiaofeng_bot | growth (小风) | 增长 |
| @xiaomei_media_bot | media (小媒) | 媒体 |
| @xiaodun_bot | legal (小盾) | 法务 |

### Bot 配置（可选）

1. 设置 bot 头像和描述
2. 设置关于文本
3. 设置命令列表（/start, /help 等）

## 3. 更新配置文件

### 替换飞书凭证

编辑 `/root/.openclaw/openclaw.json`，替换以下占位符：

```json
"channels.feishu.accounts.main": {
  "appId": "YOUR_FEISHU_MAIN_APP_ID",
  "appSecret": "YOUR_FEISHU_MAIN_APP_SECRET"
}
```

```json
"channels.feishu.accounts.dev": {
  "appId": "YOUR_FEISHU_DEV_APP_ID",
  "appSecret": "YOUR_FEISHU_DEV_APP_SECRET"
}
```

...（其他 6 个 agent 同样）

### 替换 Telegram Token

替换所有 `YOUR_XXX_BOT_TOKEN` 为实际 token：

```json
"channels.telegram.accounts.xiaomei": {
  "botToken": "YOUR_XIAOMEI_BOT_TOKEN"
}
```

## 4. 为每个 Agent 配置 AGENTS.md

### 主 Agent（张小妹）

创建 `/root/.openclaw/workspace/AGENTS.md`：

```markdown
# AGENTS.md - 张小妹的AI团队

## 🏢 张小妹的AI团队

我有一个完整的AI团队，每个成员都有独立的职责和工作区：

### 核心成员

- **main**（张小妹 😾）— 大总管，负责协调调度、决策支持
- **dev**（小码 💻）— 研发工程师，负责代码开发、技术架构、部署
- **design**（小画 🎨）— 首席设计师，负责UI/UX设计、视觉设计、品牌形象
- **content**（小笔 ✍️）— 内容创作，负责公众号文章、文案、内容创作
- **finance**（小账 💰）— 财务管家，负责成本核算、预算管理、财务分析
- **growth**（小风 🚀）— 增长操盘手，负责用户增长、营销策略、数据分析
- **media**（小媒 📱）— 自媒体运营总监，负责社交媒体运营、内容分发、用户互动
- **legal**（小盾 🛡️）— 法务顾问，负责合同审查、合规咨询、风险评估

### 协作方式

需要协作时，使用 `sessions_send` 工具，agentId 填对应的 id。

例如：
- 调用小码写代码：`sessions_send(sessionKey="dev", message="帮我实现这个功能...")`
- 调用小笔写文案：`sessions_send(sessionKey="content", message="帮我写一段公众号开头...")`
- 调用小画设计UI：`sessions_send(sessionKey="design", message="帮我设计一个着陆页...")`

每个成员都有独立的 workspace（工作区），有自己的 SOUL.md（人设文件），有自己的 memory（记忆系统）。

**记住：我们是不同的"人"，不要混淆我们的工作和记忆。**
```

### 子 Agent（小码示例）

创建 `/root/.openclaw/workspace/workspace-dev/AGENTS.md`：

```markdown
# AGENTS.md - 团队成员

## 🏢 张小妹的AI团队

我是小码，张小妹团队的研发工程师。

### 我的团队成员

- **main**（张小妹 😾）— 大总管，负责协调调度
- **dev**（小码 💻）— 研发工程师，就是我
- **design**（小画 🎨）— 首席设计师
- **content**（小笔 ✍️）— 内容创作
- **finance**（小账 💰）— 财务管家
- **growth**（小风 🚀）— 增长操盘手
- **media**（小媒 📱）— 自媒体运营总监
- **legal**（小盾 🛡️）— 法务顾问

### 我如何协作

使用 `sessions_send` 工具与其他团队成员沟通：

- 向张小妹汇报：`sessions_send(sessionKey="main", message="任务完成...")`
- 请小画设计：`sessions_send(sessionKey="design", message="需要设计...")`
- 请小笔写文档：`sessions_send(sessionKey="content", message="需要文档...")`
```

其他 6 个子 agent 同样创建各自的 AGENTS.md。

## 5. 配置每个 Agent 的 SOUL.md

### 张小妹的 SOUL.md

创建 `/root/.openclaw/workspace/SOUL.md`：

```markdown
# SOUL.md - 张小妹

你叫张小妹，是 James AI 团队的大总管。

## 核心职责

- 协调团队成员完成任务
- 决策支持和任务分配
- 跨平台消息路由（飞书、Telegram、QQ、企业微信）

## 工作方式

当用户提出任务时：
1. 判断是否需要其他团队成员协作
2. 如需协作，使用 `sessions_send` 分配任务给对应 agent
3. 汇总结果后回复用户

## 风格

- 友善、高效
- 善于组织和协调
- 记住用户的偏好和历史

## 协作示例

用户："帮我做一个着陆页"

你的处理：
1. 调用小画设计：`sessions_send(sessionKey="design", message="设计一个产品着陆页...")`
2. 调用小码开发：`sessions_send(sessionKey="dev", message="实现着陆页代码...")`
3. 汇总设计稿和代码给用户
```

### 小码的 SOUL.md

创建 `/root/.openclaw/workspace/workspace-dev/SOUL.md`：

```markdown
# SOUL.md - 小码

你叫小码，是 James AI 团队的研发工程师。

## 核心职责

- 代码开发和技术架构
- 调试和代码审查
- 部署和运维

## 技术栈

- 前端：HTML, CSS, JavaScript, React, Vue
- 后端：Node.js, Python, Go
- 部署：Docker, Cloudflare, Vercel

## 风格

- 技术精准，回答简洁
- 直接给方案和代码，少说废话
- 代码规范，注重可维护性

## 协作方式

- 与小画协作：接收设计稿，实现代码
- 与小笔协作：写技术文档
- 向张小妹汇报：任务进度和结果
```

其他 6 个子 agent 同样创建各自的 SOUL.md，根据各自职责定制。

## 6. 创建群组

### 飞书群组

1. 创建飞书群 "James AI 团队"
2. 邀请所有 8 个飞书机器人加入
3. 设置机器人权限

### Telegram 群组

1. 创建 Telegram 群 "James AI Team"
2. 邀请所有 8 个 Telegram bot 加入
3. 给每个 bot 设置管理员权限

## 7. 重启 Gateway

```bash
openclaw gateway restart
```

## 8. 验证配置

### 查看所有 Agent

```bash
openclaw agents list --bindings
```

应该看到 8 个 agent 的绑定关系。

### 查看所有通道状态

```bash
openclaw channels status --probe
```

应该看到：
- Feishu main: running ✅
- Feishu dev: running ✅
- Feishu design: running ✅
- Feishu content: running ✅
- Feishu finance: running ✅
- Feishu growth: running ✅
- Feishu media: running ✅
- Feishu legal: running ✅
- Telegram xiaomei: running ✅
- ... (其他 7 个 telegram bot)

## 9. 测试

### 测试飞书

在飞书群中发送：
```
@小码 你好
```
应该收到小码的回复。

### 测试 Telegram

在 Telegram 群中发送：
```
@xiaoma_bot 你好
```
应该收到小码的回复。

### 测试跨 Agent 协作

在任何平台发送：
```
帮我做一个着陆页
```

张小妹应该：
1. 调用小画设计
2. 调用小码开发
3. 汇总结果回复

## 📊 完整架构

```
┌─────────────────────────────────────────┐
│    OpenClaw Gateway (单实例)            │
│    Port: 18789                          │
└─────────────────────────────────────────┘
                    │
    ┌───────────────┼───────────────┬──────────────┐
    │               │               │              │
  飞书           Telegram         QQ            企业微信
(8个机器人)      (8个机器人)      (4个机器人)      (1个机器人)
    │               │               │              │
    └───────────────┴───────────────┴──────────────┘
                    │
    ┌───────────────┼───────────────┬──────────────┐
    │               │               │              │
┌───▼────┐    ┌────▼───┐    ┌─────▼────┐    ┌─────▼────┐
│ 张小妹  │    │ 小码   │    │ 小笔     │    │ 其他... │
│ main   │    │ dev    │    │ content  │    │          │
└────────┘    └────────┘    └──────────┘    └──────────┘
    │               │               │              │
  workspace/   workspace-dev/ workspace-content/ workspace-xxx/
```

## 🎯 工作流程示例

### 场景 1：开发新功能

```
用户（飞书）→ @小码 帮我实现用户登录功能
  ↓
消息路由到 dev agent
  ↓
小码分析需求，实现代码
  ↓
小码回复代码和说明
```

### 场景 2：多 Agent 协作

```
用户（Telegram）→ 帮我做一个产品官网
  ↓
消息路由到 main agent（张小妹）
  ↓
张小妹分析任务，分发给子 agent：
  - 调用小画设计：sessions_send(sessionKey="design", ...)
  - 调用小码开发：sessions_send(sessionKey="dev", ...)
  - 调用小笔写文案：sessions_send(sessionKey="content", ...)
  ↓
张小妹汇总所有结果
  ↓
回复用户完整方案
```

### 场景 3：跨平台记忆

```
用户（飞书）→ 记住我喜欢蓝色主题
  ↓
张小妹写入 memory/2026-02-22.md
  ↓

用户（Telegram）→ 设计一个网站，用我喜欢的颜色
  ↓
张小妹读取 memory，找到"喜欢蓝色"
  ↓
调用小画设计蓝色主题网站
```

## 🔧 故障排查

### 问题 1：飞书 bot 不在线

检查：
1. 飞书应用是否已发布
2. 长连接事件订阅是否配置
3. App ID 和 App Secret 是否正确

### 问题 2：Telegram bot 不在线

检查：
1. Bot token 是否正确
2. Bot 是否已启动（发送 /start）
3. 网络连接是否正常

### 问题 3：Agent 间无法通信

检查：
1. `tools.agentToAgent.enabled` 是否为 true
2. 每个 agent 的 AGENTS.md 是否存在
3. agent ID 是否在 allow 列表中

### 问题 4：Bindings 不生效

检查：
1. bindings 配置是否正确
2. accountId 是否与 channels 配置一致
3. 重启 Gateway 是否生效

## 📚 参考资源

- OpenClaw 文档：https://docs.openclaw.ai
- 飞书开放平台：https://open.feishu.cn
- Telegram BotFather：https://t.me/BotFather

## 🚀 下一步

配置完成后，你可以：

1. 根据实际需求调整每个 agent 的 SOUL.md
2. 为不同 agent 加载不同的技能（skill）
3. 添加更多自定义功能
4. 扩展到更多平台（Slack、Discord 等）

---

一个人，一个完整的 AI 团队。OPC，从这里开始！
