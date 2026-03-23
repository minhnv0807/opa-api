# Đóng Góp cho OPA API

Cảm ơn bạn đã quan tâm đến việc đóng góp cho OPA API! 🎉

## 🌐 Ngôn Ngữ

- Code comments: Tiếng Anh
- Documentation: Tiếng Việt + Tiếng Anh
- Commit messages: Tiếng Anh
- Issues/PRs: Tiếng Việt hoặc Tiếng Anh đều được

## 🚀 Bắt Đầu

### 1. Fork Repository

```bash
# Fork qua GitHub UI, sau đó clone
git clone https://github.com/YOUR_USERNAME/opa-api.git
cd opa-api
```

### 2. Setup Development Environment

```bash
# Cài đặt Go 1.21+
go version

# Download dependencies
go mod download

# Build
go build -o opa-api ./cmd/server

# Run tests
go test ./...
```

### 3. Tạo Feature Branch

```bash
git checkout -b feature/ten-tinh-nang
# hoặc
git checkout -b fix/ten-bug
```

## 📝 Coding Standards

### Go Code

```go
// Package-level comments bằng tiếng Anh
// Package api provides REST API handlers for OPA API.
package api

// Function comments bằng tiếng Anh
// HandleRequest processes incoming API requests.
func HandleRequest(ctx context.Context) error {
    // Inline comments có thể bằng tiếng Việt nếu cần
    // Khởi tạo context với timeout 30s
    ctx, cancel := context.WithTimeout(ctx, 30*time.Second)
    defer cancel()
    
    return nil
}
```

### Commit Messages

Sử dụng [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: add new provider support for Qwen
fix: resolve streaming timeout issue
docs: update Vietnamese README
refactor: simplify auth manager logic
test: add unit tests for router
chore: update dependencies
```

## 🔍 Code Review Process

1. **Self-review**: Kiểm tra code trước khi submit
2. **CI checks**: Đảm bảo tests pass
3. **Reviewer feedback**: Respond promptly
4. **Squash commits**: Trước khi merge

## 📋 Pull Request Checklist

- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Tests added/updated
- [ ] Documentation updated (if needed)
- [ ] Commit messages follow convention
- [ ] PR title is descriptive

## 🐛 Reporting Bugs

Khi report bug, vui lòng cung cấp:

1. **Environment**: OS, Go version, Docker version
2. **Steps to reproduce**: Chi tiết các bước
3. **Expected behavior**: Kết quả mong đợi
4. **Actual behavior**: Kết quả thực tế
5. **Logs**: Error messages, stack traces

## 💡 Feature Requests

Khi đề xuất tính năng mới:

1. **Use case**: Giải quyết vấn đề gì?
2. **Proposed solution**: Cách bạn hình dung
3. **Alternatives**: Các giải pháp khác đã cân nhắc
4. **Impact**: Ảnh hưởng đến existing functionality

## 📁 Project Structure

```
opa-api/
├── cmd/server/         # Main entrypoint
├── internal/           # Private packages
│   ├── api/           # HTTP handlers
│   ├── auth/          # Authentication
│   ├── config/        # Configuration
│   └── ...
├── sdk/               # Public SDK
├── docs/              # Documentation
└── examples/          # Usage examples
```

## 🧪 Testing

```bash
# Run all tests
go test ./...

# Run with coverage
go test -cover ./...

# Run specific package
go test ./internal/api/...

# Run with verbose output
go test -v ./...
```

## 📞 Liên Hệ

- **Telegram**: [@opa_ai_labs](https://t.me/opa_ai_labs)
- **Facebook**: [OPA Vietnam](https://facebook.com/opavietnam)
- **Email**: hello@opa.vn

## 🙏 Cảm Ơn

Mọi đóng góp, dù lớn hay nhỏ, đều được trân trọng!

---

**OPA AI Labs** - Building AI-powered solutions for Vietnamese businesses 🇻🇳
