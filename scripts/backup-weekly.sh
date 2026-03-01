#!/bin/bash
# 每周手动备份脚本 - 打包整个 workspace

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

log() {
    echo -e "${GREEN}[Weekly Backup]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[Weekly Backup]${NC} $1"
}

DATE=$(date +%Y-%m-%d)
WEEK=$(date +%Y-W%V)
BACKUP_NAME="openclaw-workspace-week${WEEK}.tar.gz"

cd ~/.openclaw || exit 1

log "开始每周备份 - 第 $(date +%W) 周"

# 创建备份目录
mkdir -p backups

# 排除不必要的文件和目录
log "📦 打包 workspace..."
tar -czf "backups/${BACKUP_NAME}" \
    --exclude='.git' \
    --exclude='node_modules' \
    --exclude='*.pyc' \
    --exclude='__pycache__' \
    --exclude='snapshots' \
    --exclude='backups' \
    --exclude='*.log' \
    workspace/ 2>/dev/null || tar -czf "backups/${BACKUP_NAME}" \
    --exclude='.git' \
    --exclude='node_modules' \
    --exclude='*.pyc' \
    --exclude='__pycache__' \
    --exclude='snapshots' \
    --exclude='backups' \
    --exclude='*.log' \
    . 2>/dev/null

# 计算文件大小
SIZE=$(du -h "backups/${BACKUP_NAME}" | cut -f1)

log "✅ 备份完成: ${BACKUP_NAME} (${SIZE})"
log "📍 位置: ~/.openclaw/backups/${BACKUP_NAME}"
warn "💡 请手动将此文件上传到云盘（坚果云、百度网盘、Google Drive 等）"
