import sharp from 'sharp';
import { optimize } from 'svgo';
import path from 'path';
import fs from 'fs';
import { fileURLToPath } from 'url';
import dotenv from 'dotenv';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// 加载根目录下的 .env 文件
dotenv.config({ path: path.resolve(__dirname, '../../.env') });

// 从命令行参数获取文件路径
const filePath = process.argv[2];

if (!filePath) {
  console.error('Please provide a file path');
  process.exit(1);
}

if (!fs.existsSync(filePath)) {
  console.error(`File not found: ${filePath}`);
  process.exit(1);
}

const quality = parseInt(process.env.COMPRESS_QUALITY || '80', 10);
const parsed = path.parse(filePath);
const ext = parsed.ext.toLowerCase();
const outputPath = path.join(parsed.dir, `${parsed.name}.min${parsed.ext}`);

try {
  if (ext === '.svg') {
    // SVG: 使用 svgo 进行 XML 级别优化
    const svgString = fs.readFileSync(filePath, 'utf8');
    const result = optimize(svgString, { multipass: true });
    fs.writeFileSync(outputPath, result.data, 'utf8');
  } else if (['.png', '.jpg', '.jpeg', '.webp', '.gif'].includes(ext)) {
    // 光栅图片: 使用 sharp 压缩
    let pipeline = sharp(filePath, { animated: ext === '.gif' });

    switch (ext) {
      case '.png':
        pipeline = pipeline.png({ quality, compressionLevel: 9 });
        break;
      case '.jpg':
      case '.jpeg':
        pipeline = pipeline.jpeg({ quality, mozjpeg: true });
        break;
      case '.webp':
        pipeline = pipeline.webp({ quality });
        break;
      case '.gif':
        pipeline = pipeline.gif();
        break;
    }

    await pipeline.toFile(outputPath);
  } else {
    console.error(`Unsupported format: ${ext}`);
    process.exit(1);
  }

  // 计算压缩率
  const originalSize = fs.statSync(filePath).size;
  const compressedSize = fs.statSync(outputPath).size;
  const reduction = ((1 - compressedSize / originalSize) * 100).toFixed(1);

  console.log(`Compressed: ${originalSize} -> ${compressedSize} bytes (${reduction}% reduction)`);
  console.log(`###COMPRESSED_START###${outputPath}###COMPRESSED_END###`);
} catch (error) {
  console.error(error);
  process.exit(1);
}
