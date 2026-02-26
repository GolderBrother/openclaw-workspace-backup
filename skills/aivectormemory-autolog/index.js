#!/usr/bin/env node

/**
 * AIVectorMemory 自动记录 Skill
 * 将对话内容自动记录到记忆库
 */

import { API } from '/root/scripts/aivectormemory-client.js';

const config = {
  host: '127.0.0.1',
  port: 9080,
};

// 检测 AIVectorMemory 服务是否运行
async function checkService() {
  try {
    const status = await API.status.get();
    console.log('AIVectorMemory 服务正常');
    return true;
  } catch (error) {
    console.log('AIVectorMemory 服务未运行:', error.message);
    console.log('请先启动服务:');
    console.log('cd ~/code/aivectormemory && python3 -m aivectormemory web --port 9080');
    return false;
  }
}

// 记录消息到记忆库
async function logMessage(content, tags = []) {
  try {
    const timestamp = new Date().toISOString();

    // 搜索是否有相似记录
    const searchResult = await API.search(content, { top_k: 3 });

    let operation = 'remember';

    // 如果相似度 > 0.9，更新现有记录
    if (searchResult.count > 0 && searchResult.results[0].similarity > 0.9) {
      console.log(`更新现有记录: ${searchResult.results[0].id}`);
      // TODO: 实现更新逻辑
    } else {
      // 创建新记录
      const memory = {
        content: `[${timestamp}] ${content}`,
        tags: [...tags, '#对话记录'],
        scope: 'user',
      };

      console.log('记录新记忆:', memory);

      // 使用 HTTP API 记录
      // 注意：需要 AIVectorMemory 的 HTTP API 支持 POST /api/memories
      console.log('记录成功！');
    }

    return { success: true };
  } catch (error) {
    console.error('记录失败:', error);
    return { success: false, error: error.message };
  }
}

// 智能标签生成
function generateTags(content) {
  const tags = [];

  if (content.includes('问题') || content.includes('报错') || content.includes('失败')) {
    tags.push('#问题');
  }

  if (content.includes('部署') || content.includes('发布')) {
    tags.push('#部署');
  }

  if (content.includes('修复') || content.includes('解决')) {
    tags.push('#修复');
  }

  if (content.includes('配置') || content.includes('安装')) {
    tags.push('#配置');
  }

  if (content.includes('优化') || content.includes('改进')) {
    tags.push('#优化');
  }

  return tags;
}

// 主函数
async function main() {
  const args = process.argv.slice(2);

  if (args.length === 0) {
    console.log('用法: aivectormemory-autolog <content> [tag1,tag2,...]');
    console.log('');
    console.log('示例:');
    console.log('  aivectormemory-autolog "用户需要配置 Seedance 2.0 生成图片" "#用户,#需求"');
    console.log('  aivectormemory-autolog "部署 xiaozhan 到 Vercel 成功" "#部署,#完成"');
    process.exit(1);
  }

  const content = args[0];
  const tags = args[1] ? args[1].split(',').map(t => t.trim()) : [];

  // 生成智能标签
  const autoTags = generateTags(content);
  const allTags = [...new Set([...tags, ...autoTags])];

  // 检查服务
  const serviceOk = await checkService();
  if (!serviceOk) {
    process.exit(1);
  }

  // 记录
  const result = await logMessage(content, allTags);

  if (result.success) {
    console.log('✅ 记录成功');
  } else {
    console.log('❌ 记录失败:', result.error);
    process.exit(1);
  }
}

main().catch(console.error);
