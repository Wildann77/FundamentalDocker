#!/bin/bash

# 🐳 Docker Helper Script untuk Pemula
# Script ini membantu menjalankan perintah Docker dengan mudah

echo "==================================="
echo "🐳 Docker Helper - Fundamental Docker"
echo "==================================="
echo ""

# Fungsi untuk menampilkan menu
show_menu() {
    echo "Pilih aksi yang ingin dilakukan:"
    echo ""
    echo "1) 🚀 Jalankan aplikasi (docker-compose up)"
    echo "2) 🔨 Build dan jalankan aplikasi (docker-compose up --build)"
    echo "3) 🛑 Hentikan aplikasi (docker-compose down)"
    echo "4) 🗑️  Hentikan dan hapus semua data (docker-compose down -v)"
    echo "5) 📊 Lihat status containers"
    echo "6) 📝 Lihat logs semua services"
    echo "7) 📝 Lihat logs server"
    echo "8) 📝 Lihat logs client"
    echo "9) 📝 Lihat logs database"
    echo "10) 🔄 Restart semua services"
    echo "11) 💻 Masuk ke container server"
    echo "12) 💾 Masuk ke MySQL shell"
    echo "13) 🧹 Bersihkan Docker (hapus unused images/containers)"
    echo "14) ℹ️  Info Docker (version, disk usage)"
    echo "0) ❌ Keluar"
    echo ""
    echo -n "Masukkan pilihan [0-14]: "
}

# Loop menu
while true; do
    show_menu
    read choice
    echo ""
    
    case $choice in
        1)
            echo "🚀 Menjalankan aplikasi..."
            docker-compose up
            ;;
        2)
            echo "🔨 Building dan menjalankan aplikasi..."
            docker-compose up --build
            ;;
        3)
            echo "🛑 Menghentikan aplikasi..."
            docker-compose down
            echo "✅ Aplikasi dihentikan!"
            ;;
        4)
            echo "⚠️  PERINGATAN: Ini akan menghapus semua data database!"
            echo -n "Apakah Anda yakin? (y/n): "
            read confirm
            if [ "$confirm" = "y" ] || [ "$confirm" = "Y" ]; then
                docker-compose down -v
                echo "✅ Aplikasi dihentikan dan semua data dihapus!"
            else
                echo "❌ Dibatalkan"
            fi
            ;;
        5)
            echo "📊 Status containers:"
            docker-compose ps
            ;;
        6)
            echo "📝 Logs semua services (Ctrl+C untuk keluar):"
            docker-compose logs -f
            ;;
        7)
            echo "📝 Logs server (Ctrl+C untuk keluar):"
            docker-compose logs -f server
            ;;
        8)
            echo "📝 Logs client (Ctrl+C untuk keluar):"
            docker-compose logs -f client
            ;;
        9)
            echo "📝 Logs database (Ctrl+C untuk keluar):"
            docker-compose logs -f db
            ;;
        10)
            echo "🔄 Merestart semua services..."
            docker-compose restart
            echo "✅ Services di-restart!"
            ;;
        11)
            echo "💻 Masuk ke container server (ketik 'exit' untuk keluar):"
            docker exec -it fundamental-server sh
            ;;
        12)
            echo "💾 Masuk ke MySQL shell (password: dbpassword, ketik 'exit' untuk keluar):"
            docker exec -it fundamental-db mysql -u dbuser -p
            ;;
        13)
            echo "🧹 Membersihkan Docker..."
            echo "Menghapus stopped containers..."
            docker container prune -f
            echo "Menghapus unused images..."
            docker image prune -f
            echo "Menghapus unused networks..."
            docker network prune -f
            echo "✅ Docker dibersihkan!"
            ;;
        14)
            echo "ℹ️  Docker Version:"
            docker --version
            docker-compose --version
            echo ""
            echo "📊 Docker Disk Usage:"
            docker system df
            ;;
        0)
            echo "👋 Terima kasih! Sampai jumpa!"
            exit 0
            ;;
        *)
            echo "❌ Pilihan tidak valid. Silakan pilih 0-14."
            ;;
    esac
    
    echo ""
    echo "-----------------------------------"
    echo ""
done
