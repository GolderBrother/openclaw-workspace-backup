#!/bin/bash
# 每日自动备份脚本
# 备份最重要的记忆文件到 GitHub

set -e  # 遇到错误立即退出

# 颜色输出
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 日志函数
log() {
    echo -e "${GREEN}[Backup]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[Backup]${NC} $1"
}

# 日期
DATE=$(date +%Y-%m-%d)
TIME=$(date +%H:%M:%S)

log "开始每日备份 - $DATE $TIME"

# 进入工作目录
cd ~/.openclaw/workspace || exit 1

# 检查 Git 仓库
if [ ! -d ".git" ]; then
    warn "⚠️  当前目录不是 Git 仓库，初始化中..."
    git init
    log "✅ Git 仓库已初始化"
fi

# 添加重要文件
log "📝 添加重要记忆文件..."
git add SOUL.md MEMORY.md AGENTS.md IDENTITY.md 2>/dev/null || true

# 添加 daily memory（最近 7 天）
for i in {0..6}; do
    FILE_DATE=$(date -d "$i days ago" +%Y-%m-%d 2>/dev/null || date -v-${i}d +%Y-%m-%d)
    if [ -f "memory/${FILE_DATE}.md" ]; then
        git add "memory/${FILE_DATE}.md"
        log "  - memory/${FILE_DATE}.md"
    fi
done

# 检查是否有改动
if git diff --cached --quiet; then
    log "✨ 没有新的改动需要提交"
    exit 0
fi

# 提交
COMMIT_MSG="Daily backup: $DATE"
git commit -m "$COMMIT_MSG"
log "✅ 已提交: $COMMIT_MSG"

# 推送到远程仓库（如果配置了）
if git remote | grep -q "origin"; then
    log "🚀 推送到远程仓库..."
    git push origin main 2>&1 || git push origin master 2>&1 || warn "⚠️  推送失败，请检查远程仓库配置"
else
    warn "⚠️  没有配置远程仓库 (git remote add origin <your-repo-url>)"
fi

log "✨ 备份完成！"
