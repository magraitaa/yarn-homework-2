#!/usr/bin/env python3
"""Run locally while open_web.sh is running; check each daemon's HTTP/JMX endpoint."""
import json
import sys
from urllib.request import ProxyHandler, build_opener

services = [
    ("ResourceManager", 8088), ("NameNode", 9870), ("SecondaryNameNode", 9868),
    ("DataNode en", 19864), ("DataNode 00", 29864), ("DataNode 01", 39864),
    ("NodeManager en", 18042), ("NodeManager 00", 28042), ("NodeManager 01", 38042),
]
opener = build_opener(ProxyHandler({}))
failed = False
for name, port in services:
    url = f"http://127.0.0.1:{port}/jmx"
    try:
        with opener.open(url, timeout=5) as response:
            data = json.load(response)
        if not isinstance(data, dict) or not data.get("beans"):
            raise ValueError("missing JMX beans")
        print(f"OK: {name}: {url}")
    except Exception as exc:
        failed = True
        print(f"FAIL: {name}: {url}: {exc}")
sys.exit(1 if failed else 0)
