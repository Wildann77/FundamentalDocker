# 🐳 Panduan Docker untuk Pemula

Panduan lengkap untuk menjalankan aplikasi Full Stack (React + Express + MySQL) menggunakan Docker.

---

## 📚 Apa itu Docker?

**Docker** adalah platform yang memungkinkan Anda membungkus aplikasi beserta semua dependensinya ke dalam sebuah "container". Container ini bisa berjalan di mana saja dengan cara yang sama, tidak peduli sistem operasi apa yang Anda gunakan.

### Konsep Dasar:

1. **Image**: Blueprint/template untuk membuat container (seperti resep makanan)
2. **Container**: Instance yang berjalan dari sebuah image (seperti makanan yang sudah jadi)
3. **Dockerfile**: File instruksi untuk membuat image
4. **Docker Compose**: Tool untuk menjalankan multiple containers sekaligus

---

## 🏗️ Struktur Project

```
FundamentalDocker/
├── client/                  # Frontend React
│   ├── Dockerfile          # Instruksi build untuk client
│   ├── .dockerignore       # File yang diabaikan saat build
│   └── src/                # Source code React
├── server/                  # Backend Express
│   ├── Dockerfile          # Instruksi build untuk server
│   ├── .dockerignore       # File yang diabaikan saat build
│   └── index.js            # Entry point server
├── docker-compose.yml       # Orchestration untuk semua services
└── .dockerignore           # Root dockerignore
```

---

## 🚀 Cara Menjalankan Aplikasi

### Prasyarat
Pastikan Docker dan Docker Compose sudah terinstall:
```bash
docker --version
docker-compose --version
```

### 1️⃣ Jalankan Semua Service

Dari root folder project, jalankan:

```bash
# Build dan jalankan semua container
docker-compose up --build
```

**Penjelasan:**
- `docker-compose up`: Menjalankan semua service yang didefinisikan di docker-compose.yml
- `--build`: Membangun ulang image sebelum menjalankan (penting saat pertama kali atau ada perubahan code)

### 2️⃣ Akses Aplikasi

Setelah semua container berjalan:
- **Frontend (React)**: http://localhost:8080
- **Backend (API)**: http://localhost:3000
- **Database (MySQL)**: localhost:3306

### 3️⃣ Hentikan Aplikasi

```bash
# Hentikan dan hapus container (data MySQL tetap tersimpan)
docker-compose down

# Hentikan, hapus container DAN hapus volume (hapus semua data)
docker-compose down -v
```

---

## 🔧 Perintah Docker yang Berguna

### Melihat Container yang Berjalan
```bash
docker ps
```

### Melihat Semua Container (termasuk yang sudah stop)
```bash
docker ps -a
```

### Melihat Logs

```bash
# Logs semua service
docker-compose logs

# Logs service tertentu
docker-compose logs server
docker-compose logs client
docker-compose logs db

# Follow logs (real-time)
docker-compose logs -f server
```

### Masuk ke Dalam Container

```bash
# Masuk ke container server
docker exec -it fundamental-server sh

# Masuk ke container database
docker exec -it fundamental-db mysql -u dbuser -p
# Password: dbpassword
```

### Restart Service Tertentu

```bash
# Restart hanya server
docker-compose restart server

# Restart semua
docker-compose restart
```

### Rebuild Service Tertentu

```bash
# Rebuild hanya client
docker-compose up --build client

# Rebuild hanya server
docker-compose up --build server
```

---

## 🔍 Memahami docker-compose.yml

File `docker-compose.yml` mendefinisikan 3 service:

### 1. Database (db)
```yaml
db:
  image: mysql:8              # Menggunakan MySQL 8
  ports:
    - "3306:3306"             # Port mapping
  environment:                # Konfigurasi MySQL
    MYSQL_DATABASE: ...
    MYSQL_USER: ...
  volumes:
    - mysql_data:/var/lib/mysql  # Persistent data
```

**Penting:** Data MySQL disimpan di volume `mysql_data`, jadi tidak hilang meski container dihapus.

### 2. Server (server)
```yaml
server:
  build:
    context: ./server         # Build dari folder server
  depends_on:
    db:
      condition: service_healthy  # Tunggu db siap
  environment:
    DB_HOST: db               # Gunakan nama service sebagai hostname
```

**Penting:** `DB_HOST: db` berarti server terhubung ke database menggunakan nama service "db", bukan "localhost".

