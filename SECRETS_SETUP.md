# 🔐 OAuth Secrets Setup Guide

OPA API cần OAuth Client Secrets để xác thực với các provider. File này hướng dẫn cách lấy và cấu hình secrets.

## ⚠️ Quan Trọng

Code này đã được **xóa tất cả secrets** để bảo mật. Bạn cần tự lấy OAuth credentials từ các provider.

## 📍 Files Cần Cập Nhật

Sau khi có secrets, thay thế placeholders trong các file sau:

| Placeholder | File Location |
|-------------|---------------|
| `YOUR_GEMINI_CLIENT_SECRET` | `internal/auth/gemini/gemini_auth.go` |
| `YOUR_GEMINI_CLIENT_SECRET` | `internal/api/handlers/management/api_tools.go` |
| `YOUR_GEMINI_CLIENT_SECRET` | `internal/runtime/executor/gemini_cli_executor.go` |
| `YOUR_ANTIGRAVITY_CLIENT_SECRET` | `internal/auth/antigravity/constants.go` |
| `YOUR_ANTIGRAVITY_CLIENT_SECRET` | `internal/api/handlers/management/api_tools.go` |
| `YOUR_ANTIGRAVITY_CLIENT_SECRET` | `internal/runtime/executor/antigravity_executor.go` |

## 🔧 Cách Lấy OAuth Secrets

### Gemini CLI

1. Truy cập [Google Cloud Console](https://console.cloud.google.com/)
2. Tạo Project mới hoặc chọn Project có sẵn
3. Vào **APIs & Services** → **Credentials**
4. Click **Create Credentials** → **OAuth client ID**
5. Chọn **Desktop app**
6. Copy **Client Secret**

### Antigravity

1. Đăng ký tài khoản tại Antigravity
2. Vào Settings → API
3. Tạo OAuth App
4. Copy Client Secret

## 🔄 Quick Replace (Linux/macOS)

```bash
# Thay YOUR_GEMINI_CLIENT_SECRET
find . -name "*.go" -exec sed -i 's/YOUR_GEMINI_CLIENT_SECRET/GOCSPX-xxx-your-real-secret/g' {} \;

# Thay YOUR_ANTIGRAVITY_CLIENT_SECRET  
find . -name "*.go" -exec sed -i 's/YOUR_ANTIGRAVITY_CLIENT_SECRET/GOCSPX-xxx-your-real-secret/g' {} \;
```

## 🔄 Quick Replace (Windows PowerShell)

```powershell
# Thay YOUR_GEMINI_CLIENT_SECRET
Get-ChildItem -Recurse -Filter *.go | ForEach-Object {
    (Get-Content $_.FullName) -replace 'YOUR_GEMINI_CLIENT_SECRET', 'GOCSPX-xxx-your-real-secret' | Set-Content $_.FullName
}
```

## 💡 Khuyến Nghị

Thay vì hardcode secrets, bạn có thể:

1. **Dùng Environment Variables**:
   ```go
   clientSecret := os.Getenv("GEMINI_CLIENT_SECRET")
   ```

2. **Dùng Config File**:
   ```yaml
   # config.yaml
   oauth:
     gemini:
       client_secret: "your-secret-here"
   ```

---

**OPA AI Labs** - https://opa.vn
