# 🐳 Docker Setup - Fundamental Docker

Selamat datang di panduan Docker lengkap untuk pemula! 

Project ini adalah Full Stack aplikasi (React + Express + MySQL) yang sudah dikonfigurasi dengan Docker untuk memudahkan development dan deployment.

---

## 📋 Daftar Isi Dokumentasi

### 🚀 Quick Start
**[DOCKER_README.md](./DOCKER_README.md)** - Mulai di sini!
- Cara menjalankan aplikasi dengan Docker
- Perintah-perintah dasar
- Troubleshooting cepat
- **Waktu baca: 5 menit**

### 📚 Panduan Lengkap
**[DOCKER_GUIDE.md](./DOCKER_GUIDE.md)** - Untuk pemahaman mendalam
- Konsep Docker dari nol
- Penjelasan setiap komponen
- Troubleshooting detail
- Tips development
- FAQ
- **Waktu baca: 20 menit**

### 🏗️ Arsitektur Sistem
**[DOCKER_ARCHITECTURE.md](./DOCKER_ARCHITECTURE.md)** - Untuk yang ingin tahu detail teknis
- Diagram arsitektur lengkap
- Flow komunikasi antar container
- Detail setiap service
- Network & Volume management
- Security best practices
- **Waktu baca: 15 menit**

### 📖 Cheatsheet
**[DOCKER_CHEATSHEET.md](./DOCKER_CHEATSHEET.md)** - Referensi cepat
- Semua perintah Docker yang sering digunakan
- Organized by category
- Quick reference
- **Bookmark untuk referensi!**

### 🔌 Konfigurasi API
**[API_CONFIG_EXAMPLE.js](./API_CONFIG_EXAMPLE.js)** - Untuk developer frontend
- Cara menghubungkan React ke Express API
- Environment setup
- Contoh code siap pakai
- **Waktu baca: 10 menit**

---

## 🎯 Jalur Pembelajaran

### Pemula Total (Belum pernah pakai Docker)
1. ✅ Baca [DOCKER_README.md](./DOCKER_README.md) - Pahami perintah dasar
2. ✅ Jalankan `docker-compose up --build` - Praktik langsung
3. ✅ Baca [DOCKER_GUIDE.md](./DOCKER_GUIDE.md) - Pahami konsep
4. ✅ Eksperimen dengan perintah di [DOCKER_CHEATSHEET.md](./DOCKER_CHEATSHEET.md)
5. ✅ (Optional) Baca [DOCKER_ARCHITECTURE.md](./DOCKER_ARCHITECTURE.md) untuk deep dive

### Sudah Familiar dengan Docker
1. ✅ Lihat struktur di [DOCKER_ARCHITECTURE.md](./DOCKER_ARCHITECTURE.md)
2. ✅ Review docker-compose.yml
3. ✅ Review Dockerfiles
4. ✅ Jalankan dan customize sesuai kebutuhan

### Frontend Developer (Perlu integrasi API)
1. ✅ Baca [API_CONFIG_EXAMPLE.js](./API_CONFIG_EXAMPLE.js)
2. ✅ Setup environment di React app
3. ✅ Test API connection
4. ✅ Lihat nginx.conf untuk production setup

---

## 🚀 Quick Start (TL;DR)

```bash
# 1. Clone/masuk ke project folder
cd FundamentalDocker

# 2. Jalankan aplikasi
docker-compose up --build

# 3. Akses di browser
# - Frontend: http://localhost:8080
# - Backend API: http://localhost:3000
# - Database: localhost:3306

# 4. Hentikan aplikasi
docker-compose down

# Atau gunakan helper script interaktif
./docker-helper.sh
```

---

## 📁 Struktur Project

