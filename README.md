# PlantCare-VL Pro

基于 **Qwen3-VL-4B-Instruct** 的植物识别与养护问答模型升级版，使用 QLoRA 微调实现。

- 升级自 [ZJKing2026/plantcare-vl](https://github.com/ZJKing2026/plantcare-vl)（Qwen2.5-VL-3B 版本）
- 基座模型：[Qwen/Qwen3-VL-4B-Instruct](https://huggingface.co/Qwen/Qwen3-VL-4B-Instruct)（Apache 2.0）
- GGUF 权重托管在 Hugging Face
- 许可：[Apache 2.0](LICENSE)（基座模型 Qwen3-VL 为 Apache 2.0，本项目沿用）

## 功能

- 植物品种识别：上传植物图片，识别品种
- 植物状态诊断：分析叶片颜色、形态等，判断健康状态
- 养护问答：提供浇水、光照、施肥等养护建议

相比 3B 版本，Pro 基于 Qwen3-VL-4B 基座，具备更强的视觉理解与语言推理能力。

## 项目结构

```
plantcare-vl-pro/
├── app/                        # 推理应用
│   ├── main.py                 # Gradio 界面
│   ├── client.py               # llama-server OpenAI 兼容客户端
│   └── prompts.py              # 系统提示词
├── scripts/
│   └── start_model_server.ps1  # 启动 llama.cpp 服务端
├── data/
│   └── curated_v1/             # 微调数据集（944 张图，train/val/test 划分）
├── models/                     # 模型权重说明
├── SHA256SUMS.txt              # GGUF 文件 SHA256 校验和
├── LICENSE                     # Apache 2.0
├── ATTRIBUTION.md              # 技术归属和引用
└── README.md
```

## 数据集

`data/curated_v1/` 为视觉分类微调数据集：

- 图片 944 张：plant_healthy 207 / plant_abnormal 252 / non_plant 405 / uncertain 80
- 划分：训练 750 / 验证 95 / 测试 99
- 提供 LlamaFactory 与 ShareGPT 两种格式（train/validation/test）
- 来源：PlantDoc 与 PASS（CC BY 4.0）、免费图库、人工补充

详见 [`data/curated_v1/README.md`](data/curated_v1/README.md)。

## 模型权重

微调后的 GGUF 模型文件因体积较大，托管在 Hugging Face：

**[Hugging Face 模型仓库 →](https://huggingface.co/ZJKing2026/plantcare-vl-pro)**

两个 GGUF 文件必须配套使用：

| 文件 | 说明 |
|------|------|
| `plantcare-qwen3vl-4b-formal-v1-q4_k_m.gguf` | 语言模型（Q4_K_M 量化） |
| `mmproj-plantcare-qwen3vl-4b-formal-v1-f16.gguf` | 视觉投影层（FP16） |
| `plant-care-qwen3vl4b-lora-formal-v1.tar.gz` | QLoRA 适配器权重（含 adapter_model.safetensors） |

下载后放入本地 `models/qwen3vl-4b-formal-v1/` 目录，并用 `SHA256SUMS.txt` 校验完整性。

## 本地推理

前置依赖：

1. 安装 [llama.cpp](https://github.com/ggml-org/llama.cpp)（Windows 可下载官方预编译包）
2. 从 Hugging Face 下载两个 GGUF 文件到 `models/qwen3vl-4b-formal-v1/`
3. 校验 SHA256：

```powershell
Get-FileHash .\models\qwen3vl-4b-formal-v1\plantcare-qwen3vl-4b-formal-v1-q4_k_m.gguf -Algorithm SHA256
```

启动模型服务端：

```powershell
.\scripts\start_model_server.ps1
```

运行 Gradio 客户端：

```powershell
python app\main.py
```

服务端监听 `http://127.0.0.1:8080`，提供 OpenAI 兼容接口。

## 校验和

`SHA256SUMS.txt` 记录了全部 GGUF 文件的 SHA256 值，格式为：

```
<sha256>  <文件名>
```

## 声明

本项目为原型验证性质，输出仅供参考，不构成任何专业园艺或植保建议。
