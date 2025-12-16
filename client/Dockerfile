# === TAHAP 1: Build aplikasi React ===
# Menggunakan Node.js versi 20 sebagai base image
FROM node:20-alpine AS builder

# Set direktori kerja di dalam container
WORKDIR /app

# Copy file package.json dan package-lock.json (atau bun.lock)
# Ini dilakukan terpisah untuk memanfaatkan Docker layer caching
COPY package*.json ./
COPY bun.lock ./

# Install dependencies
RUN npm install

# Copy seluruh source code aplikasi
COPY . .

# Build aplikasi React untuk production
RUN npm run build

# === TAHAP 2: Setup server Nginx untuk serve aplikasi ===
# Menggunakan Nginx Alpine untuk ukuran image yang lebih kecil
FROM nginx:alpine

# Copy hasil build dari tahap builder
COPY --from=builder /app/dist /usr/share/nginx/html

# Copy custom nginx config untuk React Router dan API proxy
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Nginx akan otomatis berjalan ketika container dimulai
CMD ["nginx", "-g", "daemon off;"]
