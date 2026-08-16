# PlantCare-VL Pro 数据集 curated_v1

用于 Qwen3-VL-4B-Instruct 的视觉识别 QLoRA 微调。模型负责视觉分类
（健康/异常/非植物/不确定），RAG 负责养护知识问答。

## 统计

- 图片总数：944 张
- 健康植物（plant_healthy）：207 张
- 异常植物（plant_abnormal）：252 张
- 非植物（non_plant）：405 张
- 不确定（uncertain）：80 张

## 划分

- 训练集：750 张
- 验证集：95 张
- 测试集：99 张

## 文件说明

- `dataset.jsonl`：全量数据（含元信息）
- `train.jsonl` / `validation.jsonl` / `test.jsonl`：LlamaFactory 格式划分
- `train_sharegpt.jsonl` / `validation_sharegpt.jsonl` / `test_sharegpt.jsonl`：ShareGPT 格式划分
- `dataset_info.json`：数据集注册配置
- `label_definition.md`：标签定义
- `images/`：训练图片（按类别子目录组织）
- `manifests/summary.json`：数据整理统计

## 数据来源

- Cropped PlantDoc（CC BY 4.0）与 PASS（CC BY 4.0）裁剪与标注
- Pexels / Unsplash 等免费图库图片，来源记录在数据集根目录 CSV
- 少量人工拍摄与补充（约 78 张）

## 构建流程

1. 从公开数据集与免费图库采集植物图片
2. 按 subject / health_status 标注并去重（去除过小与近重复图片）
3. 划分训练 / 验证 / 测试集
4. 导出 LlamaFactory 与 ShareGPT 两种格式