### 3. Client (client)
```yaml
client:
  build:
    context: ./client         # Build dari folder client
  ports:
    - "8080:80"               # Nginx serve di port 80, di-expose ke 8080
  depends_on:
    - server                  # Tunggu server siap
```

---

## 📝 Memahami Dockerfile

### Client Dockerfile (Multi-stage Build)

```dockerfile
# STAGE 1: Build aplikasi
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# STAGE 2: Serve dengan Nginx
FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
EXPOSE 80
```

**Keuntungan Multi-stage:**
- Image akhir lebih kecil (hanya berisi hasil build, tidak termasuk source code & dev dependencies)
- Lebih aman (tidak ada source code di production)

### Server Dockerfile

```dockerfile
FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install --production    # Hanya production dependencies
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
```

---

## 🛠️ Troubleshooting

### Problem: Port sudah digunakan
```
Error: Bind for 0.0.0.0:3000 failed: port is already allocated
```

**Solusi:** Ubah port di docker-compose.yml
```yaml
ports:
  - "3001:3000"  # Gunakan port 3001 di host
```

### Problem: Database connection failed
```
Error: connect ECONNREFUSED
```

**Solusi:**
1. Pastikan `DB_HOST` di environment server adalah `db` (bukan `localhost`)
2. Cek healthcheck database sudah pass
3. Lihat logs database: `docker-compose logs db`

### Problem: Container crash terus
```bash
# Lihat logs untuk error
docker-compose logs server

# Lihat mengapa container exit
docker ps -a
```

### Problem: Perubahan code tidak terdeteksi
```bash
# Rebuild dengan flag --no-cache
docker-compose build --no-cache
docker-compose up
```

---

## 🎯 Tips untuk Development

### Mode Development dengan Hot Reload

Edit `docker-compose.yml`, uncomment bagian volumes di service server:

```yaml
server:
  # ... konfigurasi lain ...
  volumes:
    - ./server:/app           # Sync code lokal ke container
    - /app/node_modules       # Jangan timpa node_modules
  command: npm run dev        # Gunakan nodemon
```

Dengan ini, setiap perubahan di folder `server` akan langsung terdeteksi tanpa rebuild.

### Menggunakan .env File

Buat file `.env` di root project:

```env
# Database
MYSQL_ROOT_PASSWORD=rootpassword
MYSQL_DATABASE=fundamental_docker
MYSQL_USER=dbuser
MYSQL_PASSWORD=dbpassword

# Server
NODE_ENV=production
DB_HOST=db
```

Lalu di docker-compose.yml, gunakan `env_file`:

```yaml
server:
  env_file:
    - .env
```

---

## 🧹 Membersihkan Docker

```bash
# Hapus semua stopped containers
docker container prune

# Hapus semua unused images
docker image prune

# Hapus semua unused volumes
docker volume prune

# Hapus SEMUA yang tidak digunakan (hati-hati!)
docker system prune -a
```

---

## 📖 Sumber Belajar Lanjutan

1. **Docker Documentation**: https://docs.docker.com/
2. **Docker Compose Documentation**: https://docs.docker.com/compose/
3. **Best Practices**: https://docs.docker.com/develop/dev-best-practices/

---

## ❓ FAQ

**Q: Apakah data database akan hilang setelah container dihapus?**  
A: Tidak, karena kita menggunakan volume `mysql_data`. Data akan tetap ada kecuali Anda jalankan `docker-compose down -v`.

**Q: Bagaimana cara update dependencies (npm install package baru)?**  
A: Setelah install package di lokal, rebuild container: `docker-compose build server` atau `docker-compose build client`.

**Q: Apakah bisa menjalankan satu service saja?**  
A: Bisa! Misalnya hanya database: `docker-compose up db`.

**Q: Bagaimana cara mengakses database dari tools seperti MySQL Workbench?**  
A: Gunakan koneksi:
- Host: localhost
- Port: 3306
- User: dbuser
- Password: dbpassword

---

## 🎓 Kesimpulan

Anda sekarang sudah punya setup Docker yang lengkap untuk development dan production! 

**Workflow normal:**
1. `docker-compose up --build` → Jalankan semua
2. Akses http://localhost:8080 → Lihat aplikasi
3. Edit code → Rebuild jika perlu
4. `docker-compose down` → Hentikan

Selamat belajar Docker! 🚀
