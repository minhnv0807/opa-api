# OPA API - Huong dan cai dat tren VPS Ubuntu

> Huong dan chi tiet tung buoc cho nguoi chua tung dung VPS. Chi can copy/paste tung lenh la xong.

---

## Muc luc

1. [Ket noi vao VPS](#1-ket-noi-vao-vps)
2. [Cach 1: Cai bang Docker (Khuyen dung)](#2-cach-1-cai-bang-docker)
3. [Cach 2: Cai truc tiep bang Go](#3-cach-2-cai-truc-tiep-bang-go)
4. [Cau hinh config.yaml](#4-cau-hinh-configyaml)
5. [Mo firewall](#5-mo-firewall)
6. [Chay tu dong khi VPS khoi dong lai](#6-chay-tu-dong-khi-vps-khoi-dong-lai)
7. [Cau hinh domain + HTTPS (Tuy chon)](#7-cau-hinh-domain--https)
8. [Quan ly va bao tri](#8-quan-ly-va-bao-tri)
9. [Cac loi thuong gap](#9-cac-loi-thuong-gap)

---

## 1. Ket noi vao VPS

### Tu Windows

Tai va cai **PuTTY**: https://www.putty.org/ hoac dung **Windows Terminal**:

```bash
ssh root@IP_VPS_CUA_BAN
```

### Tu Mac/Linux

Mo Terminal:

```bash
ssh root@IP_VPS_CUA_BAN
```

> Thay `IP_VPS_CUA_BAN` bang IP that cua VPS, vi du: `ssh root@103.123.45.67`

Nhap mat khau khi duoc hoi (mat khau se khong hien thi khi go, day la binh thuong).

### Cap nhat he thong (Lam 1 lan dau tien)

```bash
apt update && apt upgrade -y
```

---

## 2. Cach 1: Cai bang Docker

> Cach nay don gian nhat, tu dong quan ly moi thu.

### Buoc 1: Cai Docker

```bash
# Cai Docker
curl -fsSL https://get.docker.com | sh

# Kiem tra Docker da cai thanh cong
docker --version
```

Ket qua mong doi: `Docker version 27.x.x`

### Buoc 2: Tai OPA API

```bash
# Tao thu muc chua OPA
mkdir -p /opt/opa-api
cd /opt/opa-api

# Tai ma nguon
git clone https://github.com/minhnv0807/opa-api.git .
```

### Buoc 3: Tao file cau hinh

```bash
cp config.example.yaml config.yaml
```

Sua file cau hinh:

```bash
nano config.yaml
```

> **Huong dan dung nano:**
> - Dung phim mui ten de di chuyen
> - Sua noi dung binh thuong
> - Nhan `Ctrl + O` roi `Enter` de luu
> - Nhan `Ctrl + X` de thoat

Sua cac dong sau (xem chi tiet o [Muc 4](#4-cau-hinh-configyaml)):

```yaml
port: 8317

api-keys:
  - "doi-thanh-key-bi-mat-cua-ban"

remote-management:
  allow-remote: true
  secret-key: "mat-khau-quan-ly"
```

### Buoc 4: Tao thu muc luu tru

```bash
# Tao thu muc chua file xac thuc va log
mkdir -p /opt/opa-api/auths
mkdir -p /opt/opa-api/logs
```

### Buoc 5: Chay server

```bash
docker compose up -d
```

### Buoc 6: Kiem tra

```bash
# Xem trang thai
docker compose ps

# Xem log (Ctrl+C de thoat)
docker compose logs -f
```

Ket qua mong doi:

```
opa-api  | API server started successfully on: :8317
opa-api  | management panel updated successfully
```

**Xong!** Truy cap `http://IP_VPS:8317/management/` tren trinh duyet.

---

## 3. Cach 2: Cai truc tiep bang Go

> Cach nay khong can Docker, chay truc tiep tren he thong.

### Buoc 1: Cai Go

```bash
# Tai Go (phien ban moi nhat)
wget https://go.dev/dl/go1.24.2.linux-amd64.tar.gz

# Giai nen vao /usr/local
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.24.2.linux-amd64.tar.gz

# Them Go vao PATH
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
source ~/.bashrc

# Kiem tra
go version
```

Ket qua mong doi: `go version go1.24.2 linux/amd64`

> **Luu y:** Kiem tra phien ban Go moi nhat tai https://go.dev/dl/ va thay link tuong ung.

### Buoc 2: Tai va build OPA API

```bash
# Tao thu muc
mkdir -p /opt/opa-api
cd /opt/opa-api

# Tai ma nguon
git clone https://github.com/minhnv0807/opa-api.git .

# Build
go build -o opa-api ./cmd/server/
```

### Buoc 3: Tao file cau hinh

```bash
cp config.example.yaml config.yaml
nano config.yaml
```

Sua cac dong quan trong (xem chi tiet o [Muc 4](#4-cau-hinh-configyaml)):

```yaml
port: 8317

api-keys:
  - "doi-thanh-key-bi-mat-cua-ban"

remote-management:
  allow-remote: true
  secret-key: "mat-khau-quan-ly"
```

### Buoc 4: Chay thu

```bash
./opa-api
```

Thay dong `API server started successfully on: :8317` la thanh cong. Nhan `Ctrl + C` de dung.

### Buoc 5: Cai dat systemd de chay nen

Tao file service:

```bash
cat > /etc/systemd/system/opa-api.service << 'EOF'
[Unit]
Description=OPA API Proxy Server
After=network.target

[Service]
Type=simple
WorkingDirectory=/opt/opa-api
ExecStart=/opt/opa-api/opa-api
Restart=always
RestartSec=5
StandardOutput=journal
StandardError=journal

# Bao mat: chay bang user rieng (tuy chon)
# User=opa
# Group=opa

[Install]
WantedBy=multi-user.target
EOF
```

Kich hoat va chay:

```bash
# Reload systemd
systemctl daemon-reload

# Bat tu dong chay khi VPS khoi dong
systemctl enable opa-api

# Chay ngay
systemctl start opa-api

# Kiem tra trang thai
systemctl status opa-api
```

Ket qua mong doi:

```
● opa-api.service - OPA API Proxy Server
     Active: active (running)
```

---

## 4. Cau hinh config.yaml

### 4.1 Cau hinh toi thieu (Bat buoc)

```yaml
# Port server
port: 8317

# API key de client ket noi vao proxy
# Day la "mat khau" ma Claude Code, Gemini CLI... se dung
api-keys:
  - "key-bi-mat-1"
  - "key-bi-mat-2"

# Bat Management Panel
remote-management:
  allow-remote: true          # true vi ban truy cap tu xa
  secret-key: "admin-123"     # Mat khau vao panel
```

### 4.2 Them tai khoan AI

#### Gemini API Key

```yaml
gemini-api-key:
  - api-key: "AIzaSy...key-cua-ban"
```

Lay key tai: https://aistudio.google.com/apikey (mien phi)

#### Claude API Key

```yaml
claude-api-key:
  - api-key: "sk-ant-...key-cua-ban"
```

Lay key tai: https://console.anthropic.com/settings/keys

#### Nhieu key cung luc (Load Balancing)

```yaml
gemini-api-key:
  - api-key: "AIzaSy...key-1"
  - api-key: "AIzaSy...key-2"
  - api-key: "AIzaSy...key-3"

claude-api-key:
  - api-key: "sk-ant-...key-1"
  - api-key: "sk-ant-...key-2"
```

OPA se tu dong luan phien (round-robin) giua cac key.

### 4.3 Cau hinh Proxy/VPN (Neu can)

```yaml
proxy-url: "socks5://user:pass@ip:port"
```

### 4.4 File config day du mau

```yaml
port: 8317

api-keys:
  - "my-secret-key-123"

remote-management:
  allow-remote: true
  secret-key: "admin-password-day"

debug: false

routing:
  strategy: "round-robin"

quota-exceeded:
  switch-project: true

gemini-api-key:
  - api-key: "AIzaSy...key-1"
  - api-key: "AIzaSy...key-2"

claude-api-key:
  - api-key: "sk-ant-...key-1"
```

---

## 5. Mo firewall

### Ubuntu UFW

```bash
# Mo port 8317
ufw allow 8317/tcp

# Kiem tra
ufw status
```

### Neu dung nha cung cap cloud (AWS, GCP, DigitalOcean...)

Can mo port 8317 trong **Security Group** / **Firewall Rules** cua nha cung cap:

- **AWS:** EC2 > Security Groups > Inbound Rules > Add Rule > Custom TCP > Port 8317
- **GCP:** VPC Network > Firewall > Create Rule > tcp:8317
- **DigitalOcean:** Networking > Firewalls > Inbound Rules > Custom > 8317
- **Vultr:** Firewall > Add Rule > TCP > 8317

---

## 6. Chay tu dong khi VPS khoi dong lai

### Voi Docker

Docker Compose da co `restart: unless-stopped`, tu dong chay lai khi VPS reboot.

### Voi systemd (cai truc tiep)

Da cau hinh o Buoc 5 cua [Cach 2](#3-cach-2-cai-truc-tiep-bang-go). Kiem tra:

```bash
# Dam bao da enable
systemctl enable opa-api

# Thu reboot
reboot

# Sau khi VPS len lai, kiem tra
systemctl status opa-api
```

---

## 7. Cau hinh domain + HTTPS

> Tuy chon nhung khuyen dung. HTTPS can thiet cho OAuth login hoat dong dung.

### Buoc 1: Tro domain ve VPS

Vao nha quan ly domain (Cloudflare, Namecheap...) va tao ban ghi:

```
Type: A
Name: api (hoac @ cho root domain)
Value: IP_VPS_CUA_BAN
TTL: Auto
```

Vi du: `api.example.com` -> `103.123.45.67`

### Buoc 2: Cai Nginx

```bash
apt install nginx -y
```

### Buoc 3: Cau hinh Nginx reverse proxy

```bash
cat > /etc/nginx/sites-available/opa-api << 'EOF'
server {
    listen 80;
    server_name api.example.com;    # Doi thanh domain cua ban

    location / {
        proxy_pass http://127.0.0.1:8317;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_read_timeout 600s;
        proxy_send_timeout 600s;
        proxy_buffering off;
    }
}
EOF

# Kich hoat site
ln -sf /etc/nginx/sites-available/opa-api /etc/nginx/sites-enabled/

# Kiem tra cau hinh
nginx -t

# Reload nginx
systemctl reload nginx
```

### Buoc 4: Cai SSL (HTTPS) bang Certbot

```bash
# Cai certbot
apt install certbot python3-certbot-nginx -y

# Lay chung chi SSL (tu dong cau hinh nginx)
certbot --nginx -d api.example.com
```

Lam theo huong dan tren man hinh (nhap email, dong y dieu khoan).

**Xong!** Truy cap `https://api.example.com/management/`

### Buoc 5: Tu dong gia han SSL

Certbot tu dong gia han. Kiem tra:

```bash
certbot renew --dry-run
```

---

## 8. Quan ly va bao tri

### Xem log

```bash
# Docker
docker compose logs -f

# Systemd
journalctl -u opa-api -f
```

### Khoi dong lai server

```bash
# Docker
docker compose restart

# Systemd
systemctl restart opa-api
```

### Cap nhat phien ban moi

```bash
cd /opt/opa-api

# Tai code moi
git pull

# Docker
docker compose up -d --build

# Hoac neu cai truc tiep
go build -o opa-api ./cmd/server/
systemctl restart opa-api
```

### Sao luu

```bash
# Sao luu config va file xac thuc
cp config.yaml config.yaml.backup
cp -r ~/.opa-api ~/.opa-api.backup

# Hoac neu dung Docker
cp -r /opt/opa-api/auths /opt/opa-api/auths.backup
```

### Xem dung luong

```bash
# Xem dung luong thu muc OPA
du -sh /opt/opa-api/

# Xem dung luong log
du -sh /opt/opa-api/logs/
```

---

## 9. Cac loi thuong gap

### Khong truy cap duoc tu trinh duyet

**Kiem tra 1:** Server co dang chay khong?
```bash
# Docker
docker compose ps

# Systemd
systemctl status opa-api
```

**Kiem tra 2:** Port da mo chua?
```bash
ufw status
# Phai thay 8317 ALLOW
```

**Kiem tra 3:** Server co lang nghe dung port?
```bash
ss -tlnp | grep 8317
# Phai thay LISTEN
```

---

### Management Panel trang trang / khong load

**Nguyen nhan:** Panel chua download xong tu GitHub
**Cach sua:** Doi 10-15 giay roi reload. Kiem tra log:
```bash
# Docker
docker compose logs | grep management

# Systemd
journalctl -u opa-api | grep management
```

Thay dong `management panel updated successfully` la OK.

---

### Loi "connection refused"

**Nguyen nhan:** Server chua chay hoac `host` dang la `127.0.0.1`
**Cach sua:** Trong `config.yaml`, dam bao:
```yaml
host: ""    # De trong = lang nghe tat ca interface
```

---

### Loi "permission denied"

```bash
# Cap quyen chay cho file binary
chmod +x /opt/opa-api/opa-api

# Neu dung Docker, dam bao user co quyen
usermod -aG docker $USER
```

---

### OAuth login khong redirect ve dung

**Nguyen nhan:** Can HTTPS de OAuth hoat dong khi truy cap tu xa
**Cach sua:** Cau hinh domain + HTTPS theo [Muc 7](#7-cau-hinh-domain--https)

---

### Muon doi port

Sua `config.yaml`:
```yaml
port: 9999    # Doi thanh port khac
```

Roi khoi dong lai:
```bash
# Docker
docker compose down
# Sua docker-compose.yml: doi "8317:8317" thanh "9999:9999"
docker compose up -d

# Systemd
systemctl restart opa-api
```

Va mo port moi trong firewall:
```bash
ufw allow 9999/tcp
```

---

## Tong ket

| Buoc | Docker | Cai truc tiep |
|------|--------|---------------|
| 1 | `curl -fsSL https://get.docker.com \| sh` | Cai Go |
| 2 | `git clone` + `cp config` | `git clone` + `go build` |
| 3 | `docker compose up -d` | Tao systemd service |
| 4 | Mo firewall | Mo firewall |
| 5 | Truy cap `http://IP:8317/management/` | Truy cap `http://IP:8317/management/` |

**Thoi gian cai dat:** ~5 phut (Docker) hoac ~10 phut (truc tiep)

---

## Lien he ho tro

- GitHub Issues: https://github.com/minhnv0807/opa-api/issues
- OPA AI Labs: https://opa.vn
