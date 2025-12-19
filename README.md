# 🏗️ Arsitektur Docker - Fundamental Docker

## Diagram Arsitektur

Cara Menggunakan:
Mode Development (Default)
Gunakan perintah standar ini untuk pengembangan sehari-hari dengan fitur hot-reload:

bash
docker compose up --build
Client: http://localhost:8080 (Vite Dev Server)
Server: http://localhost:3001
Mode Production
Gunakan perintah ini untuk mensimulasikan lingkungan produksi (image lebih kecil, lebih aman):

bash
docker compose -f docker-compose.yml -f docker-compose.prod.yml up --build
Client: http://localhost:8080 (Dilayani oleh Nginx)
Server: http://localhost:3001 (Berjalan sebagai user non-root)

Untuk mengaktifkan fitur watch ini, jalankan perintah berikut:

bash
docker compose up --watch


```
┌─────────────────────────────────────────────────────────────────┐
│                         Docker Host                              │
│                                                                   │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │              Docker Network (app-network)                   │ │
│  │                         Bridge Mode                         │ │
│  │                                                             │ │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐    │ │
│  │  │   Client     │  │   Server     │  │  Database    │    │ │
│  │  │  Container   │  │  Container   │  │  Container   │    │ │
│  │  │              │  │              │  │              │    │ │
│  │  │  Nginx       │  │  Node.js     │  │  MySQL 8     │    │ │
│  │  │  Alpine      │  │  Express     │  │              │    │ │
│  │  │              │  │  Sequelize   │  │              │    │ │
│  │  │              │  │              │  │              │    │ │
│  │  │  Port: 80    │  │  Port: 3000  │  │  Port: 3306  │    │ │
│  │  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘    │ │
│  │         │                 │                  │            │ │
│  └─────────┼─────────────────┼──────────────────┼────────────┘ │
│            │                 │                  │              │
│    ┌───────▼─────────┬───────▼──────────┬───────▼────────┐    │
│    │ Port Mapping    │ Port Mapping     │ Port Mapping   │    │
│    │ 8080 → 80       │ 3000 → 3000      │ 3306 → 3306    │    │
│    └─────────────────┴──────────────────┴────────────────┘    │
│                                                                 │
│    ┌─────────────────────────────────────────────────────┐    │
│    │              Docker Volume                           │    │
│    │          mysql_data (persistent)                     │    │
│    │       Menyimpan data MySQL secara permanen          │    │
│    └─────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────┘
           │              │             │
           │              │             │
      ┌────▼──┐      ┌────▼──┐     ┌───▼────┐
      │Browser│      │ API   │     │Database│
      │ User  │      │Client │     │ Tool   │
      └───────┘      └───────┘     └────────┘
   localhost:8080  localhost:3000  localhost:3306
```

## Flow Komunikasi

### 1. User mengakses aplikasi
```
Browser → http://localhost:8080 → Client Container (Nginx)
                                   ↓
                              Serve React App
                                   ↓
                          User melihat halaman web
```

### 2. Frontend request ke Backend
```
React App → fetch('http://localhost:3000/users')
                                   ↓
                         Server Container (Express)
                                   ↓
                         Process Request + Auth
                                   ↓
                         Query Database
```

### 3. Backend query Database
```
Express (Sequelize) → Connect to "db:3306"
                                   ↓
                      Database Container (MySQL)
                                   ↓
                         Execute SQL Query
                                   ↓
                         Return Results
```

### 4. Response kembali ke User
```
Database → Server Container → Response JSON → Client → Browser
```

## Detail Service

### 🎨 Client Container
- **Image**: Built from `client/Dockerfile`
- **Base**: `node:20-alpine` (build) → `nginx:alpine` (serve)
- **Port**: 80 (internal) → 8080 (host)
- **Fungsi**: Serve static React build files
- **Dependencies**: Server (aplikasi butuh API)

**Multi-stage Build:**
```
Stage 1 (Builder):
  - Install dependencies
  - Build React app (npm run build)
  - Output: /app/dist

Stage 2 (Production):
  - Copy build artifacts dari Stage 1
  - Serve dengan Nginx
  - Size lebih kecil (tidak ada source code)
```

### ⚙️ Server Container
- **Image**: Built from `server/Dockerfile`
- **Base**: `node:20-alpine`
- **Port**: 3000 (internal & host)
- **Fungsi**: REST API Server
- **Dependencies**: Database (harus healthy sebelum start)

**Environment Variables:**
- `NODE_ENV=production`
- `DB_HOST=db` ← Penting! Gunakan nama service
- `DB_NAME`, `DB_USER`, `DB_PASS`

**Healthcheck Dependency:**
Server hanya akan start setelah MySQL healthcheck PASS

### 💾 Database Container
- **Image**: `mysql:8` (official dari Docker Hub)
- **Port**: 3306 (internal & host)
- **Fungsi**: Data persistence
- **Volume**: `mysql_data` (persistent storage)

**Healthcheck:**
```yaml
test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
interval: 10s  # Cek setiap 10 detik
timeout: 5s    # Timeout per check
retries: 5     # Retry 5x sebelum dianggap unhealthy
```

## Docker Network

