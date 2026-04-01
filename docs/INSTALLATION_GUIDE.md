# OPA API - Huong dan cai dat va su dung

> Huong dan nay danh cho nguoi moi bat dau. Moi buoc deu co giai thich chi tiet.

---

## Muc luc

1. [OPA API la gi?](#1-opa-api-la-gi)
2. [Chuan bi truoc khi cai](#2-chuan-bi-truoc-khi-cai)
3. [Cach 1: Cai bang Docker (De nhat - Khuyen dung)](#3-cach-1-cai-bang-docker)
4. [Cach 2: Cai truc tiep tren may (Windows/Mac/Linux)](#4-cach-2-cai-truc-tiep-tren-may)
5. [Cau hinh config.yaml](#5-cau-hinh-configyaml)
6. [Truy cap Management Panel](#6-truy-cap-management-panel)
7. [Ket noi voi cac AI CLI](#7-ket-noi-voi-cac-ai-cli)
8. [Cac loi thuong gap](#8-cac-loi-thuong-gap)

---

## 1. OPA API la gi?

OPA API la mot **proxy server** giup ban:

- **Gop nhieu tai khoan AI** (Gemini, Claude, Codex, Qwen, iFlow...) lai mot cho
- **Chuyen doi tu dong** giua cac tai khoan khi bi gioi han (rate limit)
- **Quan ly bang giao dien web** (Management Panel) thay vi phai sua file

**Vi du thuc te:** Ban co 3 tai khoan Gemini CLI mien phi. Khi tai khoan 1 het luot, OPA tu dong chuyen sang tai khoan 2, roi tai khoan 3, roi quay lai tai khoan 1.

---

## 2. Chuan bi truoc khi cai

### Cach 1 (Docker) - Can cai:

| Phan mem | Link tai | Ghi chu |
|----------|----------|---------|
| Docker Desktop | https://www.docker.com/products/docker-desktop/ | Chon ban Windows/Mac/Linux |

### Cach 2 (Truc tiep) - Can cai:

| Phan mem | Link tai | Ghi chu |
|----------|----------|---------|
| Go 1.21+ | https://go.dev/dl/ | Chon ban phu hop voi may |
| Git | https://git-scm.com/downloads | De tai ma nguon |

### Kiem tra da cai chua

Mo **Terminal** (Windows: nhan `Win + R`, go `cmd`, Enter):

```bash
# Kiem tra Docker
docker --version
# Ket qua mong doi: Docker version 27.x.x

# Hoac kiem tra Go
go version
# Ket qua mong doi: go version go1.26.x

# Kiem tra Git
git version
# Ket qua mong doi: git version 2.x.x
```

---

## 3. Cach 1: Cai bang Docker

> Day la cach de nhat, chi can 3 buoc.

### Buoc 1: Tai ma nguon

```bash
git clone https://github.com/minhnv0807/opa-api.git
cd opa-api
```

### Buoc 2: Tao file cau hinh

```bash
# Windows (Command Prompt)
copy config.example.yaml config.yaml

# Mac/Linux
cp config.example.yaml config.yaml
```

Sua file `config.yaml` theo huong dan o [Muc 5](#5-cau-hinh-configyaml).

### Buoc 3: Chay bang Docker Compose

```bash
docker compose up -d
```

**Xong!** Server dang chay tai `http://localhost:8317`

### Cac lenh Docker huu ich

```bash
# Xem log
docker compose logs -f

# Dung server
docker compose down

# Khoi dong lai
docker compose restart

# Cap nhat phien ban moi
git pull
docker compose up -d --build
```

---

## 4. Cach 2: Cai truc tiep tren may

### Buoc 1: Tai ma nguon

```bash
git clone https://github.com/minhnv0807/opa-api.git
cd opa-api
```

### Buoc 2: Tao file cau hinh

```bash
# Windows (Command Prompt)
copy config.example.yaml config.yaml

# Mac/Linux
cp config.example.yaml config.yaml
```

Sua file `config.yaml` theo huong dan o [Muc 5](#5-cau-hinh-configyaml).

### Buoc 3: Build va chay

```bash
# Build
go build -o opa-api ./cmd/server/

# Chay (Linux/Mac)
./opa-api

# Chay (Windows)
opa-api.exe
```

**Xong!** Server dang chay tai `http://localhost:8317`

### Chay nen (Linux/Mac)

```bash
# Chay nen voi nohup
nohup ./opa-api > opa-api.log 2>&1 &

# Xem log
tail -f opa-api.log

# Tim va dung process
pkill opa-api
```

---

## 5. Cau hinh config.yaml

Mo file `config.yaml` bang bat ky text editor nao (Notepad, VS Code, nano...).

### 5.1 Cau hinh co ban (Bat buoc)

```yaml
# Port server (mac dinh 8317)
port: 8317

# API keys de xac thuc client ket noi vao proxy
# Doi thanh chuoi bat ky ban muon, VD: "my-secret-key-123"
api-keys:
  - "doi-thanh-key-cua-ban-1"
  - "doi-thanh-key-cua-ban-2"
```

> **Quan trong:** `api-keys` la mat khau de client (Claude Code, Gemini CLI...) ket noi vao proxy cua ban. Hay doi thanh chuoi bi mat chi minh ban biet.

### 5.2 Bat Management Panel (Tuy chon)

Management Panel la giao dien web de quan ly server. Mac dinh da bat san.

```yaml
remote-management:
  allow-remote: false    # true = cho phep truy cap tu may khac
  secret-key: "mat-khau-quan-ly"  # Dat mat khau cho panel
  disable-control-panel: false     # false = bat panel
```

> **Luu y:** Neu de `secret-key` trong (""), Management API se bi tat hoan toan (404). Dat mat khau de su dung panel.

### 5.3 Them tai khoan Gemini (OAuth - Mien phi)

Khong can cau hinh gi trong `config.yaml`. Chi can:

1. Chay server
2. Vao Management Panel (`http://localhost:8317/management/`)
3. Nhan "Login with Gemini" de dang nhap bang Google

### 5.4 Them API key Gemini (Tra phi / Mien phi)

```yaml
gemini-api-key:
  - api-key: "AIzaSy...key-cua-ban"
```

Lay API key tai: https://aistudio.google.com/apikey

### 5.5 Them API key Claude

```yaml
claude-api-key:
  - api-key: "sk-ant-...key-cua-ban"
```

Lay API key tai: https://console.anthropic.com/settings/keys

### 5.6 Them API key Codex (OpenAI)

```yaml
codex-api-key:
  - api-key: "sk-...key-cua-ban"
```

### 5.7 Them OpenAI-compatible provider (OpenRouter, v.v.)

```yaml
openai-compatibility:
  - name: "openrouter"
    base-url: "https://openrouter.ai/api/v1"
    api-key-entries:
      - api-key: "sk-or-v1-...key-cua-ban"
    models:
      - name: "moonshotai/kimi-k2:free"
        alias: "kimi-k2"
```

### 5.8 Cau hinh Proxy (Neu can VPN/SOCKS5)

```yaml
proxy-url: "socks5://user:pass@192.168.1.1:1080"
```

### 5.9 File config mau day du

```yaml
port: 8317

api-keys:
  - "my-secret-key-123"

remote-management:
  allow-remote: false
  secret-key: "admin-password"

gemini-api-key:
  - api-key: "AIzaSy...gemini-key"

claude-api-key:
  - api-key: "sk-ant-...claude-key"

debug: false
```

---

## 6. Truy cap Management Panel

Sau khi server da chay, mo trinh duyet va truy cap:

```
http://localhost:8317/management/
```

> Neu ban chay tren VPS/server khac, thay `localhost` bang IP cua server va bat `allow-remote: true` trong config.

### Cac trang trong Management Panel

| Trang | Chuc nang |
|-------|-----------|
| **Dashboard** | Tong quan: so provider, so request, trang thai |
| **Authentication** | Dang nhap OAuth (Gemini, Claude, Codex...) |
| **API Keys** | Them/xoa API key cho cac provider |
| **Auth Files** | Quan ly file xac thuc |
| **Models** | Loai tru model, dat alias |
| **Routing** | Chon chien luoc Round Robin / Fill First |
| **Config** | Sua file config.yaml truc tiep tren web |
| **Amp** | Cau hinh tich hop Amp CLI |
| **Logs** | Bat/tat debug, ghi log ra file |
| **Usage** | Xem thong ke su dung, xuat/nhap du lieu |

### Chuyen ngon ngu

Panel ho tro **Tieng Viet** va **Tieng Anh**. Nhan nut ngon ngu tren thanh TopBar de chuyen doi.

---

## 7. Ket noi voi cac AI CLI

Sau khi OPA API da chay, ban co the ket noi cac AI CLI tool vao.

### 7.1 Claude Code

```bash
# Dat API key (chinh la api-keys trong config.yaml)
export ANTHROPIC_API_KEY="my-secret-key-123"

# Dat base URL tro ve OPA proxy
export ANTHROPIC_BASE_URL="http://localhost:8317"

# Chay Claude Code binh thuong
claude
```

### 7.2 Gemini CLI

```bash
# Dat endpoint tro ve OPA proxy
export GEMINI_API_BASE="http://localhost:8317"

# Chay Gemini CLI
gemini
```

### 7.3 OpenAI Codex CLI

```bash
export OPENAI_API_KEY="my-secret-key-123"
export OPENAI_BASE_URL="http://localhost:8317"

codex
```

### 7.4 Amp CLI (IDE Extension)

Trong config cua Amp, dat upstream URL:

```
http://localhost:8317
```

Hoac cau hinh trong `config.yaml`:

```yaml
ampcode:
  upstream-url: "https://ampcode.com"
```

---

## 8. Cac loi thuong gap

### Server khong khoi dong duoc

**Loi:** `failed to load config: failed to read config file`
**Nguyen nhan:** Chua tao file `config.yaml`
**Cach sua:**
```bash
cp config.example.yaml config.yaml
```

---

**Loi:** `listen tcp :8317: bind: address already in use`
**Nguyen nhan:** Port 8317 dang bi chiem boi process khac
**Cach sua:**
```bash
# Tim process dang dung port 8317
# Linux/Mac:
lsof -i :8317
kill <PID>

# Windows:
netstat -ano | findstr :8317
taskkill /F /PID <PID>
```

Hoac doi port trong `config.yaml`:
```yaml
port: 9999
```

---

### Management Panel khong hien thi

**Nguyen nhan 1:** `secret-key` de trong
**Cach sua:** Dat mat khau trong config:
```yaml
remote-management:
  secret-key: "mat-khau-cua-ban"
```

**Nguyen nhan 2:** Panel chua download xong
**Cach sua:** Doi khoang 10 giay sau khi server khoi dong, roi reload trang.

**Nguyen nhan 3:** `disable-control-panel: true`
**Cach sua:** Doi thanh `false` hoac xoa dong do.

---

### Khong ket noi duoc tu may khac

**Nguyen nhan:** `allow-remote` dang la `false`
**Cach sua:**
```yaml
remote-management:
  allow-remote: true
```

Va dam bao firewall cho phep port 8317.

---

### OAuth login khong hoat dong

**Nguyen nhan:** Can truy cap server qua `localhost` hoac domain co HTTPS
**Cach sua:** Mo trinh duyet tai `http://localhost:8317/management/` (khong dung IP) de OAuth redirect hoat dong dung.

---

## Lien he ho tro

- GitHub Issues: https://github.com/minhnv0807/opa-api/issues
- OPA AI Labs: https://opa.vn
