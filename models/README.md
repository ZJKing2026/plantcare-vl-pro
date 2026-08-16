# 模型权重

GGUF 模型文件因体积较大，托管在 Hugging Face，不在本仓库内。

- **Hugging Face 仓库**：https://huggingface.co/ZJKing2026/plantcare-vl-pro
- 语言模型：`plantcare-qwen3vl-4b-formal-v1-q4_k_m.gguf`（Q4_K_M 量化，约 2.5 GB）
- 视觉投影层：`mmproj-plantcare-qwen3vl-4b-formal-v1-f16.gguf`（FP16，约 836 MB）

## 本地目录约定

下载后请放置到以下路径，与 `scripts/start_model_server.ps1` 的默认路径一致：

```
plantcare-vl-pro/
└── models/
    └── qwen3vl-4b-formal-v1/
        ├── plantcare-qwen3vl-4b-formal-v1-q4_k_m.gguf
        └── mmproj-plantcare-qwen3vl-4b-formal-v1-f16.gguf
```

## 校验

SHA256 校验和见仓库根目录 `SHA256SUMS.txt`。
