# 🐳 Docker Cheatsheet untuk Pemula

Referensi cepat perintah Docker yang paling sering digunakan.

---

## 📦 Docker Compose Commands

### Menjalankan Aplikasi
```bash
# Start semua services (foreground)
docker-compose up

# Start semua services (background/detached)
docker-compose up -d

# Build dan start
docker-compose up --build

# Build tanpa cache (fresh build)
docker-compose up --build --no-cache

# Start service tertentu
docker-compose up server
```

### Menghentikan Aplikasi
```bash
# Stop dan remove containers
docker-compose down

# Stop, remove containers + volumes (HAPUS DATA!)
docker-compose down -v

# Stop tanpa remove
docker-compose stop

# Start yang sudah stop
docker-compose start
```

### Restart Services
```bash
# Restart semua
docker-compose restart

# Restart service tertentu
docker-compose restart server
```

### Build Commands
```bash
# Build semua images
docker-compose build

# Build service tertentu
docker-compose build client

# Build tanpa cache
docker-compose build --no-cache
```

---

## 📊 Monitoring & Logs

### Melihat Logs
```bash
# Logs semua services
docker-compose logs

# Logs dengan follow (real-time)
docker-compose logs -f

# Logs service tertentu
docker-compose logs server
docker-compose logs -f db

# Logs 100 baris terakhir
docker-compose logs --tail=100

# Logs dengan timestamp
docker-compose logs -t
```

### Status & Info
```bash
# Status semua containers
docker-compose ps

# Status detail
docker-compose ps -a

# Lihat resource usage (CPU, Memory)
docker stats

# Lihat running containers
docker ps

# Lihat semua containers (termasuk stopped)
docker ps -a
```

---

## 🔧 Container Management

### Execute Commands di Container
```bash
# Masuk ke shell container
docker exec -it fundamental-server sh
docker exec -it fundamental-client sh

# Execute command tanpa masuk
docker exec fundamental-server ls -la
docker exec fundamental-server npm --version

# Masuk ke MySQL shell
docker exec -it fundamental-db mysql -u dbuser -p
```

### Container Lifecycle
```bash
# Stop container
docker stop fundamental-server

# Start container
docker start fundamental-server

# Restart container
docker restart fundamental-server

# Remove container
docker rm fundamental-server

# Remove container (force, meskipun running)
docker rm -f fundamental-server
```

### Inspect & Debug
```bash
# Inspect container (detail info)
docker inspect fundamental-server

# Lihat processes dalam container
docker top fundamental-server

# Lihat changes dalam filesystem
docker diff fundamental-server

# Copy file dari/ke container
docker cp fundamental-server:/app/package.json ./
docker cp ./test.txt fundamental-server:/app/
```

---

## 🖼️ Image Management

### List Images
```bash
# List semua images
docker images

# List dengan filter
docker images fundamental*
```

### Build Images
```bash
# Build dari Dockerfile (di current directory)
docker build -t my-app .

# Build dengan tag versi
docker build -t my-app:1.0 .

# Build tanpa cache
docker build --no-cache -t my-app .

# Build dengan custom Dockerfile
docker build -f Dockerfile.prod -t my-app .
```

### Remove Images
```bash
# Remove image
docker rmi fundamental-server

# Remove image (force)
docker rmi -f fundamental-server

# Remove unused images
docker image prune

# Remove all unused images
docker image prune -a
```

### Pull & Push (Docker Hub)
```bash
# Pull image dari Docker Hub
docker pull mysql:8
docker pull node:20-alpine

# Push image ke Docker Hub (perlu login dulu)
docker login
docker tag my-app username/my-app:latest
docker push username/my-app:latest
```

---

## 🌐 Network Management

### List Networks
```bash
# List semua networks
docker network ls

# Inspect network
docker network inspect app-network
```

### Create & Remove Networks
```bash
# Create network
docker network create my-network

# Remove network
docker network rm my-network

# Remove unused networks
docker network prune
```

### Connect Container ke Network
```bash
# Connect container ke network
docker network connect app-network my-container

# Disconnect
docker network disconnect app-network my-container
```

---

## 💾 Volume Management

### List Volumes
```bash
# List semua volumes
docker volume ls

# Inspect volume
docker volume inspect mysql_data
```

### Create & Remove Volumes
```bash
# Create volume
docker volume create my-volume

# Remove volume
docker volume rm mysql_data

# Remove unused volumes
docker volume prune

# Remove all unused volumes
docker volume prune -a
```

### Backup & Restore Volume
```bash
# Backup volume ke tar file
docker run --rm -v mysql_data:/data -v $(pwd):/backup alpine tar czf /backup/mysql_backup.tar.gz -C /data .

# Restore dari tar file
docker run --rm -v mysql_data:/data -v $(pwd):/backup alpine tar xzf /backup/mysql_backup.tar.gz -C /data
```

---

