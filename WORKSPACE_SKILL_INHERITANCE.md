# 子 Agent Skill 继承全局 Skill 的实现方案

## 方案选择：软链接 + 配置说明

**推荐方案：软链接（Symbolic Links）**

### 原理

每个子 workspace 的 `skills/` 目录通过软链接指向全局 `/root/.openclaw/workspace/skills/` 中的对应 skill。

**优点：**
- ✅ 全局更新一次，所有 workspace 自动生效
- ✅ 节省磁盘空间（不重复）
- ✅ 实现简单

**缺点：**
- ⚠️ 子 workspace 不能单独定制 skill（会被全局覆盖）

---

## 实现步骤

### 1. 创建全局 skills 目录（如果不存在）

```bash
mkdir -p /root/.openclaw/workspace/skills
```

### 2. 将全局 skill 移到全局目录

```bash
# 例如：将 xhs skill 移到全局
mv /root/.openclaw/workspace/skills/xhs /root/.openclaw/workspace/skills/
```

### 3. 在子 workspace 创建软链接

```bash
# 进入子 workspace
cd /root/.openclaw/workspace/workspace-media

# 为需要的 skill 创建软链接
ln -s /root/.openclaw/workspace/skills/xhs skills/xhs
ln -s /root/.openclaw/workspace/skills/browser-use skills/browser-use
```

### 4. 验证软链接

```bash
# 查看软链接
ls -la skills/ | grep xhs

# 输出应该是：
# xhs -> /root/.openclaw/workspace/skills/xhs
```

---

## OpenClaw 配置说明

### 配置文件路径

子 agent 的配置文件：`/root/.openclaw/workspace/workspace-media/openclaw.json`

### 配置示例

```json
{
  "skills": {
    "entries": {
      "xhs": {
        "enabled": true
      },
      "browser-use": {
        "enabled": true
      }
    }
  },
  "workspace": "/root/.openclaw/workspace/workspace-media"
}
```

**重要：** OpenClaw 会自动从 `workspace/skills/` 目录加载 skills，软链接和普通目录一样！

---

## 批量创建软链接脚本

```bash
#!/bin/bash

# 子 workspace 列表
WORKSPACES="workspace-media workspace-growth workspace-content workspace-design workspace-finance workspace-legal"

# 需要全局化的 skills（从当前 workspace media 复制）
GLOBAL_SKILLS="xhs browser-use bluesky linkedin reddit youtube-watcher"

# 全局 skills 目录
GLOBAL_SKILLS_DIR="/root/.openclaw/workspace/skills"

# 创建全局目录
mkdir -p "$GLOBAL_SKILLS_DIR"

# 步骤1：将 skills 移到全局目录
for skill in $GLOBAL_SKILLS; do
    if [ -d "/root/.openclaw/workspace/workspace-media/skills/$skill" ]; then
        echo "Moving $skill to global..."
        mv "/root/.openclaw/workspace/workspace-media/skills/$skill" "$GLOBAL_SKILLS_DIR/"
    fi
done

# 步骤2：在每个子 workspace 创建软链接
for ws in $WORKSPACES; do
    ws_dir="/root/.openclaw/workspace/$ws"
    ws_skills_dir="$ws_dir/skills"
    
    echo "Processing $ws..."
    
    # 创建 skills 目录（如果不存在）
    mkdir -p "$ws_skills_dir"
    
    # 为每个全局 skill 创建软链接
    for skill in $GLOBAL_SKILLS; do
        link_path="$ws_skills_dir/$skill"
        target="$GLOBAL_SKILLS_DIR/$skill"
        
        # 如果软链接不存在，创建它
        if [ ! -e "$link_path" ]; then
            ln -s "$target" "$link_path"
            echo "  Created symlink: $link_path -> $target"
        fi
    done
done

echo "✅ 完成！"
```

---

## 删除软链接（如需独立定制）

如果某个子 workspace 需要独立版本的 skill：

```bash
# 删除软链接
rm /root/.openclaw/workspace/workspace-media/skills/xhs

# 复制一份到本地
cp -r /root/.openclaw/workspace/skills/xhs /root/.openclaw/workspace/workspace-media/skills/xhs
```

---

## 最佳实践

### 1. Skill 分类

**全局共享 skills：**
- 通用工具类（agent-browser, agent-browser-2, chrome）
- 平台集成类（xhs, bluesky, linkedin, reddit）
- 内容创作类（blog-writer, copywriter）
- 数据分析类（exchange-rates, polymarket-odds）

**子 workspace 独立 skills：**
- 定制化配置
- 特殊业务逻辑
- 需要独立测试的版本

### 2. 版本管理

更新全局 skill 时：
```bash
# 更新全局 skill
cd /root/.openclaw/workspace/skills/xhs
# 修改代码...

# 所有使用软链接的子 workspace 自动生效！
```

### 3. 注意事项

⚠️ **不要** 在软链接的目录里直接修改文件
- 软链接只是指向，修改会影响全局
- 如需定制，先删除软链接，再复制本地版本

---

## 推荐方案总结

**使用软链接实现继承！**

原因：
1. OpenClaw 原生支持软链接
2. 配置简单，无需特殊设置
3. 全局更新一次，全部生效
4. 节省磁盘空间

**实现优先级：**
1. 移动 skill 到全局目录
2. 在子 workspace 创建软链接
3. 配置 openclaw.json 启用 skill
