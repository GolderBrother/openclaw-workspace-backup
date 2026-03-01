#!/bin/bash
# 配置修改前的快照脚本
# 用法: ./backup-snapshot.sh "修改了什么"

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

log() {
    echo -e "${GREEN}[Snapshot]${NC} $1"
}

DESCRIPTION="${1:-配置修改}"
DATE=$(date +%Y%m%d_%H%M%S)
SNAPSHOT_DIR="snapshots"

cd ~/.openclaw/workspace || exit 1

# 创建快照目录
mkdir -p "$SNAPSHOT_DIR"

log "创建快照: $DESCRIPTION"

# 备份重要文件
for file in SOUL.md MEMORY.md AGENTS.md IDENTITY.md; do
    if [ -f "$file" ]; then
        cp "$file" "${SNAPSHOT_DIR}/${file}.${DATE}.bak"
        log "  ✅ ${file}"
    fi
done

log "✨ 快照完成！位置: ~/.openclaw/workspace/$SNAPSHOT_DIR/"
