# OPA API - Cai dat tren VPS Ubuntu

## Cai dat moi (Copy/paste tung buoc)

### Buoc 1: SSH vao VPS

```bash
ssh root@IP_VPS_CUA_BAN
```

### Buoc 2: Cai Docker + Clone repo

```bash
curl -fsSL https://get.docker.com | sh && mkdir -p /opt/opa-api && cd /opt/opa-api && git clone https://github.com/minhnv0807/opa-api.git .
```

### Buoc 3: Tao config

```bash
cd /opt/opa-api && cp config.example.yaml config.yaml && nano config.yaml
```

Sua 3 muc bat buoc:

```yaml
api-keys:
  - "doi-thanh-key-cua-ban"

remote-management:
  allow-remote: true
  secret-key: "mat-khau-panel-cua-ban"
```

> Nano: `Ctrl+O` Enter de luu, `Ctrl+X` de thoat.

### Buoc 4: Chay

```bash
cd /opt/opa-api && mkdir -p auths logs && docker compose pull && docker compose up -d
```

### Buoc 5: Mo firewall

```bash
ufw allow 8317/tcp
```

### Buoc 6: Kiem tra

```bash
docker compose logs -f
```

Thay dong `API server started successfully on: :8317` la thanh cong. `Ctrl+C` de thoat log.

Truy cap: `http://IP_VPS:8317/management/`

---

## Cap nhat phien ban moi

```bash
cd /opt/opa-api && git pull && docker compose pull && docker compose up -d
```

> Chi mat ~30 giay. Image duoc build san tren GitHub, VPS chi tai ve.

---

## Cac lenh thuong dung

```bash
# Xem trang thai
docker compose ps

# Xem log (Ctrl+C de thoat)
docker compose logs -f

# Khoi dong lai
docker compose restart

# Dung server
docker compose down

# Sua config roi khoi dong lai
nano config.yaml
docker compose restart
```

---

## Sao luu

```bash
cd /opt/opa-api && cp config.yaml config.yaml.backup && cp -r auths auths.backup
```

---

## Loi thuong gap

| Loi | Cach sua |
|-----|----------|
| Khong truy cap duoc | `ufw allow 8317/tcp` |
| Panel trang trang | Doi 15 giay, reload. Kiem tra: `docker compose logs \| grep management` |
| Connection refused | Trong config.yaml: `host: ""` (de trong) |
| Muon doi port | Sua `port:` trong config.yaml, sua `docker-compose.yml` ports, `ufw allow PORT/tcp` |

---

## Them HTTPS (Tuy chon)

```bash
apt install nginx certbot python3-certbot-nginx -y
```

```bash
cat > /etc/nginx/sites-available/opa-api << 'EOF'
server {
    listen 80;
    server_name domain.cua.ban;
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
        proxy_buffering off;
    }
}
EOF
```

```bash
ln -sf /etc/nginx/sites-available/opa-api /etc/nginx/sites-enabled/ && nginx -t && systemctl reload nginx && certbot --nginx -d domain.cua.ban
```

Truy cap: `https://domain.cua.ban/management/`
