#!/bin/bash
# 每日自动备份脚本 - 智能版本
# 只在有改动时才提交和推送，避免空提交

set -e

# 颜色输出
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# 日志函数
log() {
    echo -e "${GREEN}[Backup]${NC} $1"
}
warn() {
    echo -e "${YELLOW}[Backup]${NC} $1"
}
error() {
    echo -e "${RED}[Backup]${NC} $1"
}

# 日期
DATE=$(date +%Y-%m-%d)
TIME=$(date +%H:%M:%S)

log "开始每日备份检查 - $DATE $TIME"

# 进入工作目录
cd ~/.openclaw/workspace || exit 1

# 检查 Git 仓库
if [ ! -d ".git" ]; then
    error "当前目录不是 Git 仓库"
    exit 1
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
    log "📊 本地和远程仓库保持一致"
    exit 0
fi

# 有改动，先检查远程
log "🔍 检测到改动，检查远程仓库状态..."

if git remote | grep -q "origin"; then
    # 拉取最新远程状态（不合并，只检查）
    log "📡 拉取远程仓库状态..."
    git fetch origin >/dev/null 2>&1 || warn "无法连接远程仓库"

    # 检查本地和远程是否有差异
    if git diff --cached origin/main --quiet 2>/dev/null; then
        if git diff --cached origin/master --quiet 2>/dev/null; then
            log "⚠️  虽然本地有改动，但内容与远程仓库相同"
            log "📊 无需提交"
            exit 0
        fi
    fi

    # 提交
    COMMIT_MSG="Daily backup: $DATE $TIME"
    git commit -m "$COMMIT_MSG"
    log "✅ 已提交: $COMMIT_MSG"

    # 推送
    log "🚀 推送到远程仓库..."
    if git push origin main 2>&1; then
        log "✅ 推送成功！"
    elif git push origin master 2>&1; then
        log "✅ 推送成功！"
    else
        error "❌ 推送失败，请检查网络连接"
        exit 1
    fi
else
    # 没有远程仓库，只提交不推送
    COMMIT_MSG="Daily backup: $DATE $TIME (no remote)"
    git commit -m "$COMMIT_MSG"
    log "✅ 已提交本地（未配置远程仓库）"
    warn "💡 建议配置远程仓库: git remote add origin <url>"
fi

log "✨ 备份完成！"
