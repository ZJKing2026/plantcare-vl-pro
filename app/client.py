"""llama-server OpenAI 兼容客户端。"""

from __future__ import annotations

import base64
import json
import urllib.error
import urllib.request
from collections.abc import Callable
from typing import Any


Transport = Callable[[str, dict[str, Any]], dict[str, Any]]


def _default_transport(url: str, payload: dict[str, Any]) -> dict[str, Any]:
    """向本地模型服务发送 JSON 请求。

    参数:
        url: 服务接口地址。
        payload: OpenAI 兼容请求。

    返回:
        服务返回的 JSON 对象。
    """
    request = urllib.request.Request(
        url,
        data=json.dumps(payload).encode("utf-8"),
        headers={"Content-Type": "application/json"},
        method="POST",
    )
    try:
        with urllib.request.urlopen(request, timeout=180) as response:
            return json.loads(response.read().decode("utf-8"))
    except (urllib.error.URLError, TimeoutError) as error:
        raise RuntimeError(
            "无法连接本地模型服务，请先启动 llama-server。"
        ) from error


class LlamaClient:
    """调用本地 llama-server 的轻量客户端。"""

    def __init__(
        self,
        base_url: str = "http://127.0.0.1:8080",
        transport: Transport = _default_transport,
    ) -> None:
        """初始化客户端。

        参数:
            base_url: llama-server 根地址。
            transport: 可替换的 JSON 传输函数。
        """
        self.url = f"{base_url.rstrip('/')}/v1/chat/completions"
        self.transport = transport

    def chat(
        self,
        prompt: str,
        image_bytes: bytes | None = None,
    ) -> str:
        """提交文字或图片问题并返回模型回答。

        参数:
            prompt: 用户问题。
            image_bytes: 可选图片字节。

        返回:
            模型回答文本。
        """
        content: list[dict[str, Any]] = []
        if image_bytes:
            encoded = base64.b64encode(image_bytes).decode("ascii")
            content.append(
                {
                    "type": "image_url",
                    "image_url": {
                        "url": f"data:image/jpeg;base64,{encoded}"
                    },
                }
            )
        content.append({"type": "text", "text": prompt})
        payload = {
            "model": "plantcare-vl",
            "messages": [{"role": "user", "content": content}],
            "temperature": 0.2,
            "max_tokens": 512,
        }
        result = self.transport(self.url, payload)
        return str(result["choices"][0]["message"]["content"])

