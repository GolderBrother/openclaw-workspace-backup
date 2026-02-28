#!/bin/bash

# 子 Workspace 技能软链接批量创建脚本
# 用于将全局 skills 软链接到各个子 workspace

set -e

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== 子 Workspace 技能软链接批量创建脚本 ===${NC}\n"

# 子 workspace 列表
WORKSPACES="workspace-media workspace-growth workspace-content workspace-design workspace-finance workspace-legal"

# 需要全局化的 skills（从 workspace-media 复制）
GLOBAL_SKILLS="xhs browser-use bluesky linkedin reddit youtube-watcher"

# 全局 skills 目录
GLOBAL_SKILLS_DIR="/root/.openclaw/workspace/skills"

# 主 workspace 路径
MAIN_WORKSPACE="/root/.openclaw/workspace/workspace-media"

echo -e "${YELLOW}📦 步骤 1：创建全局 skills 目录${NC}"
mkdir -p "$GLOBAL_SKILLS_DIR"
echo -e "${GREEN}✓ 全局目录：$GLOBAL_SKILLS_DIR${NC}\n"

echo -e "${YELLOW}📦 步骤 2：将 skills 移动到全局目录${NC}"
for skill in $GLOBAL_SKILLS; do
    skill_source="$MAIN_WORKSPACE/skills/$skill"
    skill_target="$GLOBAL_SKILLS_DIR/$skill"
    
    if [ -d "$skill_source" ]; then
        if [ ! -d "$skill_target" ]; then
            echo -e "  ${GREEN}移动${NC} $skill → 全局"
            mv "$skill_source" "$skill_target"
        else
            echo -e "  ${YELLOW}跳过${NC} $skill（全局已存在）"
        fi
    else
        echo -e "  ${RED}错误${NC} 找不到 $skill_source"
    fi
done
echo ""

echo -e "${YELLOW}📦 步骤 3：在每个子 workspace 创建软链接${NC}"
for ws in $WORKSPACES; do
    ws_dir="/root/.openclaw/workspace/$ws"
    ws_skills_dir="$ws_dir/skills"
    
    echo -e "${GREEN}处理 $ws...${NC}"
    
    # 创建 skills 目录（如果不存在）
    mkdir -p "$ws_skills_dir"
    
    # 为每个全局 skill 创建软链接
    for skill in $GLOBAL_SKILLS; do
        link_path="$ws_skills_dir/$skill"
        target="$GLOBAL_SKILLS_DIR/$skill"
        
        # 如果软链接不存在，创建它
        if [ ! -e "$link_path" ]; then
            ln -s "$target" "$link_path"
            echo -e "  ${GREEN}✓${NC} 创建软链接: $link_path → $target"
        else
            echo -e "  ${YELLOW}○${NC} 已存在: $link_path"
        fi
    done
    echo ""
done

echo -e "${GREEN}=== ✅ 完成！ ===${NC}"
echo ""
echo -e "${YELLOW}验证方法：${NC}"
echo "  查看某个 workspace 的软链接："
echo "  ls -la /root/.openclaw/workspace/workspace-media/skills/ | grep xhs"
echo ""
echo -e "${YELLOW}删除软链接方法（如需独立定制）：${NC}"
echo "  rm /root/.openclaw/workspace/workspace-media/skills/xhs"
echo "  cp -r /root/.openclaw/workspace/skills/xhs /root/.openclaw/workspace/workspace-media/skills/"
