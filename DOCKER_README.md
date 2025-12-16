# 🐳 Docker Setup - Quick Start

## Menjalankan Aplikasi dengan Docker

### 1. Pastikan Docker sudah terinstall
```bash
docker --version
docker-compose --version
```

### 2. Jalankan semua service
```bash
docker-compose up --build
```

### 3. Akses aplikasi
- Frontend: http://localhost:8080
- Backend API: http://localhost:3000
- Database: localhost:3306

### 4. Hentikan aplikasi
```bash
docker-compose down
```

## Struktur File Docker

```
📁 FundamentalDocker/
├── 📄 docker-compose.yml       # Orchestration semua services
├── 📄 DOCKER_GUIDE.md          # Panduan lengkap (BACA INI!)
├── 📁 client/
│   ├── 📄 Dockerfile           # Build instructions untuk React
│   └── 📄 .dockerignore
└── 📁 server/
    ├── 📄 Dockerfile           # Build instructions untuk Express
    ├── 📄 .dockerignore
    └── 📄 .env.example         # Template environment variables
```

## Services yang Berjalan

1. **Database (MySQL 8)**
   - Port: 3306
   - User: dbuser
   - Password: dbpassword
   - Database: fundamental_docker

2. **Server (Express.js)**
   - Port: 3000
   - Node.js + Express + Sequelize

3. **Client (React + Vite)**
   - Port: 8080
   - Served by Nginx

## Perintah Berguna

```bash
# Lihat logs
docker-compose logs -f

# Restart service tertentu
docker-compose restart server

# Masuk ke container
docker exec -it fundamental-server sh
docker exec -it fundamental-db mysql -u dbuser -p

# Rebuild setelah perubahan code
docker-compose up --build

# Hapus semua (termasuk data)
docker-compose down -v
```

## Troubleshooting

❌ **Port sudah digunakan?**
→ Ubah port di `docker-compose.yml`

❌ **Database connection error?**
→ Pastikan env `DB_HOST=db` (bukan localhost)

❌ **Perubahan code tidak terdeteksi?**
→ Rebuild: `docker-compose build --no-cache`

---

📚 **Untuk panduan lengkap, baca:** [DOCKER_GUIDE.md](./DOCKER_GUIDE.md)
