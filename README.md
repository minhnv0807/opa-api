# OPA API

<p align="center">
  <img src="./assets/opa-logo.svg" alt="OPA API Logo" width="200">
</p>

<p align="center">
  <strong>🚀 Universal AI CLI Proxy Server</strong>
</p>

<p align="center">
  <a href="README_VN.md">🇻🇳 Tiếng Việt</a> |
  <a href="README.md">🇬🇧 English</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/version-1.0.0-blue.svg" alt="Version">
  <img src="https://img.shields.io/badge/license-MIT-green.svg" alt="License">
  <img src="https://img.shields.io/badge/Go-1.21+-00ADD8.svg" alt="Go Version">
</p>

---

A powerful proxy server that transforms AI CLI tools (Gemini CLI, Claude Code, OpenAI Codex, Qwen Code, iFlow) into unified OpenAI/Gemini/Claude/Codex compatible APIs.

**Built &amp; Maintained by [OPA AI Labs](https://opa.vn)** — Digital Marketing Agency specializing in AI-powered solutions for Vietnamese businesses.

## ⚡ Key Features

| Feature | Description |
|---------|-------------|
| 🔐 **OAuth Support** | Login with Codex, Claude Code, Qwen Code, iFlow |
| ⚖️ **Load Balancing** | Multi-account with round-robin distribution |
| 🌊 **Streaming** | Real-time streaming responses |
| 🛠️ **Tool Calling** | Function calling / tools support |
| 🖼️ **Multimodal** | Text + Image input support |
| 🎯 **API Compatible** | Works with OpenAI/Gemini/Claude SDKs |
| 📡 **Amp CLI** | Full IDE extension support |
| 📦 **Go SDK** | Embeddable SDK for custom apps |

## 🚀 Quick Start

### Prerequisites

- Go 1.21+
- Git

### Installation

```bash
# Clone repository
git clone https://github.com/opa-ai-labs/opa-api.git
cd opa-api

# Build
go build -o opa-api ./cmd/server

# Run
./opa-api
```

### Docker

```bash
# Build image
docker build -t opa-api .

# Run container
docker run -d -p 8080:8080 --name opa-api opa-api
```

### Docker Compose

```bash
docker-compose up -d
```

## 📖 Configuration

Copy the example config and customize:

```bash
cp config.example.yaml config.yaml
```

### Basic Configuration

```yaml
server:
  host: "0.0.0.0"
  port: 8080
  
providers:
  gemini:
    enabled: true
    accounts:
      - email: "your-email@gmail.com"
        
  claude:
    enabled: true
    accounts:
      - email: "your-email@gmail.com"
        
  codex:
    enabled: true
    accounts:
      - email: "your-email@gmail.com"
```

## 🔌 Supported Providers

| Provider | OAuth | Multi-Account | Status |
|----------|-------|---------------|--------|
| Gemini CLI | ✅ | ✅ | Stable |
| Claude Code | ✅ | ✅ | Stable |
| OpenAI Codex | ✅ | ✅ | Stable |
| Qwen Code | ✅ | ✅ | Stable |
| iFlow | ✅ | ✅ | Stable |
| Antigravity | ✅ | ✅ | Beta |

## 📚 API Endpoints

### OpenAI Compatible

```
POST /v1/chat/completions
POST /v1/completions
GET  /v1/models
```

### Gemini Compatible

```
POST /v1beta/models/{model}:generateContent
POST /v1beta/models/{model}:streamGenerateContent
```

### Claude Compatible

```
POST /v1/messages
```

### Management API

```
GET  /management/health
GET  /management/accounts
POST /management/accounts/add
POST /management/accounts/remove
GET  /management/usage
```

## 🎯 Usage Examples

### Python (OpenAI SDK)

```python
from openai import OpenAI

client = OpenAI(
    base_url="http://localhost:8080/v1",
    api_key="opa-api-key"  # or your custom key
)

response = client.chat.completions.create(
    model="gemini-2.5-pro",
    messages=[{"role": "user", "content": "Hello!"}]
)

print(response.choices[0].message.content)
```

### Node.js

```javascript
import OpenAI from 'openai';

const client = new OpenAI({
  baseURL: 'http://localhost:8080/v1',
  apiKey: 'opa-api-key'
});

const response = await client.chat.completions.create({
  model: 'claude-sonnet-4',
  messages: [{ role: 'user', content: 'Hello!' }]
});

console.log(response.choices[0].message.content);
```

### cURL

```bash
curl -X POST http://localhost:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer opa-api-key" \
  -d '{
    "model": "gpt-5",
    "messages": [{"role": "user", "content": "Hello!"}]
  }'
```

## 🔧 Advanced Features

### Model Mapping

Route unavailable models to alternatives:

```yaml
model_mapping:
  claude-opus-4.5: claude-sonnet-4
  gpt-5-preview: gpt-5
```

### Load Balancing Strategies

```yaml
load_balancing:
  strategy: "round-robin"  # or "least-connections", "random"
  health_check_interval: 30s
```

### Rate Limiting

```yaml
rate_limiting:
  enabled: true
  requests_per_minute: 60
  burst: 10
```

## 📖 SDK Documentation

- [SDK Usage Guide](docs/sdk-usage.md)
- [Advanced Features](docs/sdk-advanced.md)
- [Access Control](docs/sdk-access.md)
- [Watcher System](docs/sdk-watcher.md)

## 🛡️ Security Notes

> ⚠️ **Important Security Considerations**

1. **Token Security**: Protect your OAuth tokens and session data
2. **Network Security**: Use HTTPS in production, restrict endpoints
3. **ToS Compliance**: Be aware of each provider's Terms of Service
4. **Access Control**: Implement proper authentication for public deployments

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Credits

OPA API is a fork of [CLIProxyAPI](https://github.com/router-for-me/CLIProxyAPI) by router-for-me, rebranded and localized for the Vietnamese developer community.

---

<p align="center">
  <strong>Built with ❤️ by <a href="https://opa.vn">OPA AI Labs</a></strong>
</p>

<p align="center">
  <a href="https://facebook.com/opavietnam">Facebook</a> •
  <a href="https://t.me/opa_ai_labs">Telegram</a> •
  <a href="mailto:hello@opa.vn">Contact</a>
</p>
