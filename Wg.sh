#!/data/data/com.termux/files/usr/bin/bash

clear

# Define colors
RED="\e[31m"
BLUE="\e[34m"
GREEN="\e[32m"
CYAN="\e[36m"
YELLOW="\e[33m"
PURPLE="\e[35m"
WHITE="\e[37m"
RESET="\e[0m"

# Display custom banner
echo -e "${CYAN}===========================================${RESET}"
echo -e "${CYAN}|           Argh94 WARP Config        |${RESET}"
echo -e "${CYAN}| GitHub: ${BLUE}https://github.com/Argh94${RESET} |${RESET}"
echo -e "${CYAN}===========================================${RESET}"
echo -e "${CYAN}| Date: $(date '+%Y-%m-%d %H:%M:%S') |${RESET}"
echo ""

# Install required packages
pkg_install() {
    echo -e "${CYAN}Updating package lists and installing required packages...${RESET}"
    pkg update -y && pkg upgrade -y
    pkg install curl bash coreutils grep sed nano -y
    if ! command -v curl >/dev/null 2>&1; then
        echo -e "${RED}Error: Failed to install curl. Please check your internet connection and try again.${RESET}"
        exit 1
    fi
}

# Check and install dependencies
if ! command -v curl >/dev/null 2>&1 || ! command -v bash >/dev/null 2>&1; then
    pkg_install
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
    # Save the current script to ~/.argh94
    cp "$0" ~/.argh94/argh94_warp.sh || {
        echo -e "${RED}Error: Failed to copy script to ~/.argh94/argh94_warp.sh${RESET}"
        exit 1
    }
    chmod +x ~/.argh94/argh94_warp.sh
    # Ensure .bashrc exists
    touch ~/.bashrc
    # Remove old alias
    sed -i '/alias Arg=/d' ~/.bashrc
    # Add new alias
    echo "alias Arg='bash ~/.argh94/argh94_warp.sh'" >> ~/.bashrc
    # Ensure .bash_profile loads .bashrc
    if [ -f ~/.bash_profile ]; then
        if ! grep -q "source ~/.bashrc" ~/.bash_profile; then
            echo "source ~/.bashrc" >> ~/.bash_profile
        fi
    else
        touch ~/.bash_profile
        echo "source ~/.bashrc" >> ~/.bash_profile
    fi
    # Verify installation
    if [ -f ~/.argh94/argh94_warp.sh ] && [ -x ~/.argh94/argh94_warp.sh ]; then
        echo -e "${GREEN}Script installed at ~/.argh94/argh94_warp.sh${RESET}"
        if grep -q "alias Arg=" ~/.bashrc; then
            echo -e "${GREEN}Alias 'Arg' added to ~/.bashrc${RESET}"
        else
            echo -e "${RED}Error: Failed to add alias to ~/.bashrc${RESET}"
            exit 1
        fi
        if source ~/.bashrc 2>/dev/null; then
            echo -e "${GREEN}Script installed successfully! You can now run it by typing 'Arg' in Termux.${RESET}"
        else
            echo -e "${YELLOW}Warning: Could not reload .bashrc automatically. Please run 'source ~/.bashrc' or restart Termux.${RESET}"
        fi
        if alias Arg >/dev/null 2>&1; then
            echo -e "${GREEN}Alias 'Arg' is now active!${RESET}"
        else
            echo -e "${YELLOW}Warning: Alias 'Arg' is not active yet. Please run 'source ~/.bashrc' or restart Termux.${RESET}"
        fi
    else
        echo -e "${RED}Error: Script file is missing or not executable. Please check ~/.argh94/argh94_warp.sh${RESET}"
        exit 1
    fi
}

# Uninstall script
uninstall_script() {
    echo -e "${CYAN}Uninstalling script...${RESET}"
    rm -rf ~/.argh94
    sed -i '/alias Arg=/d' ~/.bashrc
    if source ~/.bashrc 2>/dev/null; then
        echo -e "${GREEN}Script uninstalled successfully. Alias 'Arg' removed.${RESET}"
    else
        echo -e "${YELLOW}Warning: Could not reload .bashrc automatically. Please run 'source ~/.bashrc' or restart Termux.${RESET}"
    fi
    echo -e "${CYAN}If you still see 'Arg' suggestions, restart Termux or check your shell configuration.${RESET}"
}

# Auto-install on first run
if [ ! -f ~/.argh94/argh94_warp.sh ]; then
    install_script
    echo -e "${CYAN}Installation complete! Now you can use 'Arg' to run the script.${RESET}"
