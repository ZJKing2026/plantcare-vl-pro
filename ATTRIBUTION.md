# 技术归属与引用说明

## 基座模型

本项目基于 **Qwen3-VL-4B-Instruct** 进行微调，该模型由 Alibaba Group 开发并开源。

- 模型名称：Qwen3-VL-4B-Instruct
- 开发者：Alibaba Group（通义千问团队）
- 许可证：Apache License 2.0
- 原始仓库：https://huggingface.co/Qwen/Qwen3-VL-4B-Instruct
- 技术报告：https://arxiv.org/abs/2506.11692

## 衍生说明

根据 Apache 2.0 第 4 条要求，本项目的修改如下：

1. 使用 QLoRA 在自定义植物养护数据集上微调 Qwen3-VL-4B-Instruct
2. 将微调后的模型导出为 GGUF 格式（Q4_K_M 量化）用于本地部署推理
3. 编写了基于 llama.cpp 的推理服务端和客户端

## 与 3B 版本的关系

本项目是 [ZJKing2026/plantcare-vl](https://github.com/ZJKing2026/plantcare-vl)（基于
Qwen2.5-VL-3B-Instruct）的升级版本，两者使用同一套植物养护数据集与推理应用。

## 商用说明

- **基座模型**（Qwen3-VL-4B-Instruct）：Apache 2.0 许可，允许商用
- **微调权重**：Apache 2.0 许可，允许商用
- **免责声明**：本项目为原型验证性质，不提供任何明示或暗示的保证。
  模型输出仅供参考，不构成专业园艺或植物保护建议。
  使用者应自行评估在特定场景下的适用性和风险。

## 引用格式

```bibtex
@misc{plantcare-vl-pro-2025,
  author = {ZJKing2026},
  title = {PlantCare-VL Pro: Qwen3-VL-4B Fine-tuned for Plant Recognition and Care},
  year = {2025},
  publisher = {GitHub},
  url = {https://github.com/ZJKing2026/plantcare-vl-pro}
}
```
