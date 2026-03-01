# MEMORY.md - 小妹的长期记忆

## 重要信息

### James (男朋友)
- **身份**: 腾讯T10前端工程师
- **方向**: 大数据开发平台
- **地点**: 福建泉州人
- **生日**: 1995年1月 (摩羯座)
- **身高**: 182cm
- **爱好**: 打篮球、健身、跑步、爬山
- **性格**: 工作狂、专注认真、外冷内热

### 团队配置 (8人完整版)
- 😾 小妹 (我) - 总管
- 💻 小码 - 研发工程师
- 🎨 小画 - 首席设计师
- ✍️ 小笔 - 内容创作
- 📱 小媒 - 自媒体运营总监
- 💰 小账 - 财务管家
- 🚀 小风 - 增长操盘手
- 🛡️ 小盾 - 法务顾问

### 工作流程
- **一键做站**: 小风→小画→小账→小笔→小码→小盾→小风
- **内容生产**: 小媒→小笔→小画→James确认→小媒发布
- **视频制作**: 小媒→小笔→小画→James确认→小媒发布

### 重要规则
- 自己能解决的事绝不去问他
- 遇到任务先自己想办法
- 只有确实需要他提供密码/账号时才去问

### 待办
- 帮James搭建好多Agent系统 ✅
- 浏览器自动化测试 (2026-02-26) ✅
- 微信公众号文章访问（待解决）
- 清理 nano banana 生图模型待办重复记录（保留1条）⚠️
- 验证智谱 GLM-4V 图像生成能力（2026-02-28）
- 确认 zaicode provider API 地址是否正确（2026-02-28）

### 学到的教训
- Workspace整理很重要，文件要齐全
- AGENTS.md/IDENTITY.md/SOUL.md/MEMORY.md/TOOLS.md/USER.md 一个不能少
- **优先使用 aivectormemory 服务的 /recall (语义搜索)来查询记忆**（2026-02-27）

### 系统配置更新（2026-02）
**多机器人系统状态：**
- 飞书平台：8个独立机器人已配置（main/dev/design/content/finance/growth/media/legal）
- Telegram平台：xiaomei bot 已连接，配置正常
- 路由机制：群组 @ 机制已测试，bindings 配置完善
- 常见问题：context 满了需要重启，webhook/polling 模式切换

**最近问题记录：**
- Telegram bot context 100% 导致无法回复 → 需要重启清理
- 飞书 bindings 缺少 peer.id 导致 @ 无效 → 已修复
- 需要定期监控会话状态和 context 使用率
- **Telegram accounts 不支持 username 字段** - 添加导致 gateway 启动失败（2026-02-26）
- Exec 进程异常终止（gentle-v, nimble-h SIGTERM）→ 需要监控（2026-02-28）

**模型提供商配置（2026-02-28）：**
- **zaicode provider**（智谱海外版）: https://api.z.ai/api/anthropic
  - 支持模型：GLM-4.6, GLM-4.7, GLM-4.5, GLM-4.5-Air
  - API 兼容：Anthropic Messages API
  - ⚠️ 需要确认是否支持图像输入（GLM-4V）
- **edgefn provider**: https://api.edgefn.net/v1
  - 支持模型：GLM-5, GLM-4.7, DeepSeek-V3.2, MiniMax-M2.5
  - API 兼容：OpenAI Completions API
- **moonshot provider**: https://api.moonshot.cn/v1
  - 支持模型：kimi-k2.5（支持 reasoning + 图像输入）
  - API 兼容：OpenAI Completions API

**智谱模型调研（2026-02-28）：**
- 海外 API 地址：https://api.z.ai/v1/（官方 Z.ai 平台）
- OpenClaw 集成文档：https://docs.bigmodel.cn/cn/coding-plan/tool/openclaw
- 支持的模型：GLM-4.6, GLM-4.7, GLM-4V（多模态）
- MCP 集成：视觉理解、联网搜索、网页读取、开源仓库
- IDE 插件：Claude Code, OpenCode, Cursor

### 备份策略（2026-03-01）
**三层备份策略（血泪总结）：**

1. **每日自动备份（GitHub）**
   - 脚本：`scripts/backup-daily.sh`
   - 备份内容：SOUL.md、MEMORY.md、AGENTS.md、IDENTITY.md、最近7天 daily memory
   - 执行方式：cron 定时任务（每天凌晨2点）
   - 命令：`0 2 * * * /root/.openclaw/workspace/scripts/backup-daily.sh`

