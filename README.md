# STRESS 💢

A lightweight, fast HTTP stress-testing CLI written in [V](https://vlang.io/).  
Supports **multithreading**, configurable concurrency, test duration, and both **GET** and **POST** requests with optional request bodies.

[![Build Status](https://img.shields.io/github/actions/workflow/status/ChrizzzDev/stress/ci.yml?branch=main&style=for-the-badge&logo=v&label=Build)](https://github.com/ChrizzzDev/stress/actions)

---

## Features

- 🚀 High-performance concurrency using V's native goroutines (tasks).
- ⏱ Configurable test duration (supports mixed units like `1m30s`, `250ms`, etc.).
- 📊 Detailed results: throughput, latency average, min/max, and percentiles (p50, p95, p99).
- 🔄 Support for both GET and POST requests.
- 📝 Optional request body from literal string or file.
- 📦 Zero external dependencies.

---

## Installation

You need [V](https://vlang.io/) installed.

```bash
# Clone this repo
git clone https://github.com/ChrizzzDev/stress.git
cd stress

# Build
v .
```

## Usage
```bash
stress --url <target> [options]
```

### Options
| Flag            | Short    | Default   | Description                                                   |
| --------------- | -------- | --------- | ------------------------------------------------------------- |
| `--url`         | `-u`     | *(none)*  | **Target URL** (required)                                     |
| `--concurrency` | `-c`     | `10`      | Number of concurrent workers                                  |
| `--duration`    | `-d`     | `10s`     | Test duration (supports mixed units: `30s`, `1m30s`, `250ms`) |
| `--method`      | `-m`     | `GET`     | HTTP method: `GET` or `POST`                                  |
| `--body`        | `-b`     | *(empty)* | Literal request body (for POST)                               |
| `--body-file`   | `-f`     | *(empty)* | Path to file containing request body (for POST)               |


## Examples

Basic GET test
```bash
stress --url https://example.com --concurrency 50 --duration 15s
```

POST with inline JSON body
```bash
stress --url https://httpbin.org/post \
  --method POST \
  --body '{"username": "NoobMaster69", "role": "Gamer"}' \
  --concurrency 50 \
  --duration 15s
```

POST with body from file
```bash
stress -u https://httpbin.org/post \
  --method POST \
  --body-file ./data.json \
  --concurrency 10 \
  --duration 5s
```

### Sample Output
```bash
Running stress test on https://httpbin.org/post with 50 workers for 15.000s using method POST
With request body: {"username":"NoobMaster69","role":"Gamer"}
Requests so far: 87
Requests so far: 153
Requests so far: 243
=============== Stress Test Results ===============
Total requests: 274
Successful: 274 | Failed: 0
Throughput: 18.27 req/s
Average latency: 11ns | min: 785ns | max: 9.990us
p50: 1.805us | p95: 5.047us | p99: 6.563us
```

## Build for Distribution
To produce a single binary:
```bash
v -prod .
```
This will create an optimized executable `stress` that you can run directly.

## LICENSE
Attribution-ShareAlike 4.0 International — free to use, modify, and distribute.