```
📦 FundamentalDocker/
│
├── 📄 docker-compose.yml           # Orchestration semua services
├── 📄 .dockerignore                # File yang diabaikan saat build
│
├── 📁 client/                      # Frontend React + TypeScript + Vite
│   ├── 📄 Dockerfile               # Build instructions (multi-stage)
│   ├── 📄 nginx.conf               # Nginx config (routing + proxy)
│   ├── 📄 .dockerignore
│   └── 📁 src/                     # Source code React
│
├── 📁 server/                      # Backend Express.js + MySQL
│   ├── 📄 Dockerfile               # Build instructions
│   ├── 📄 .dockerignore
│   ├── 📄 .env.example             # Template environment variables
│   ├── 📁 config/                  # Database config
│   ├── 📁 models/                  # Sequelize models
│   └── 📁 routes/                  # API routes
│
└── 📚 Dokumentasi/
    ├── 📄 INDEX.md                 # File ini (overview semua docs)
    ├── 📄 DOCKER_README.md         # Quick start guide
    ├── 📄 DOCKER_GUIDE.md          # Panduan lengkap
    ├── 📄 DOCKER_ARCHITECTURE.md   # Technical deep dive
    ├── 📄 DOCKER_CHEATSHEET.md     # Command reference
    ├── 📄 API_CONFIG_EXAMPLE.js    # Frontend API setup
    └── 📄 docker-helper.sh         # Interactive CLI tool
```

---

## 🐳 Services yang Berjalan

### 1. 💾 Database (MySQL 8)
- **Container**: `fundamental-db`
- **Port**: 3306
- **Credentials**:
  - User: `dbuser`
  - Password: `dbpassword`
  - Database: `fundamental_docker`
- **Volume**: `mysql_data` (persistent storage)

### 2. ⚙️ Backend (Express.js)
- **Container**: `fundamental-server`
- **Port**: 3000
- **Tech Stack**: Node.js, Express, Sequelize
- **Endpoint**: `http://localhost:3000`

### 3. 🎨 Frontend (React)
- **Container**: `fundamental-client`
- **Port**: 8080 (mapped dari 80)
- **Tech Stack**: React, TypeScript, Vite, Nginx
- **Endpoint**: `http://localhost:8080`
- **API Proxy**: `/api` → `http://server:3000`

---

## 🛠️ Tools & Utilities

### 🎮 Interactive Helper Script
```bash
./docker-helper.sh
```

Menu interaktif untuk menjalankan perintah Docker tanpa perlu hafal syntax:
- ✅ Start/stop aplikasi
- ✅ Lihat logs
- ✅ Masuk ke container
- ✅ Cleanup
- ✅ Dan banyak lagi!

### 📊 Monitoring
```bash
# Lihat status
docker-compose ps

# Lihat logs real-time
docker-compose logs -f

# Lihat resource usage
docker stats
```

---

## 🔧 Development Workflow

### Workflow Normal
```bash
# 1. Build dan jalankan
docker-compose up --build

# 2. Edit code di folder client/ atau server/

# 3. Rebuild service yang berubah
docker-compose build client  # atau server
docker-compose up -d

# 4. Lihat logs jika ada error
docker-compose logs -f server
```

### Development Mode (Hot Reload)
Edit `docker-compose.yml`, uncomment volumes di service server:

```yaml
server:
  volumes:
    - ./server:/app
    - /app/node_modules
  command: npm run dev  # Gunakan nodemon
```

Sekarang perubahan di folder `server/` akan langsung terdeteksi!

---

## 🆘 Troubleshooting Cepat

### ❌ Port sudah digunakan
```bash
# Ubah port di docker-compose.yml
ports:
  - "3001:3000"  # Gunakan 3001 instead of 3000
```

### ❌ Database connection failed
```bash
# Check env di docker-compose.yml
DB_HOST: db  # Harus 'db', bukan 'localhost'

# Lihat logs database
docker-compose logs db
```

### ❌ Perubahan code tidak terdeteksi
```bash
# Rebuild without cache
docker-compose build --no-cache
docker-compose up
```

### ❌ Container crash
```bash
# Lihat error
docker-compose logs server

# Lihat status
docker ps -a
```

