"""PlantCare-VL Gradio 应用入口。"""

from __future__ import annotations

from pathlib import Path

import gradio as gr

from app.client import LlamaClient
from app.prompts import SYSTEM_PROMPT


client = LlamaClient()


def ask_plant(image_path: str | None, question: str) -> str:
    """处理植物图片和文字问题。

    参数:
        image_path: Gradio 暂存图片路径。
        question: 用户问题。

    返回:
        模型回答或可操作错误提示。
    """
    if not question.strip():
        return "请输入问题。"
    image_bytes = Path(image_path).read_bytes() if image_path else None
    prompt = f"{SYSTEM_PROMPT}\n\n用户问题：{question.strip()}"
    try:
        return client.chat(prompt, image_bytes)
    except (RuntimeError, KeyError, IndexError) as error:
        return f"调用失败：{error}"


with gr.Blocks(title="PlantCare-VL") as demo:
    gr.Markdown("# PlantCare-VL 植物养护助手")
    image = gr.Image(type="filepath", label="植物图片（可选）")
    question = gr.Textbox(label="问题", lines=3)
    answer = gr.Markdown()
    submit = gr.Button("分析")
    submit.click(ask_plant, inputs=[image, question], outputs=answer)


if __name__ == "__main__":
    demo.launch(inbrowser=True)