fi

# Main menu loop
while true; do
    echo -e "${GREEN}┌──────────────────────────────────┐${RESET}"
    echo -e "${GREEN}│${CYAN}       Select an Option           ${GREEN}│${RESET}"
    echo -e "${GREEN}├──────────────────────────────────┤${RESET}"
    echo -e "${GREEN}│${RESET} 1) WARP IPv4 Endpoint IP         ${GREEN}│${RESET}"
    echo -e "${GREEN}│${RESET} 2) WARP IPv6 Endpoint IP         ${GREEN}│${RESET}"
    echo -e "${GREEN}│${RESET} 3) Generate IPv4 Config          ${GREEN}│${RESET}"
    echo -e "${GREEN}│${RESET} 4) Generate IPv6 Config          ${GREEN}│${RESET}"
    echo -e "${GREEN}│${RESET} 5) Install Script Permanently    ${GREEN}│${RESET}"
    echo -e "${GREEN}│${RESET} 6) Uninstall Script              ${GREEN}│${RESET}"
    echo -e "${GREEN}│${RESET} q) Quit                          ${GREEN}│${RESET}"
    echo -e "${GREEN}└──────────────────────────────────┘${RESET}"
    read -p "Enter your choice: " user_choice

    # Handle menu choices
    case "$user_choice" in
        1)
            echo -e "${CYAN}Fetching WARP IPv4 Endpoint...${RESET}"
            set +m
            tmpfile=$(mktemp)
            ( echo "1" | bash <(curl -fsSL https://raw.githubusercontent.com/Kolandone/Selector/main/Sel.sh) > "$tmpfile" 2>/dev/null ) &
            pid=$!
            disown $pid 2>/dev/null
            while kill -0 $pid 2>/dev/null; do
                echo -n "."
                sleep 0.2
            done
            echo ""
            raw_output=$(cat "$tmpfile")
            rm -f "$tmpfile"
            fetched_ip=$(echo "$raw_output" | grep -oP '(\d{1,3}\.){3}\d{1,3}:\d+' | head -n 1)
            if [ -z "$fetched_ip" ]; then
                echo -e "${RED}Failed to fetch a valid IPv4 Endpoint. Please check your internet connection.${RESET}"
            else
                echo -e "${GREEN}WARP IPv4 Endpoint: $fetched_ip${RESET}"
            fi
            continue
            ;;
        2)
            echo -e "${CYAN}Fetching WARP IPv6 Endpoint...${RESET}"
            set +m
            tmpfile=$(mktemp)
            ( echo "2" | bash <(curl -fsSL https://raw.githubusercontent.com/Kolandone/Selector/main/Sel.sh) > "$tmpfile" 2>/dev/null ) &
            pid=$!
            disown $pid 2>/dev/null
            while kill -0 $pid 2>/dev/null; do
                echo -n "."
                sleep 0.2
            done
            echo ""
            raw_output=$(cat "$tmpfile")
            rm -f "$tmpfile"
            fetched_ip=$(echo "$raw_output" | grep -oP '\[\s*[a-fA-F\d:]+\s*\]:\d+\s*\|\s*\d+' | awk '{print $1 " " $3}' | sort -k2 -n | head -n 1 | awk '{print $1}')
            if [ -z "$fetched_ip" ]; then
                echo -e "${RED}Failed to fetch a valid IPv6 Endpoint. Please check your internet connection.${RESET}"
            else
                echo -e "${GREEN}WARP IPv6 Endpoint: $fetched_ip${RESET}"
            fi
            continue
            ;;
        5)
            install_script
            continue
            ;;
        6)
            uninstall_script
            exit 0
            ;;
        q|Q)
            echo -e "${GREEN}Exiting...${RESET}"
            exit 0
            ;;
        3|4)
            # Break loop to proceed to config generation
            break
            ;;
        *)
            echo -e "${RED}Invalid choice. Please select a valid option.${RESET}"
            continue
            ;;
    esac
done

# Get user input for config generation
read -p "Enter the new MTU size (default is 1280): " new_mtu
read -p "Enter the new name (default is Argh94): " new_name
# Validate MTU
if [ -z "$new_mtu" ]; then
    new_mtu="1280"
elif ! [[ "$new_mtu" =~ ^[0-9]+$ ]] || [ "$new_mtu" -lt 576 ] || [ "$new_mtu" -gt 1500 ]; then
    echo -e "${YELLOW}Warning: MTU must be a number between 576 and 1500. Using default 1280.${RESET}"
    new_mtu="1280"
