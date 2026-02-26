---
name: wechat-download
description: 微信公众号文章下载（Playwright 自动化）
version: 1.0.0
author: 小码

## 功能

使用 Playwright 自动化操作浏览器，下载微信公众号文章

### 主要功能
1. **启动浏览器服务** - 在 VNC 中运行有界面浏览器
2. **自动操作** - 点击、表单填写、页面导航
3. **内容提取** - 提取文章正文
4. **截图保存** - 保存页面截图

## 使用方式

### 1. 启动浏览器服务
```bash
wechat-download start-browser
```
这将启动 chromium-browser 并开放：
- **VNC 端口**: 5901
- **Chrome DevTools 端口**: 9222
- **HTTP 端口**: 8080

在本地使用 VNC 客户端连接到 `localhost:5901`

### 2. 获取微信文章
```bash
wechat-download fetch <微信文章链接>
```

## 依赖

- chromium-browser (已安装）
- VNC server (已安装）
- Openbox (已安装）
- Playwright (已安装）

## 注意事项

1. **首次运行需要**：需要在浏览器中手动登录微信一次
2. **VNC 访问**：使用 VNC 客户端连接到服务器 5901 端口
3. **自动化限制**：微信有反爬虫机制，部分操作可能需要人工介入

## 高级用法

### 浏览器自动化

启动浏览器服务后，可使用 `/root/scripts/browser-automation.js` 进行自动化：

```bash
# 截图
browser-automation screenshot <url> <filename.png>

# 点击元素
browser-automation click <url> <selector>

# 填写表单
browser-automation fill-form <url> '{"#username": "admin", "#password": "123456"}'

# 获取页面内容
browser-automation get-content <url>
```

## 技术细节

- **浏览器**: Chromium (OpenCloudOS 内置）
- **自动化工具**: Playwright
- **VNC**: TigerVNC
- **桌面**: Openbox

## 示例

```bash
# 1. 启动浏览器服务
wechat-download start-browser

# 2. 连接 VNC 查看浏览器
vncviewer <服务器IP>:5901

# 3. 获取微信文章
wechat-download fetch https://mp.weixin.qq.com/s/xxx
```

## 故障排查

### 浏览器服务启动失败
```bash
# 检查端口占用
netstat -tulpn | grep 5901
netstat -tulpn | grep 9222

# 手动启动浏览器
chromium-browser --no-sandbox --disable-setuid-sandbox
```

### VNC 无法连接
```bash
# 检查 VNC 服务状态
systemctl status vncserver

# 查看 VNC 日志
tail -50 /var/log/vncserver.log
```
