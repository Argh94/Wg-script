#!/data/data/com.termux/files/usr/bin/bash

# Define colors
RED="\e[31m"
GREEN="\e[32m"
CYAN="\e[36m"
YELLOW="\e[33m"
RESET="\e[0m"

# Clear screen
clear

# Display banner
echo -e "${CYAN}===========================================${RESET}"
echo -e "${CYAN}|        Argh94 WARP Config Installer      |${RESET}"
echo -e "${CYAN}| GitHub: https://github.com/Argh94        |${RESET}"
echo -e "${CYAN}===========================================${RESET}"
echo -e "${CYAN}| Date: $(date '+%Y-%m-%d %H:%M:%S')      |${RESET}"
echo ""

# Warn about downloading code
echo -e "${YELLOW}Warning: This script downloads code from GitHub. Ensure you trust the source.${RESET}"
sleep 2

# Check internet connection
echo -e "${CYAN}Checking internet connection...${RESET}"
if ! ping -c 1 1.1.1.1 >/dev/null 2>&1; then
    echo -e "${RED}Error: No internet connection. Please check your network and try again.${RESET}"
    exit 1
fi

# Update and install required packages
pkg_install() {
    echo -e "${CYAN}Updating Termux and installing required packages...${RESET}"
    pkg update -y && pkg install curl -y
    if ! command -v curl >/dev/null 2>&1; then
        echo -e "${RED}Error: Failed to install curl. Please try again.${RESET}"
        exit 1
    fi
}

# Check and install curl if not present
if ! command -v curl >/dev/null 2>&1; then
    pkg_install
fi

# Check disk space
echo -e "${CYAN}Checking disk space...${RESET}"
if [ $(df -k ~ | awk 'NR==2 {print $4}') -lt 1000 ]; then
    echo -e "${RED}Error: Low disk space. Please free up at least 1MB and try again.${RESET}"
    exit 1
fi

