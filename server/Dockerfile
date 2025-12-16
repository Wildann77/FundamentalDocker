# Menggunakan Node.js versi 20 sebagai base image
FROM node:20-alpine

# Set direktori kerja di dalam container
WORKDIR /app

# Copy file package.json dan package-lock.json
# Ini dilakukan terpisah untuk memanfaatkan Docker layer caching
COPY package*.json ./

# Install dependencies production only (lebih efisien)
# Gunakan --omit=dev untuk skip devDependencies di production
RUN npm install --production

# Copy seluruh source code aplikasi
COPY . .

# Expose port 3000 (sesuai dengan port di index.js)
EXPOSE 3000

# Jalankan aplikasi menggunakan node
# Gunakan npm start untuk production
CMD ["npm", "start"]