**Untuk troubleshooting lengkap**: Lihat [DOCKER_GUIDE.md](./DOCKER_GUIDE.md#troubleshooting)

---

## 📖 Penjelasan File Konfigurasi

### docker-compose.yml
File utama yang mengatur semua services (database, server, client).
- Definisi services
- Network configuration
- Volume management
- Environment variables
- Dependencies & health checks

**Penjelasan lengkap**: [DOCKER_GUIDE.md](./DOCKER_GUIDE.md#memahami-docker-composeyml)

### client/Dockerfile
Multi-stage build untuk React app:
1. **Stage 1 (builder)**: Install deps → Build app
2. **Stage 2 (production)**: Copy build → Serve with Nginx

**Penjelasan lengkap**: [DOCKER_GUIDE.md](./DOCKER_GUIDE.md#memahami-dockerfile)

### server/Dockerfile
Single-stage build untuk Express app:
- Install production dependencies
- Copy source code
- Run with Node.js

### client/nginx.conf
Nginx configuration untuk:
- Serve React static files
- Support React Router (SPA routing)
- Reverse proxy API requests ke backend
- Gzip compression

**Contoh usage**: [API_CONFIG_EXAMPLE.js](./API_CONFIG_EXAMPLE.js)

### .dockerignore
Exclude files dari Docker build context:
- `node_modules/` - Akan di-install ulang
- `.env` - Security
- `.git/` - Tidak perlu

---

## 🎓 Belajar Lebih Lanjut

### Konsep Docker
- **Container vs VM**: [DOCKER_GUIDE.md](./DOCKER_GUIDE.md#apa-itu-docker)
- **Image vs Container**: [DOCKER_ARCHITECTURE.md](./DOCKER_ARCHITECTURE.md#konsep-dasar)
- **Volumes**: [DOCKER_ARCHITECTURE.md](./DOCKER_ARCHITECTURE.md#docker-volume)
- **Networks**: [DOCKER_ARCHITECTURE.md](./DOCKER_ARCHITECTURE.md#docker-network)

### Best Practices
- **Multi-stage builds**: [DOCKER_ARCHITECTURE.md](./DOCKER_ARCHITECTURE.md#client-container)
- **Security**: [DOCKER_ARCHITECTURE.md](./DOCKER_ARCHITECTURE.md#security-best-practices)
- **.dockerignore**: [DOCKER_ARCHITECTURE.md](./DOCKER_ARCHITECTURE.md#build-context--dockerignore)

### Advanced Topics
- **Scaling**: [DOCKER_ARCHITECTURE.md](./DOCKER_ARCHITECTURE.md#scaling-advanced)
- **Resource limits**: [DOCKER_ARCHITECTURE.md](./DOCKER_ARCHITECTURE.md#resource-management)
- **Monitoring**: [DOCKER_ARCHITECTURE.md](./DOCKER_ARCHITECTURE.md#monitoring--debugging)

---

## 🌟 Keuntungan Setup Ini

✅ **Consistency** - Jalan sama di semua environment (Windows, Mac, Linux)
✅ **Isolation** - Setiap service terisolasi, tidak bentrok dependencies
✅ **Portability** - Mudah deploy ke production (AWS, GCP, Azure, dll)
✅ **Easy Onboarding** - Developer baru tinggal `docker-compose up`
✅ **Reproducible** - Environment konsisten untuk semua developer
✅ **Clean** - Tidak "mengotori" sistem dengan install dependencies

---

## 💡 Tips Pro

1. **Gunakan `.env` files** untuk manage credentials
2. **Commit `.env.example`**, jangan commit `.env`
3. **Named volumes** untuk data persistence
4. **Multi-stage builds** untuk image lebih kecil
5. **Health checks** untuk dependency management
6. **docker-compose.override.yml** untuk local dev settings
7. **Bookmark DOCKER_CHEATSHEET.md** untuk referensi cepat

---

## 🤝 Kontribusi & Feedback

Jika menemukan error atau punya saran improvement:
1. Dokumentasikan issue
2. Coba troubleshooting dengan [DOCKER_GUIDE.md](./DOCKER_GUIDE.md)
3. Check logs: `docker-compose logs -f`

---

## 📞 Resource Tambahan

- **Docker Documentation**: https://docs.docker.com/
- **Docker Compose**: https://docs.docker.com/compose/
- **Docker Hub** (registry images): https://hub.docker.com/
- **Best Practices**: https://docs.docker.com/develop/dev-best-practices/

---

## ✨ Next Steps

Setelah familiar dengan setup ini, Anda bisa:

1. **Customize** untuk project lain
2. **Add services** (Redis, PostgreSQL, etc.)
3. **Setup CI/CD** (GitHub Actions, GitLab CI)
4. **Deploy** ke cloud (AWS ECS, Google Cloud Run, Azure Container Instances)
5. **Orchestration** dengan Kubernetes (untuk scale besar)

---

**Selamat belajar Docker! 🚀**

*Mulai dari [DOCKER_README.md](./DOCKER_README.md) untuk quick start, atau langsung*
*`docker-compose up --build` untuk hands-on!*