## 🧹 Cleanup Commands

### Hapus Resources yang Tidak Digunakan
```bash
# Hapus stopped containers
docker container prune

# Hapus unused images
docker image prune

# Hapus unused volumes
docker volume prune

# Hapus unused networks
docker network prune

# Hapus SEMUA yang tidak digunakan (all-in-one)
docker system prune

# Hapus SEMUA termasuk volumes
docker system prune -a --volumes
```

### Lihat Disk Usage
```bash
# Lihat berapa space yang digunakan Docker
docker system df

# Detail disk usage
docker system df -v
```

---

## 🔍 Search & Info

### Search Images di Docker Hub
```bash
# Search image
docker search mysql
docker search node
```

### System Info
```bash
# Info Docker system
docker info

# Version
docker --version
docker-compose --version
```

---

## 🛡️ Security

### Scan Image untuk Vulnerabilities
```bash
# Scan image (perlu Docker Desktop)
docker scan fundamental-server
```

### Run as Specific User
```bash
# Run container sebagai user tertentu (bukan root)
docker run --user 1000:1000 my-app
```

---

## 🚀 Advanced Tips

### Run dengan Resource Limits
```bash
# Limit CPU dan memory
docker run -d \
  --cpus="0.5" \
  --memory="512m" \
  --name my-server \
  fundamental-server
```

### Environment Variables
```bash
# Set env variable saat run
docker run -e NODE_ENV=production my-app

# Load dari file
docker run --env-file .env my-app
```

### Port Mapping
```bash
# Map port host:container
docker run -p 3000:3000 my-app
docker run -p 8080:80 my-app

# Map ke random port
docker run -P my-app
```

### Volume Mounting
```bash
# Mount folder lokal ke container
docker run -v $(pwd):/app my-app

# Mount named volume
docker run -v my-data:/data my-app

# Read-only mount
docker run -v $(pwd):/app:ro my-app
```

---

## 📝 Docker Compose Specific

### Scale Services
```bash
# Jalankan 3 instance server
docker-compose up --scale server=3
```

### Exec di Service
```bash
# Run command di service
docker-compose exec server npm install express

# Run sebagai user tertentu
docker-compose exec --user root server sh
```

### Config Validation
```bash
# Validate docker-compose.yml
docker-compose config

# Validate dan tampilkan resolved config
docker-compose config --resolve-image-digests
```

---

## 🎯 Project-Specific Commands

### Untuk Project Ini (Fundamental Docker)

```bash
# Full rebuild
docker-compose down -v && docker-compose up --build

# Reset database
docker-compose down -v && docker-compose up db

# Update dependencies
docker-compose exec server npm install <package>
docker-compose restart server

# Access MySQL CLI
docker exec -it fundamental-db mysql -u dbuser -p

# View server logs in real-time
docker-compose logs -f server

# Run helper script
./docker-helper.sh
```

---

## 🆘 Troubleshooting Commands

### Container Won't Start
```bash
# Lihat logs error
docker-compose logs server

# Inspect container state
docker inspect fundamental-server

# Check health
docker inspect --format='{{.State.Health.Status}}' fundamental-db
```

### Port Already in Use
```bash
# Lihat process yang pakai port
lsof -i :3000
netstat -tlnp | grep 3000

# Kill process
kill -9 <PID>
```

### Container Running but Not Accessible
```bash
# Check port mapping
docker port fundamental-server

# Check network
docker network inspect app-network

# Test koneksi dari dalam container
docker exec fundamental-server curl localhost:3000
```

### Out of Disk Space
```bash
# Clean up
docker system prune -a --volumes

# Check disk usage
docker system df
```

---

## 💡 Pro Tips

1. **Gunakan `.dockerignore`** untuk build lebih cepat
2. **Multi-stage builds** untuk image lebih kecil
3. **Named volumes** untuk data persistence
4. **Health checks** untuk dependency management
5. **docker-compose.override.yml** untuk dev settings
6. **`.env` files** untuk manage environment variables
7. **docker stats** untuk monitor resource usage
8. **docker logs -f** untuk debug real-time

---

## 📚 Useful Flags

| Flag | Fungsi |
|------|--------|
| `-d` | Detached mode (background) |
| `-f` | Follow logs / Force |
| `-i` | Interactive |
| `-t` | Allocate pseudo-TTY |
| `-v` | Verbose / Volume |
| `-p` | Port mapping |
| `-e` | Environment variable |
| `--rm` | Remove container setelah exit |
| `--name` | Kasih nama container |

---

## 🎓 Quick Reference

**Container = Running instance**
**Image = Blueprint/Template**
**Volume = Persistent storage**
**Network = Communication layer**

```bash
# The Holy Trinity
docker-compose up --build    # Start everything
docker-compose logs -f       # Watch what happens
docker-compose down         # Stop everything
```

---

**Bookmark page ini untuk referensi cepat! 🔖**
