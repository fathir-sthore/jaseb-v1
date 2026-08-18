#!/data/data/com.termux/files/usr/bin/bash
# auto_ganti.sh - Ganti password VPS giveaway di Termux

# Warna keren untuk Termux
BOLD='\033[1m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# Banner
clear
echo -e "${CYAN}${BOLD}╔════════════════════════════════════╗${NC}"
echo -e "${CYAN}${BOLD}║    AUTO GANTI PASSWORD VPS         ║${NC}"
echo -e "${CYAN}${BOLD}║       FOR TERMUX GIVEAWAY          ║${NC}"
echo -e "${CYAN}${BOLD}╚════════════════════════════════════╝${NC}"
echo ""

# Fungsi generate password
generate_pass() {
    local chars='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789#@!_-'
    local pass="FS_Vps#"
    for i in {1..10}; do
        pass+=${chars:RANDOM%${#chars}:1}
    done
    echo "$pass"
}

# Input data
echo -e "${YELLOW}📝 Masukkan Data VPS:${NC}"
echo ""
read -p "$(echo -e ${GREEN}🌐 IP VPS: ${NC})" IP
read -p "$(echo -e ${GREEN}🔌 Port SSH: ${NC})" PORT
read -s -p "$(echo -e ${GREEN}🔑 Password Sekarang: ${NC})" OLD_PASS
echo ""
echo ""

# Generate password baru
NEW_PASS=$(generate_pass)

echo -e "${BLUE}⏳ Mengganti password...${NC}"
sleep 1

# Cek sshpass
if ! command -v sshpass &> /dev/null; then
    echo -e "${YELLOW}⚠️  sshpass belum terinstall!${NC}"
    echo -e "${BLUE}📦 Menginstall sshpass...${NC}"
    pkg install openssh sshpass -y
    echo ""
fi

# Eksekusi ganti password
sshpass -p "$OLD_PASS" ssh -p $PORT -o StrictHostKeyChecking=no root@$IP "
echo 'root:$NEW_PASS' | chpasswd
echo '✅ Password berhasil diganti!'
history -c
exit
" 2>/dev/null

# Cek hasil
if [ $? -eq 0 ]; then
    clear
    echo -e "${GREEN}${BOLD}╔════════════════════════════════════╗${NC}"
    echo -e "${GREEN}${BOLD}║       ✅  SUKSES!                 ║${NC}"
    echo -e "${GREEN}${BOLD}╚════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}🔑 PASSWORD BARU:${NC}"
    echo -e "${PURPLE}${BOLD}$NEW_PASS${NC}"
    echo ""
    echo -e "${RED}⚠️  SIMPAN PASSWORD INI!${NC}"
    echo -e "${RED}⚠️  Password hanya muncul SEKALI${NC}"
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}📋 Login dengan password baru:${NC}"
    echo -e "${WHITE}ssh -p $PORT root@$IP${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    # Simpan ke file
    echo "$(date) - $IP:$PORT - $NEW_PASS" >> ~/vps_password_history.txt
    echo -e "${BLUE}💾 Password disimpan di: ~/vps_password_history.txt${NC}"
else
    echo -e "${RED}❌ GAGAL! Cek:${NC}"
    echo -e "  • Password benar?"
    echo -e "  • Koneksi internet?"
    echo -e "  • IP/Port benar?"
fi

echo ""
read -p "Tekan Enter untuk keluar..."
