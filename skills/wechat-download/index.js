#!/usr/bin/env node

/**
 * 微信公众号文章下载 Skill
 * 使用 Playwright 自动操作浏览器
 */

const { spawn } = require('child_process');
const path = require('path');

// 启动浏览器服务（在 VNC 中运行）
function startBrowserService() {
  return new Promise((resolve, reject) => {
    console.log('正在启动浏览器服务...');
    const browser = spawn('chromium-browser', [
      '--no-sandbox',
      '--disable-setuid-sandbox',
      '--disable-dev-shm-usage',
      '--remote-debugging-port=9222',
      'http://127.0.0.1:8080'
    ], {
      stdio: ['ignore', 'pipe', 'pipe'],
      detached: true,
      background: true
    });

    browser.stdout.on('data', (data) => {
      console.log(`[浏览器] ${data.toString().trim()}`);
    });

    browser.stderr.on('data', (data) => {
      console.error(`[浏览器错误] ${data.toString().trim()}`);
    });

    browser.on('spawn', () => {
      console.log('✅ 浏览器服务已启动');
      console.log('');
      console.log('📌 提示：');
      console.log('1. 使用 VNC 客户端连接到端口 5901');
      console.log('2. 浏览器已启动，可以在 VNC 中操作');
      console.log('3. CDP 端口：9222');
      resolve(browser);
    });

    browser.on('error', (err) => {
      console.error('❌ 浏览器启动失败:', err);
      reject(err);
    });

    // 10秒超时
    setTimeout(() => {
      if (!browser.killed) {
        console.warn('⚠️  浏览器启动超时');
        resolve(null);
      }
    }, 10000);
  });
}

// 获取微信文章内容
async function fetchWechatArticle(url) {
  console.log(`正在获取文章: ${url}`);

  // TODO: 使用 Playwright CDP 连接
  // 需要 playwright-chromium 和 chrome-remote-interface
  
  return {
    url,
    title: '微信文章',
    content: '需要手动在浏览器中复制内容，或者使用 Playwright 自动化',
    status: 'pending_manual'
  };
}

// 主函数
async function main() {
  const args = process.argv.slice(2);
  const action = args[0];

  console.log('='.repeat(50));
  console.log('微信公众号文章下载工具');
  console.log('='.repeat(50));
  console.log('');

  switch (action) {
    case 'start-browser':
      await startBrowserService();
      break;

    case 'fetch':
      const url = args[1];
      if (!url) {
        console.log('用法: wechat-download fetch <微信文章链接>');
        process.exit(1);
      }

      const result = await fetchWechatArticle(url);
      console.log('');
      console.log('结果:');
      console.log(JSON.stringify(result, null, 2));
      break;

    default:
      console.log('用法:');
      console.log('  wechat-download start-browser  - 启动浏览器服务（VNC 模式）');
      console.log('  wechat-download fetch <url>      - 获取微信文章');
      console.log('');
      console.log('示例:');
      console.log('  wechat-download start-browser');
      console.log('  wechat-download fetch https://mp.weixin.qq.com/s/xxx');
      break;
  }
}

main().catch(console.error);
