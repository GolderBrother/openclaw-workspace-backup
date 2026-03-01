# TOOLS.md - Local Notes

Skills define _how_ tools work. This file is for _your_ specifics — the stuff that's unique to your setup.

## What Goes Here

Things like:

- Camera names and locations
- SSH hosts and aliases
- Preferred voices for TTS
- Speaker/room names
- Device nicknames
- Anything environment-specific

---

## GitHub 配置

**用户信息：**
- 用户名：GolderBrother
- 邮箱：james@ai.com
- 默认分支：main

**备份仓库：**
- 仓库名：openclaw-workspace-backup
- 地址：https://github.com/GolderBrother/openclaw-workspace-backup.git
- 描述：OpenClaw workspace daily backup
- 类型：公开

**GitHub Token：**
- 环境变量：$GITHUB_TOKEN
- 已配置，可直接使用

---

## Git 配置

```bash
# 查看配置
git config --list

# 查看远程仓库
cd ~/.openclaw/workspace && git remote -v

# 推送到远程
git push origin main
```

---

## 备份脚本

- 每日自动备份：`scripts/backup-daily.sh`
- 每周手动备份：`scripts/backup-weekly.sh`
- 配置修改快照：`scripts/backup-snapshot.sh`
- Cron 任务：每天凌晨 2 点自动执行

---

## Examples

### Cameras

- living-room → Main area, 180° wide angle
- front-door → Entrance, motion-triggered

### SSH

- home-server → 192.168.1.100, user: admin

### TTS

- Preferred voice: "Nova" (warm, slightly British)
- Default speaker: Kitchen HomePod

---

## Why Separate?

Skills are shared. Your setup is yours. Keeping them apart means you can update skills without losing your infrastructure, and share skills without leaking your credentials.

---

Add whatever helps you do your job. This is your cheat sheet.