fi
# Validate Name
if [ -z "$new_name" ]; then
    new_name="Argh94"
else
    new_name=$(echo "$new_name" | tr -dc 'a-zA-Z0-9_-')
    new_name=${new_name:-"Argh94"}
fi

# Fetch IP address
if [ "$user_choice" == "3" ]; then
    echo -e "${CYAN}Fetching IPv4 Endpoint...${RESET}"
    set +m
    tmpfile=$(mktemp)
    ( echo "1" | bash <(curl -fsSL https://raw.githubusercontent.com/Kolandone/Selector/main/Sel.sh) > "$tmpfile" 2>/dev/null ) &
    pid=$!
    disown $pid 2>/dev/null
    while kill -0 $pid 2>/dev/null; do
        echo -n "."
        sleep 0.2
    done
    echo ""
    raw_output=$(cat "$tmpfile")
    rm -f "$tmpfile"
    fetched_ip=$(echo "$raw_output" | grep -oP '(\d{1,3}\.){3}\d{1,3}:\d+' | head -n 1)
elif [ "$user_choice" == "4" ]; then
    echo -e "${CYAN}Fetching IPv6 Endpoint...${RESET}"
    set +m
    tmpfile=$(mktemp)
    ( echo "2" | bash <(curl -fsSL https://raw.githubusercontent.com/Kolandone/Selector/main/Sel.sh) > "$tmpfile" 2>/dev/null ) &
    pid=$!
    disown $pid 2>/dev/null
    while kill -0 $pid 2>/dev/null; do
        echo -n "."
        sleep 0.2
    done
    echo ""
    raw_output=$(cat "$tmpfile")
    rm -f "$tmpfile"
    fetched_ip=$(echo "$raw_output" | grep -oP '\[\s*[a-fA-F\d:]+\s*\]:\d+\s*\|\s*\d+' | awk '{print $1 " " $3}' | sort -k2 -n | head -n 1 | awk '{print $1}')
else
    echo -e "${RED}Error: Invalid choice during config generation. Exiting...${RESET}"
    exit 1
fi

# Check if IP was fetched
if [ -z "$fetched_ip" ]; then
    echo -e "${RED}Failed to fetch a valid IP address. Please check your internet connection.${RESET}"
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
    echo -e "${RED}Error: Empty response from API. Please check your internet connection.${RESET}"
    exit 1
fi

# Extract fields
private_key=$(echo "$response" | grep "PrivateKey" | awk -F '= ' '{print $2}' | head -n 1)
address_ipv4=$(echo "$response" | grep "Address" | awk -F '= ' '{print $2}' | head -n 1)
address_ipv6=$(echo "$response" | grep "Address" | awk -F '= ' '{print $2}' | tail -n 1)
public_key=$(echo "$response" | grep "PublicKey" | awk -F '= ' '{print $2}' | head -n 1)
default_endpoint=$(echo "$response" | grep "Endpoint" | awk -F '= ' '{print $2}' | head -n 1)
reserved=$(echo "$response" | grep "Reserved" | awk -F '= ' '{print $2}' | head -n 1 | tr -d '[] ' | sed 's/[^0-9,]*//g')

# Validate extracted fields
if [[ -z "$private_key" || -z "$public_key" || -z "$default_endpoint" ]]; then
    echo -e "${RED}Error: Failed to extract required fields. Check raw_response.txt for details.${RESET}"
    exit 1
fi

# Validate reserved field
reserved_count=$(echo "$reserved" | grep -o ',' | wc -l)
if [[ "$reserved_count" -ne 2 || -z "$reserved" ]]; then
    echo -e "${RED}Error: Invalid reserved field format ('$reserved'). Expected three comma-separated numbers (e.g., '175,193,58'). Check raw_response.txt.${RESET}"
    exit 1
fi

# Display AmneziaVPN Config
echo -e "\n${GREEN}🎉 AmneziaVPN Config 🎉${RESET}"
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

# Display WireGuard configuration
echo -e "\n${GREEN}🔒 Wireguard Config 🔒${RESET}"
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
EOF

# Display Hiddify JSON Config
echo -e "\n${GREEN}🌍 Hiddify JSON Config 🌍${RESET}"
cat << EOF
{
  "outbounds": [
    {
      "type": "wireguard",
      "tag": "$new_name Warp",
      "local_address": ["$address_ipv4/32", "$address_ipv6/128"],
      "private_key": "$private_key",
      "peer_public_key": "$public_key",
      "server": "${endpoint%:*}",
      "server_port": ${endpoint##*:},
      "reserved": [$reserved],
      "mtu": $new_mtu,
      "fake_packets": "1-3",
      "fake_packets_size": "10-30",
      "fake_packets_delay": "10-30",
      "fake_packets_mode": "m4"
    }
  ]
}
EOF

# Display V2Ray JSON Config
echo -e "\n${GREEN}🚀 V2RayNG JSON Config 🚀${RESET}"
cat << EOF
{
  "dns": {
    "hosts": {
      "geosite:category-porn": "127.0.0.1",
      "domain:googleapis.cn": "googleapis.com"
    },
    "servers": [
      "1.1.1.1"
    ]
  },
  "fakedns": [
    {
      "ipPool": "198.18.0.0/15",
      "poolSize": 10000
    }
  ],
  "inbounds": [
    {
      "listen": "127.0.0.1",
      "port": 10808,
      "protocol": "socks",
      "settings": {
        "auth": "noauth",
        "udp": true,
        "userLevel": 8
      },
      "sniffing": {
        "destOverride": [
          "http",
          "tls",
          "fakedns"
        ],
        "enabled": true
      },
      "tag": "socks"
    },
    {
      "listen": "127.0.0.1",
      "port": 10809,
      "protocol": "http",
      "settings": {
        "userLevel": 8
      },
      "tag": "http"
    }
  ],
  "log": {
    "loglevel": "warning"
  },
  "outbounds": [
    {
      "mux": {
        "concurrency": -1,
        "enabled": false,
        "xudpConcurrency": 8,
        "xudpProxyUDP443": ""
      },
      "protocol": "wireguard",
      "settings": {
        "secretKey": "$private_key",
        "address": [
          "$address_ipv4/32",
          "$address_ipv6/128"
        ],
        "peers": [
          {
            "publicKey": "$public_key",
            "endpoint": "$endpoint",
            "keepAlive": 5
          }
        ],
        "reserved": [$reserved],
        "mtu": $new_mtu,
        "wnoise": "quic",
        "wnoisecount": "15",
        "wnoisedelay": "1-2",
        "wpayloadsize": "5-10"
      },
      "tag": "proxy"
    },
    {
      "protocol": "freedom",
      "settings": {
        "domainStrategy": "UseIP"
      },
      "tag": "direct"
    },
    {
      "protocol": "blackhole",
      "settings": {
        "response": {
          "type": "http"
        }
      },
      "tag": "block"
    }
  ],
  "remarks": "$new_name",
  "routing": {
    "domainStrategy": "IPIfNonMatch",
    "rules": [
      {
        "ip": [
          "1.1.1.1"
        ],
        "outboundTag": "proxy",
        "port": "53",
        "type": "field"
      },
      {
        "domain": [
          "domain:ir",
          "geosite:category-ir",
          "geosite:private"
        ],
        "outboundTag": "direct",
        "type": "field"
      },
      {
        "ip": [
          "geoip:ir",
          "geoip:private"
        ],
        "outboundTag": "direct",
        "type": "field"
      },
      {
        "domain": [
          "geosite:category-porn"
        ],
        "outboundTag": "block",
        "type": "field"
      },
      {
        "ip": [
          "10.10.34.34",
          "10.10.34.35",
          "10.10.34.36"
        ],
        "outboundTag": "block",
        "type": "field"
      }
    ]
  }
}
EOF

# Generate WireGuard URL
reserved_encoded=$(urlencode "$reserved")
private_key_encoded=$(urlencode "$private_key")
public_key_encoded=$(urlencode "$public_key")
address_encoded=$(urlencode "$address_ipv4/32,$address_ipv6/128")
wg_url="wireguard://$private_key_encoded@$endpoint?address=$address_encoded&reserved=$reserved_encoded&publickey=$public_key_encoded&mtu=$new_mtu#$new_name"

# Display WireGuard URL
echo -e "\n${CYAN}=================================================${RESET}"
echo -e "${CYAN}|${RESET} ${GREEN}🔑 WireGuard URL by Argh94${RESET} ${CYAN}|${RESET}"
echo -e "${CYAN}|${RESET} ${YELLOW}$wg_url${RESET}"
echo -e "${CYAN}===================================================${RESET}"

# Save configuration
output_dir="$HOME/.argh94/output"
mkdir -p "$output_dir"
output_file="$output_dir/warp_config_$(date +%F_%H-%M-%S).txt"
{
    echo "🎉 AmneziaVPN Config 🎉"
    echo "[Interface]"
    echo "PrivateKey = $private_key"
    echo "Address = $address_ipv4/32, $address_ipv6/128"
    echo "DNS = 1.1.1.1, 1.0.0.1, 2606:4700:4700::1111, 2606:4700:4700::1001"
    echo "MTU = $new_mtu"
    echo "[Peer]"
    echo "PublicKey = $public_key"
    echo "AllowedIPs = 0.0.0.0/0, ::/0"
    echo "Endpoint = $endpoint"
    echo "Reserved = $reserved"
    echo -e "\n🔒 Wireguard Config 🔒"
    echo "[Interface]"
    echo "PrivateKey = $private_key"
    echo "Address = $address_ipv4/32, $address_ipv6/128"
    echo "DNS = 1.1.1.1, 1.0.0.1, 2606:4700:4700::1111, 2606:4700:4700::1001"
    echo "MTU = $new_mtu"
    echo "[Peer]"
    echo "PublicKey = $public_key"
    echo "AllowedIPs = 0.0.0.0/0, ::/0"
    echo "Endpoint = $endpoint"
    echo -e "\n🌍 Hiddify JSON Config 🌍"
    echo "{"
    echo '  "outbounds": ['
    echo '    {'
    echo '      "type": "wireguard",'
    echo '      "tag": "'$new_name' Warp",'
    echo '      "local_address": ["'$address_ipv4'/32", "'$address_ipv6'/128"],'
    echo '      "private_key": "'$private_key'",'
    echo '      "peer_public_key": "'$public_key'",'
    echo '      "server": "'${endpoint%:*}'",'
    echo '      "server_port": '${endpoint##*:}','
    echo '      "reserved": ['$reserved'],'
    echo '      "mtu": '$new_mtu','
    echo '      "fake_packets": "1-3",'
    echo '      "fake_packets_size": "10-30",'
    echo '      "fake_packets_delay": "10-30",'
    echo '      "fake_packets_mode": "m4"'
    echo '    }'
    echo '  ]'
    echo "}"
    echo -e "\n🚀 V2RayNG JSON Config 🚀"
    echo "{"
    echo '  "dns": {'
    echo '    "hosts": {'
    echo '      "geosite:category-porn": "127.0.0.1",'
    echo '      "domain:googleapis.cn": "googleapis.com"'
    echo '    },'
    echo '    "servers": ["1.1.1.1"]'
    echo '  },'
    echo '  "fakedns": [{"ipPool": "198.18.0.0/15", "poolSize": 10000}],'
    echo '  "inbounds": ['
    echo '    {'
    echo '      "listen": "127.0.0.1", "port": 10808, "protocol": "socks",'
    echo '      "settings": {"auth": "noauth", "udp": true, "userLevel": 8},'
    echo '      "sniffing": {"destOverride": ["http", "tls", "fakedns"], "enabled": true},'
    echo '      "tag": "socks"'
    echo '    },'
    echo '    {'
    echo '      "listen": "127.0.0.1", "port": 10809, "protocol": "http",'
    echo '      "settings": {"userLevel": 8},'
    echo '      "tag": "http"'
    echo '    }'
    echo '  ],'
    echo '  "log": {"loglevel": "warning"},'
    echo '  "outbounds": ['
    echo '    {'
    echo '      "mux": {"concurrency": -1, "enabled": false, "xudpConcurrency": 8, "xudpProxyUDP443": ""},'
    echo '      "protocol": "wireguard",'
    echo '      "settings": {'
    echo '        "secretKey": "'$private_key'",'
    echo '        "address": ["'$address_ipv4'/32", "'$address_ipv6'/128"],'
    echo '        "peers": [{"publicKey": "'$public_key'", "endpoint": "'$endpoint'", "keepAlive": 5}],'
    echo '        "reserved": ['$reserved'],'
    echo '        "mtu": '$new_mtu','
    echo '        "wnoise": "quic", "wnoisecount": "15", "wnoisedelay": "1-2", "wpayloadsize": "5-10"'
    echo '      },'
    echo '      "tag": "proxy"'
    echo '    },'
    echo '    {"protocol": "freedom", "settings": {"domainStrategy": "UseIP"}, "tag": "direct"},'
    echo '    {"protocol": "blackhole", "settings": {"response": {"type": "http"}}, "tag": "block"}'
    echo '  ],'
    echo '  "remarks": "'$new_name'",'
    echo '  "routing": {'
    echo '    "domainStrategy": "IPIfNonMatch",'
    echo '    "rules": ['
    echo '      {"ip": ["1.1.1.1"], "outboundTag": "proxy", "port": "53", "t