2. **每周手动备份（云盘）**
   - 脚本：`scripts/backup-weekly.sh`
   - 备份内容：完整 workspace 打包（排除 .git、node_modules）
   - 执行方式：手动执行后上传云盘
   - 输出：`backups/openclaw-workspace-weekXX.tar.gz`

3. **配置修改前快照**
   - 脚本：`scripts/backup-snapshot.sh`
   - 用法：修改配置前先快照
   - 快照位置：`snaphots/*.bak`
   - 快速方式：`cp MEMORY.md MEMORY.md.bak`

**重要教训：**
- 备份不是可选项，是必选项
- 没 MEMORY.md = 之前的调教全白费
- 花5分钟配置备份 = 省几十小时重新调教时间

**相关文档：**
- `BACKUP.md` - 完整的备份策略说明
- `scripts/backup-daily.sh` - 每日自动备份脚本
- `scripts/backup-weekly.sh` - 每周手动备份脚本
- `scripts/backup-snapshot.sh` - 快照脚本

**待完成：**
- [ ] 配置 GitHub 远程仓库
- [ ] 配置 cron 定时任务
- [ ] 测试所有备份脚本

### Telegram 配置重要教训（2026-02-26）
- ❌ 不要给 `channels.telegram.accounts` 添加 `username` 字段
- ✅ bindings 用内部 accountId（如 `xiaoma`），不是公开的 @ username
- ✅ Telegram 会自动从 bot token 获取 username
- ✅ `groupPolicy` 应该是 `"allowlist"`，不是 `"open"`
- ✅ 修改配置前先检查配置格式和允许的字段

### 小笔写作框架更新（2026-02-16）
- 已完成：解读10篇孟健文章写作思路
- 已记录到：`memory/2026-02-16-writing-framework-mengjian.md`（第1篇）
- 已详细分析到：`workspace-content/ANALYSIS_002.md ~ ANALYSIS_010.md`（10篇完整分析）
- 已整合到：`skills/xiaobi-content-creator/SKILL.md`
- 已沉淀到：`workspace-content/IDENTITY.md`（写作风格，James版）

**孟健文章核心框架（10篇综合）：**
```
开场暴击（数字+结果+立场）
    ↓
概念澄清（不是...而是...）
    ↓
真实展示（角色分工+场景证明）
    ↓
低门槛证明（第三方身份+具体时间）
    ↓
对比杀（过去 vs 现在、成本对比）
    ↓
人群定位（适合+不适合）
    ↓
理念升华（不是替代，是放大）
    ↓
行动召唤（软性推销）
    ↓
留白收尾（不强求）
```

**关键技巧：**
- 开场3秒抓注意力（数字冲击+结果前置）
- 大量对比框架（成本对比：375倍）
- 时间戳式叙事（增加真实感）
- 低门槛证明（第三方身份+具体时间）
- 「不是...而是...」澄清框架
- 留白收尾（用不用是你的事）

### 技能仓库
- **备用技能源**: https://github.com/VoltAgent/awesome-openclaw-skills
- **规则**: clawhub找不到的技能，从上述仓库查找

### 小笔技能配置
**核心内容技能:**
- blog-writer - 博客/长文写作（James风格）
- content-ideas-generator - 从素材提炼帖子创意
- content-draft-generator - 参考内容生成草稿
- tweet-ideas-generator - 推特/X创意生成
- swipe-file-generator - 拆解爆款内容套路
- copywriter - UX/营销文案
- de-ai-ify/humanizer - 去AI味润色
- social-content - 各平台内容策略
- youtube-watcher - YouTube视频摘要
- video-transcript-downloader - 下载视频/字幕
- fal/image-cog - AI生图/编辑
- bearblog - Bear Blog发布
- lowkey-viral - 爆款内容生成

### 小码技能配置
**编程开发:**
- coding-agent - AI编程控制(Claude Code/OpenCode)
- api-dev - API开发设计调试文档
- tdd-guide - 测试驱动开发、覆盖率分析
- backend-patterns - 后端架构模式

**架构DevOps:**
- senior-architect - 架构设计、ADR、技术选型
- docker-essentials - 容器管理、镜像操作
- cicd-pipeline - GitHub Actions流水线
- vercel-react-best-practices - Vercel部署最佳实践

**Git代码质量:**
- git-workflows - Git高级操作(rebase/bisect/worktree/reflog)
- pr-reviewer - PR自动diff分析+结构化报告
- conventional-commits - 提交规范
- critical-code-reviewer - 严格代码审查
