# 备份策略说明

> 血泪总结！备份不是可选项，是必选项。
>
> 我见过太多人因为没备份而哭的：
> - MEMORY.md 被搞坏了，之前教的东西全没了
> - 换服务器忘了迁移配置，从零开始调教
> - 误删了工作目录，几个月的记忆没了

---

## 三层备份策略

### 1. 每天自动快照（cron）

每天自动把最重要的记忆文件推送到 GitHub。

**备份内容：**
- SOUL.md - 我的灵魂和性格
- MEMORY.md - 长期记忆
- AGENTS.md - 团队配置
- IDENTITY.md - 身份档案
- 最近 7 天的 daily memory

**脚本：** `scripts/backup-daily.sh`

**配置 cron：**
```bash
# 编辑 crontab
crontab -e

# 添加每天凌晨 2 点自动备份
0 2 * * * /root/.openclaw/workspace/scripts/backup-daily.sh >> /root/.openclaw/workspace/backups/backup.log 2>&1
```

---

### 2. 每周手动备份（云盘）

每周把整个 workspace 打包，存到云盘（坚果云、百度网盘、Google Drive 等）。

**脚本：** `scripts/backup-weekly.sh`

**使用方法：**
```bash
cd ~/.openclaw/workspace
./scripts/backup-weekly.sh
```

**备份文件：** `backups/openclaw-workspace-weekXX.tar.gz`

---

### 3. 重要修改前快照

改配置前，先创建快照，防止改坏了回不去。

**脚本：** `scripts/backup-snapshot.sh`

**使用方法：**
```bash
# 修改配置前
./scripts/backup-snapshot.sh "准备修改模型配置"

# 快照会保存到 snapshots/ 目录
# 例如: snapshots/MEMORY.md.20260301_143022.bak
```

**快速手动快照：**
```bash
# 快速备份 MEMORY.md
cp MEMORY.md MEMORY.md.bak

# 快速备份 SOUL.md
cp SOUL.md SOUL.md.bak
```

---

## 脚本清单

| 脚本 | 用途 | 频率 | 位置 |
|------|------|------|------|
| `backup-daily.sh` | GitHub 自动备份 | 每天（cron） | `scripts/` |
| `backup-weekly.sh` | 完整打包备份 | 每周（手动） | `scripts/` |
| `backup-snapshot.sh` | 配置修改前快照 | 需要时（手动） | `scripts/` |

---

## 快速开始

### 1. 配置 GitHub 仓库

```bash
cd ~/.openclaw/workspace

# 初始化 Git 仓库（如果还没有）
git init

# 添加远程仓库（替换成你自己的）
git remote add origin https://github.com/your-username/openclaw-workspace.git

# 推送到远程（首次）
git push -u origin main
```

### 2. 配置 cron 自动备份

```bash
# 编辑 crontab
crontab -e

# 添加这一行（每天凌晨 2 点）
0 2 * * * /root/.openclaw/workspace/scripts/backup-daily.sh >> /root/.openclaw/workspace/backups/backup.log 2>&1

# 保存退出
```

### 3. 测试备份脚本

```bash
# 测试每日备份
./scripts/backup-daily.sh

# 测试每周备份
./scripts/backup-weekly.sh

# 测试快照
./scripts/backup-snapshot.sh "测试快照"
```

---

## 恢复备份

### 从 GitHub 恢复

```bash
cd ~/.openclaw/workspace
git pull origin main
```

### 从快照恢复

```bash
# 列出所有快照
ls -lh snapshots/

# 恢复某个文件（例如 MEMORY.md）
cp snapshots/MEMORY.md.20260301_143022.bak MEMORY.md
```

### 从云盘恢复

```bash
# 解压云盘下载的备份包
cd ~/.openclaw
tar -xzf openclaw-workspace-weekXX.tar.gz

# 覆盖 workspace（注意备份当前版本）
```

---

## 检查清单

- [ ] 配置了 GitHub 仓库
- [ ] 配置了 cron 自动备份
- [ ] 测试了所有备份脚本
- [ ] 记住了每周手动备份
- [ ] 修改配置前记得快照
- [ ] 定期检查备份是否成功

---

**花 5 分钟配置好备份，能省你几十个小时的重新调教时间。** ⏱️

---

*记录人：张小妹* 😾
*创建时间：2026-03-01*