# URL encode function
urlencode() {
    local string="$1"
    local encoded=""
    local i
    for ((i=0; i<${#string}; i++)); do
        local c="${string:$i:1}"
        case "$c" in
            [a-zA-Z0-9.~_-]) encoded+="$c" ;;
            *) printf -v hex '%%%02X' "'$c"; encoded+="$hex" ;;
        esac
    done
    echo "$encoded"
}

# Install script permanently
install_script() {
    echo -e "${CYAN}Installing script permanently...${RESET}"
    mkdir -p ~/.argh94
    rm -f ~/.argh94/argh94_warp.sh
    if curl -fsSL https://raw.githubusercontent.com/Argh94/Wg-script/main/Wg.sh -o ~/.argh94/argh94_warp.sh; then
        chmod +x ~/.argh94/argh94_warp.sh
        # Ensure .bashrc exists
        touch ~/.bashrc
        # Remove old alias
        sed -i '/alias Arg=/d' ~/.bashrc
        echo "alias Arg='bash ~/.argh94/argh94_warp.sh'" >> ~/.bashrc
        # Ensure .bash_profile sources .bashrc
        touch ~/.bash_profile
        if ! grep -q "source ~/.bashrc" ~/.bash_profile; then
            echo "source ~/.bashrc" >> ~/.bash_profile
        fi
        # Set restrictive permissions
        chmod 600 ~/.argh94/argh94_warp.sh
        # Reload .bashrc
        if source ~/.bashrc 2>/dev/null; then
            echo -e "${GREEN}Script installed successfully! You can run it by typing 'Arg'.${RESET}"
        else
            echo -e "${YELLOW}Warning: Could not reload .bashrc. Please run 'source ~/.bashrc' or restart Termux.${RESET}"
        fi
        # Verify alias
        if alias Arg >/dev/null 2>&1; then
            echo -e "${GREEN}Alias 'Arg' is now active!${RESET}"
        else
            echo -e "${RED}Error: Alias 'Arg' not active. Run 'source ~/.bashrc' or restart Termux.${RESET}"
        fi
    else
        echo -e "${RED}Error: Failed to download script. Check your internet and try again.${RESET}"
        exit 1
    fi
}

# Cleanup temporary files on exit
trap 'rm -f /tmp/warp_temp_* raw_response.txt' EXIT

# Install script automatically
install_script

# Get user input for config generation
echo -e "${CYAN}Enter configuration details (press Enter for defaults):${RESET}"
read -p "MTU size (default: 1280): " new_mtu
read -p "Config name (default: Argh94): " new_name

# Validate MTU
if ! [[ "$new_mtu" =~ ^[0-9]+$ ]] || [ "$new_mtu" -lt 576 ] || [ "$new_mtu" -gt 1500 ]; then
    echo -e "${YELLOW}Invalid MTU. Using default: 1280${RESET}"
    new_mtu="1280"
else
    new_mtu=${new_mtu:-"1280"}
fi

# Validate Name
new_name=$(echo "$new_name" | tr -dc 'a-zA-Z0-9_-')
new_name=${new_name:-"Argh94"}

# Fetch IPv4 Endpoint
echo -e "${CYAN}Fetching IPv4 Endpoint...${RESET}"
tmpfile=$(mktemp /tmp/warp_temp_XXXXXX)
( echo "1" | bash <(curl -fsSL https://raw.githubusercontent.com/Kolandone/Selector/main/Sel.sh) > "$tmpfile" 2>/dev/null ) &
pid=$!
while kill -0 $pid 2>/dev/null; do
    echo -n "."
    sleep 0.2
done
echo ""
raw_output=$(cat "$tmpfile")
rm -f "$tmpfile"
fetched_ip=$(echo "$raw_output" | grep -oP '(\d{1,3}\.){3}\d{1,3}:\d+' | head -n 1)

if [ -z "$fetched_ip" ]; then
    echo -e "${RED}Failed to fetch IPv4 Endpoint. Trying IPv6...${RESET}"
    # Fetch IPv6 Endpoint as fallback
    tmpfile=$(mktemp /tmp/warp_temp_XXXXXX)
    ( echo "2" | bash <(curl -fsSL https://raw.githubusercontent.com/Kolandone/Selector/main/Sel.sh) > "$tmpfile" 2>/dev/null ) &
    pid=$!
    while kill -0 $pid 2>/dev/null; do
        echo -n "."
        sleep 0.2
    done
    echo ""
    raw_output=$(cat "$tmpfile")
    rm -f "$tmpfile"
    fetched_ip=$(echo "$raw_output" | grep -oP '\[\s*[a-fA-F\d:]+\s*\]:\d+\s*\|\s*\d+' | awk '{print $1 " " $3}' | sort -k2 -n | head -n 1 | awk '{print $1}')
fi

if [ -z "$fetched_ip" ]; then
    echo -e "${RED}Failed to fetch any valid Endpoint. Please try again later.${RESET}"
    exit 1
else
    endpoint="$fetched_ip"
    echo -e "${GREEN}Fetched endpoint: $endpoint${RESET}"
fi

# Generate Warp account
echo -e "${CYAN}Generating Warp account...${RESET}"
response=$(curl -s "https://fscarmen.cloudflare.now.cc/doGenerate")

# Save raw response
echo "$response" > raw_response.txt
echo -e "${CYAN}Raw API response saved to raw_response.txt${RESET}"

# Check if response is empty
if [[ -z "$response" ]]; then
    echo -e "${RED}Error: Empty response from API. Please try again later.${RESET}"
    exit 1
fi

# Extract fields
private_key=$(echo "$response" | grep "PrivateKey" | awk -F '= ' '{print $2}' | head -n 1)
address_ipv4=$(echo "$response" | grep "Address" | awk -F '= ' '{print $2}' | head -n 1)
address_ipv6=$(echo "$response" | grep "Address" | awk -F '= ' '{print $2}' | tail -n 1)
public_key=$(echo "$response" | grep "PublicKey" | awk -F '= ' '{print $2}' | head -n 1)
reserved=$(echo "$response" | grep "Reserved" | awk -F '= ' '{print $2}' | head -n 1 | tr -d '[] ' | sed 's/[^0-9,]*//g')

# Validate extracted fields
if [[ -z "$private_key" || -z "$public_key" || -z "$reserved" ]]; then
    echo -e "${RED}Error: Failed to extract required fields. Check raw_response.txt.${RESET}"
    exit 1
fi

# Validate reserved field
if ! echo "$reserved" | grep -qE '^[0-9]+,[0-9]+,[0-9]+$'; then
    echo -e "${RED}Error: Invalid reserved format ('$reserved'). Expected 'x,y,z'. Check raw_response.txt.${RESET}"
    exit 1
fi

# Display WireGuard configuration
echo -e "\n${GREEN}🔒 WireGuard Config 🔒${RESET}"
cat << EOF
[Interface]
PrivateKey = $private_key
Address = $address_ipv4/32, $address_ipv6/128
DNS = 1.1.1.1, 1.0.0.1, 2606:4700:4700::1111, 2606:4700:4700::1001
MTU = $new_mtu
[Peer]
PublicKey = $public_key
AllowedIPs = 0.0.0.0/0, ::/0
Endpoint = $endpoint
Reserved = $reserved
EOF

# Generate WireGuard URL
reserved_encoded=$(urlencode "$reserved")
private_key_encoded=$(urlencode "$private_key")
public_key_encoded=$(urlencode "$public_key")
address_encoded=$(urlencode "$address_ipv4/32,$address_ipv6/128")
wg_url="wireguard://$private_key_encoded@$endpoint?address=$address_encoded&reserved=$reserved_encoded&publickey=$public_key_encoded&mtu=$new_mtu#$new_name"

# Display WireGuard URL
echo -e "\n${CYAN}=================================================${RESET}"
echo -e "${CYAN}| ${GREEN}🔑 WireGuard URL ${RESET}${CYAN}|${RESET}"
echo -e "${CYAN}| ${YELLOW}$wg_url${RESET}"
echo -e "${CYAN}=================================================${RESET}"

# Save configuration
output_dir="$HOME/.argh94/output"
mkdir -p "$output_dir"
output_file="$output_dir/warp_config_$(date +%F_%H-%M-%S).conf"
cat << EOF > "$output_file"
[Interface]
PrivateKey = $private_key
Address = $address_ipv4/32, $address_ipv6/128
DNS = 1.1.1.1, 1.0.0.1, 2606:4700:4700::1111, 2606:4700:4700::1001
MTU = $new_mtu
[Peer]
PublicKey = $public_key
AllowedIPs = 0.0.0.0/0, ::/0
Endpoint = $endpoint
Reserved = $reserved

WireGuard URL:
$wg_url
EOF
chmod 600 "$output_file"
echo -e "${GREEN}Configuration saved to $output_file${RESET}"
echo -e "${CYAN}To use: Copy the config to WireGuard app or scan the URL. Run 'Arg' to generate new configs.${RESET}"