### app-network (Bridge Mode)
- **Type**: Bridge network
- **Fungsi**: Isolasi dan komunikasi antar container
- **DNS**: Container bisa resolve nama service lain (e.g., `db`, `server`)

**Contoh:**
```javascript
// Di server, kita connect ke database dengan:
host: 'db'  // Bukan 'localhost'!

// Docker DNS akan resolve 'db' ke IP container database
```

## Docker Volume

### mysql_data
- **Type**: Named volume
- **Path**: `/var/lib/mysql` (di dalam container)
- **Fungsi**: Persistent data storage
- **Lifecycle**: Tetap ada meskipun container dihapus

**Mengapa perlu volume?**
1. Data tidak hilang saat `docker-compose down`
2. Bisa di-backup & restore
3. Bisa di-share antar container (jika diperlukan)

**Cara hapus data:**
```bash
docker-compose down -v  # Hapus container DAN volume
```

## Build Context & .dockerignore

### Build Context
Semua file di folder `client/` dan `server/` akan dikirim ke Docker daemon saat build.

**Masalah tanpa .dockerignore:**
- Build lambat (kirim `node_modules/` yang ukurannya besar)
- Image size besar
- Credential leak (jika kirim `.env`)

**Solusi dengan .dockerignore:**
```
node_modules/   ← Tidak dikirim (akan di-install ulang di container)
.env            ← Tidak dikirim (gunakan env di docker-compose.yml)
.git/           ← Tidak perlu
```

## Lifecycle Container

### Startup Sequence
```
1. Docker compose membaca docker-compose.yml
2. Create network 'app-network'
3. Create volume 'mysql_data'
4. Pull/Build images (jika belum ada)
5. Start database container
   ↓
   Healthcheck: Wait until MySQL ready
   ↓
6. Start server container (depends_on db healthy)
7. Start client container (depends_on server)
```

### Shutdown Sequence
```
1. docker-compose down
2. Stop client container
3. Stop server container
4. Stop database container
5. Remove containers
6. Remove network
7. Volume tetap ada (kecuali -v flag)
```

## Resource Management

### Default Resources
Containers tidak di-limit secara default dan bisa menggunakan semua resource host.

### Cara Limit Resources (Optional)
Tambahkan di docker-compose.yml:

```yaml
services:
  server:
    deploy:
      resources:
        limits:
          cpus: '0.5'      # Maksimal 50% CPU
          memory: 512M     # Maksimal 512MB RAM
        reservations:
          cpus: '0.25'     # Minimal 25% CPU
          memory: 256M     # Minimal 256MB RAM
```

## Security Best Practices

### ✅ Yang Sudah Diterapkan:
1. **Multi-stage build** (client) - Tidak ada source code di production image
2. **Alpine images** - Minimal attack surface
3. **Named volumes** - Data isolation
4. **Bridge network** - Container isolation
5. **.dockerignore** - Tidak kirim sensitive files

### 🔒 Peningkatan Security (Opsional):
1. Gunakan Docker secrets untuk credentials
2. Run container sebagai non-root user
3. Scan images untuk vulnerabilities (`docker scan`)
4. Update images secara berkala
5. Gunakan .env file (jangan hardcode credentials)

## Monitoring & Debugging

### Lihat Resource Usage
```bash
docker stats
```

Output:
```
CONTAINER           CPU %    MEM USAGE / LIMIT    MEM %
fundamental-client  0.00%    2.5MiB / 7.6GiB     0.03%
fundamental-server  0.50%    45MiB / 7.6GiB      0.58%
fundamental-db      0.27%    380MiB / 7.6GiB     4.88%
```

### Inspect Container
```bash
docker inspect fundamental-server
```

### View Processes
```bash
docker top fundamental-server
```

### View Logs
```bash
docker-compose logs -f --tail=100 server
```

## Scaling (Advanced)

Untuk scale horizontal (multiple instances):

```bash
# Jalankan 3 instance server
docker-compose up --scale server=3
```

**Note:** Perlu load balancer (Nginx/HAProxy) di depan untuk distribute traffic.

## Perbandingan: Docker vs Traditional

### Traditional Development
```
Developer A:
- Windows 10
- Node 14
- MySQL 5.7
→ "Works on my machine" ✅

Developer B:
- macOS
- Node 18
- PostgreSQL 13
→ "Doesn't work!" ❌

Production:
- Ubuntu
- Node 16
- MySQL 8
→ "Different behavior!" ⚠️
```

### Dengan Docker
```
Developer A, B, Production:
- Same Docker images
- Same dependencies
- Same environment
→ Konsisten di mana pun! ✅✅✅
```

## Kesimpulan

Docker setup ini memberikan:
1. **Consistency** - Jalan sama di semua environment
2. **Isolation** - Setiap service terisolasi
3. **Portability** - Mudah deploy ke production
4. **Scalability** - Mudah di-scale jika traffic tinggi
5. **Easy Onboarding** - Developer baru tinggal `docker-compose up`

---

**Untuk cara pakai, lihat:** [DOCKER_README.md](./DOCKER_README.md)
**Untuk troubleshooting, lihat:** [DOCKER_GUIDE.md](./DOCKER_GUIDE.md)
