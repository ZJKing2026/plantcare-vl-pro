# 标签定义

## subject（主体类别）

- `PLANT`：主体是植物
- `NON_PLANT`：主体不是植物（如人、建筑、文字截图等）
- `UNCERTAIN`：无法可靠判定主体是否为植物

## health_status（健康状态）

- `HEALTHY`：健康
- `YELLOW_LEAF`：叶片发黄
- `WILTING`：萎蔫
- `DRY_LEAF`：叶片干枯
- `LEAF_SPOT`：叶斑病
- `PEST_VISIBLE`：可见虫害
- `PHYSICAL_DAMAGE`：物理损伤
- `SUNBURN_SUSPECTED`：疑似日灼
- `WATER_STRESS_SUSPECTED`：疑似水分胁迫
- `UNKNOWN_ABNORMALITY`：异常原因未知

## 标注规则

1. 先判定 `subject`，再判定 `health_status`
2. 非植物（`NON_PLANT`）不标注 `health_status`
3. 状态可叠加，取最显著的一个
4. `need_rag=true` 的样本用于 RAG 养护问答验证
