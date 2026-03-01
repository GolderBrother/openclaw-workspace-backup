# 备份策略说明

> 血泪总结！备份不是可选项，是必选项。
>
> 我见过太多人因为没备份而哭的：
> - MEMORY.md 被搞坏了，之前教的东西全没了
> - 换服务器忘了迁移配置，从零开始调教
> - 误删了工作目录，几个月的记忆没了

---

## 三层备份策略

### 1. 每天自动快照（cron + GitHub）✅ 已配置

**每天凌晨 2 点自动检查并备份：**

- **智能检查**：先检查本地和远程仓库是否有差异
- **有改动才提交**：避免空提交，保持仓库清洁
- **自动推送**：有改动就推送到 GitHub
- **无改动跳过**：如果没有改动，直接退出，不提交

**备份内容：**
- SOUL.md - 我的灵魂和性格
- MEMORY.md - 长期记忆
- AGENTS.md - 团队配置
- IDENTITY.md - 身份档案
- 最近 7 天的 daily memory

**脚本：** `scripts/backup-daily.sh`

**GitHub 仓库：**
- 地址：https://github.com/GolderBrother/openclaw-workspace-backup
- 分支：main
- 已配置远程推送

**Cron 配置：**
```bash
# 每天凌晨 2 点执行
0 2 * * * /root/.openclaw/workspace/scripts/backup-daily.sh >> /root/.openclaw/workspace/backups/backup.log 2>&1
```

**测试状态：** ✅ 已测试通过
- 第一次执行：检测到改动，提交并推送成功
- 第二次执行：检测到无改动，正确跳过

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

**排除内容：**
- `.git/` - Git 仓库历史
- `node_modules/` - 依赖包
- `__pycache__/` - Python 缓存
- `snapshots/` - 已有的快照
- `backups/` - 已有的备份
- `*.log` - 日志文件

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

| 脚本 | 用途 | 频率 | 状态 |
|------|------|------|------|
| `backup-daily.sh` | GitHub 智能备份 | 每天（cron） | ✅ 已配置 |
| `backup-weekly.sh` | 完整打包备份 | 每周（手动） | ✅ 就绪 |
| `backup-snapshot.sh` | 配置修改前快照 | 需要时（手动） | ✅ 就绪 |

---

## 已完成的配置 ✅

- [x] 创建 GitHub 备份仓库（openclaw-workspace-backup）
- [x] 配置 Git 远程仓库（origin）
- [x] 编写智能备份脚本（有改动才提交）
- [x] 测试备份脚本（两次测试：有改动/无改动）
- [x] 配置 cron 定时任务（每天凌晨 2 点）
- [x] 创建备份日志目录
- [x] 推送现有代码到 GitHub

---

## 每周手动任务 📋

**每周日晚上提醒自己：**
1. 执行 `./scripts/backup-weekly.sh`
2. 将生成的 tar.gz 文件上传到云盘
3. 检查 GitHub 备份是否正常

---

## 快速开始（如果需要重新配置）

### 1. 测试每日备份

```bash
cd ~/.openclaw/workspace
./scripts/backup-daily.sh
```

### 2. 查看备份日志

```bash
cat /root/.openclaw/workspace/backups/backup.log
```

### 3. 查看最近提交

```bash
cd ~/.openclaw/workspace
git log --oneline -10
```

### 4. 手动触发备份

```bash
# 添加文件并提交
git add SOUL.md MEMORY.md AGENTS.md IDENTITY.md
git commit -m "Manual backup: $(date +%Y-%m-%d)"
git push origin main
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

## 智能备份逻辑

备份脚本的工作流程：

1. **添加重要文件到暂存区**
2. **检查是否有改动**
   - 无改动 → 退出（不提交）
   - 有改动 → 继续
3. **拉取远程仓库状态**
4. **比较本地和远程**
   - 内容相同 → 退出（不提交）
   - 内容不同 → 继续
5. **提交改动**
6. **推送到远程**

这样的好处：
- 避免空提交污染历史
- 只在真正有改动时才推送
- 节省网络流量和存储空间

---

## 检查清单

- [x] 配置了 GitHub 仓库
- [x] 配置了 cron 自动备份
- [x] 测试了备份脚本
- [ ] 记得每周手动备份
- [ ] 修改配置前记得快照
- [ ] 定期检查备份日志

---

**花 5 分钟配置好备份，能省你几十个小时的重新调教时间。** ⏱️

---

*记录人：张小妹* 😾
*创建时间：2026-03-01*
*最后更新：2026-03-01 - 已配置完整的自动备份系统*
