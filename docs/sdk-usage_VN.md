# Hướng Dẫn OPA API SDK

Module `sdk/opaproxy` cung cấp proxy như một thư viện Go có thể tái sử dụng, cho phép các chương trình bên ngoài nhúng các lớp routing, authentication, hot-reload và translation mà không cần phụ thuộc vào CLI binary.

## Cài Đặt & Import

```bash
go get github.com/opa-ai-labs/opa-api/v6/sdk/opaproxy
```

```go
import (
    "context"
    "errors"
    "time"

    "github.com/opa-ai-labs/opa-api/v6/internal/config"
    "github.com/opa-ai-labs/opa-api/v6/sdk/opaproxy"
)
```

Lưu ý module path `/v6`.

## Nhúng Tối Thiểu

```go
cfg, err := config.LoadConfig("config.yaml")
if err != nil { panic(err) }

svc, err := opaproxy.NewBuilder().
    WithConfig(cfg).
    WithConfigPath("config.yaml"). // đường dẫn tuyệt đối hoặc tương đối
    Build()
if err != nil { panic(err) }

ctx, cancel := context.WithCancel(context.Background())
defer cancel()

if err := svc.Run(ctx); err != nil && !errors.Is(err, context.Canceled) {
    panic(err)
}
```

Service quản lý việc theo dõi config/auth, làm mới token tự động và tắt máy graceful. Hủy context để dừng.

## Tùy Chọn Server (middleware, routes, logs)

Server chấp nhận các tùy chọn qua `WithServerOptions`:

```go
svc, _ := opaproxy.NewBuilder().
  WithConfig(cfg).
  WithConfigPath("config.yaml").
  WithServerOptions(
    // Thêm middleware toàn cục
    opaproxy.WithMiddleware(func(c *gin.Context) { c.Header("X-Embed", "1"); c.Next() }),
    // Cấu hình gin engine sớm (CORS, trusted proxies, etc.)
    opaproxy.WithEngineConfigurator(func(e *gin.Engine) { e.ForwardedByClientIP = true }),
    // Thêm routes của bạn sau defaults
    opaproxy.WithRouterConfigurator(func(e *gin.Engine, _ *handlers.BaseAPIHandler, _ *config.Config) {
      e.GET("/healthz", func(c *gin.Context) { c.String(200, "ok") })
    }),
    // Override request log writer/dir
    opaproxy.WithRequestLoggerFactory(func(cfg *config.Config, cfgPath string) logging.RequestLogger {
      return logging.NewFileRequestLogger(true, "logs", filepath.Dir(cfgPath))
    }),
  ).
  Build()
```

## Management API (khi nhúng)

- Management endpoints chỉ được mount khi `remote-management.secret-key` được set trong `config.yaml`.
- Truy cập từ xa yêu cầu thêm `remote-management.allow-remote: true`.
- Xem MANAGEMENT_API.md để biết các endpoints. Server nhúng của bạn expose chúng tại `/v0/management`.

## Sử Dụng Core Auth Manager

Service sử dụng core `auth.Manager` để lựa chọn, thực thi và tự động làm mới. Khi nhúng, bạn có thể cung cấp manager của riêng mình:

```go
core := coreauth.NewManager(coreauth.NewFileStore(cfg.AuthDir), nil, nil)
core.SetRoundTripperProvider(myRTProvider) // per-auth *http.Transport

svc, _ := opaproxy.NewBuilder().
    WithConfig(cfg).
    WithConfigPath("config.yaml").
    WithCoreAuthManager(core).
    Build()
```

## Hooks

Quan sát lifecycle mà không cần patch internals:

```go
hooks := opaproxy.Hooks{
  OnBeforeStart: func(cfg *config.Config) { log.Infof("starting on :%d", cfg.Port) },
  OnAfterStart:  func(s *opaproxy.Service) { log.Info("ready") },
}
svc, _ := opaproxy.NewBuilder().WithConfig(cfg).WithConfigPath("config.yaml").WithHooks(hooks).Build()
```

## Tắt Máy

`Run` defer `Shutdown`, nên hủy parent context là đủ. Để dừng thủ công:

```go
ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
defer cancel()
_ = svc.Shutdown(ctx)
```

## Ghi Chú

- Hot reload: thay đổi trong `config.yaml` và `auths/` được tự động nhận.
- Request logging có thể toggle runtime qua Management API.
- Các tính năng Gemini Web (`gemini-web.*`) được áp dụng trong embedded server.
