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
echo -e "${CYAN}====================================${RESET}"
echo -e "${CYAN}|       Argh94 WARP Config        |${RESET}"
echo -e "${CYAN}| GitHub: ${BLUE}https://github.com/Argh94${RESET} |${RESET}"
echo -e "${CYAN}====================================${RESET}"
echo -e "${CYAN}| Date: $(date '+%Y-%m-%d %H:%M:%S') |${RESET}"
echo ""

# Install required packages
pkg_install() {
    echo -e "${CYAN}Checking for required packages...${RESET}"
    pkg update -y && pkg install curl -y
}

# Check for curl
if ! command -v curl >/dev/null 2>&1; then
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
    # Create directory if it doesn't exist
    mkdir -p ~/.argh94
    # Remove old script if it exists
    rm -f ~/.argh94/argh94_warp.sh
    # Download the latest script
    if curl -fsSL https://raw.githubusercontent.com/Argh94/Wg-script/main/Wg.sh -o ~/.argh94/argh94_warp.sh; then
        chmod +x ~/.argh94/argh94_warp.sh
        # Ensure .bashrc exists
        touch ~/.bashrc
        # Remove any old Arg alias
        sed -i '/alias Arg=/d' ~/.bashrc
        # Add new alias to .bashrc
        echo "alias Arg='bash ~/.argh94/argh94_warp.sh'" >> ~/.bashrc
        # Ensure .bash_profile sources .bashrc
        if [ -f ~/.bash_profile ]; then
            if ! grep -q "source ~/.bashrc" ~/.bash_profile; then
                echo "source ~/.bashrc" >> ~/.bash_profile
            fi
        else
            touch ~/.bash_profile
            echo "source ~/.bashrc" >> ~/.bash_profile
        fi
        # Try to reload .bashrc
        if ! source ~/.bashrc 2>/dev/null && ! . ~/.bashrc 2>/dev/null; then
            echo -e "${YELLOW}Warning: Could not reload .bashrc automatically.${RESET}"
        fi
        echo -e "${GREEN}Script installed successfully! Run it by typing 'Arg' in Termux.${RESET}"
        echo -e "${CYAN}Please run 'source ~/.bashrc' or restart Termux to use 'Arg'.${RESET}"
        echo -e "${CYAN}If 'Arg' still doesn't work, check ~/.bashrc and ~/.bash_profile.${RESET}"
    else
        echo -e "${RED}Error: Failed to download the script. Please check your internet connection and try again.${RESET}"
        exit 1
    fi
}

# Main menu with colored border
echo -e "${GREEN}┌──────────────────────────────────┐${RESET}"
echo -e "${GREEN}│${CYAN}       Select an Option          ${GREEN}│${RESET}"
echo -e "${GREEN}├──────────────────────────────────┤${RESET}"
echo -e "${GREEN}│${RESET} 1) WARP IPv4 Endpoint IP Preferred ${GREEN}│${RESET}"
echo -e "${GREEN}│${RESET} 2) WARP IPv6 Endpoint IP Preferred ${GREEN}│${RESET}"
echo -e "${GREEN}│${RESET} 3) Generate IPv4 Config         ${GREEN}│${RESET}"
echo -e "${GREEN}│${RESET} 4) Generate IPv6 Config         ${GREEN}│${RESET}"
echo -e "${GREEN}│${RESET} 5) Install Script Permanently   ${GREEN}│${RESET}"
echo -e "${GREEN}│${RESET} q) Quit                         ${GREEN}│${RESET}"
echo -e "${GREEN}└──────────────────────────────────┘${RESET}"
read -p "Enter your choice: " user_choice

# Handle menu choices
case "$user_choice" in
    1)
        echo -e "${CYAN}Fetching WARP IPv4 Endpoint...${RESET}"
        # Disable job control to suppress messages
        set +m
        # Run the fetch command in a subshell
        tmpfile=$(mktemp)
        ( echo "1" | bash <(curl -fsSL https://raw.githubusercontent.com/Kolandone/Selector/main/Sel.sh) > "$tmpfile" 2>/dev/null ) &
        pid=$!
        disown $pid 2>/dev/null
        # Print dots until the fetch is complete
        while kill -0 $pid 2>/dev/null; do
            echo -n "."
            sleep 0.2
        done
        echo ""
        # Extract the first valid IPv4 address
        raw_output=$(cat "$tmpfile")
        rm -f "$tmpfile"
        fetched_ip=$(echo "$raw_output" | grep -oP '(\d{1,3}\.){3}\d{1,3}:\d+' | head -n 1)
        if [ -z "$fetched_ip" ]; then
            echo -e "${RED}Failed to fetch a valid IPv4 Endpoint.${RESET}"
            exit 1
        else
            echo -e "${GREEN}WARP IPv4 Endpoint: $fetched_ip${RESET}"
            exit 0
        fi
        ;;
    2)
        echo -e "${CYAN}Fetching WARP IPv6 Endpoint...${RESET}"
        # Disable job control to suppress messages
        set +m
        # Run the fetch command in a subshell
        tmpfile=$(mktemp)
        ( echo "2" | bash <(curl -fsSL https://raw.githubusercontent.com/Kolandone/Selector/main/Sel.sh) > "$tmpfile" 2>/dev/null ) &
        pid=$!
        disown $pid 2>/dev/null
        # Print dots until the fetch is complete
        while kill -0 $pid 2>/dev/null; do
            echo -n "."
            sleep 0.2
        done
        echo ""
        # Extract the first valid IPv6 address
        raw_output=$(cat "$tmpfile")
        rm -f "$tmpfile"
        fetched_ip=$(echo "$raw_output" | grep -oP '\[\s*[a-fA-F\d:]+\s*\]:\d+\s*\|\s*\d+' | awk '{print $1 " " $3}' | sort -k2 -n | head -n 1 | awk '{print $1}')
        if [ -z "$fetched_ip" ]; then
            echo -e "${RED}Failed to fetch a valid IPv6 Endpoint.${RESET}"
            exit 1
        else
            echo -e "${GREEN}WARP IPv6 Endpoint: $fetched_ip${RESET}"
            exit 0
        fi
        ;;
    5)
        install_script
        exit 0
        ;;
    q|Q)
        echo -e "${GREEN}Exiting...${RESET}"
        exit 0
        ;;
esac

# Get user input for config generation
if [[ "$user_choice" == "3" || "$user_choice" == "4" ]]; then
    read -p "Enter the new MTU size (default is 1280): " new_mtu
    read -p "Enter the new name (default is Argh94): " new_name
    # Set defaults
    new_mtu=${new_mtu:-"1280"}
    new_name=${new_name:-"Argh94"}
else
    echo -e "${RED}Invalid choice. Exiting...${RESET}"
    exit 1
fi

# Fetch IP address with continuous dots
if [ "$user_choice" == "3" ]; then
    echo -e "${CYAN}Fetching IPv4 Endpoint...${RESET}"
    # Disable job control to suppress messages
    set +m
    # Run the fetch command in a subshell to avoid job control messages
    tmpfile=$(mktemp)
    ( echo "1" | bash <(curl -fsSL https://raw.githubusercontent.com/Kolandone/Selector/main/Sel.sh) > "$tmpfile" 2>/dev/null ) &
    pid=$!
    disown $pid 2>/dev/null
    # Print dots until the fetch is complete
    while kill -0 $pid 2>/dev/null; do
        echo -n "."
        sleep 0.2
    done
    echo ""
    # Extract the first valid IPv4 address
    raw_output=$(cat "$tmpfile")
    rm -f "$tmpfile"
    fetched_ip=$(echo "$raw_output" | grep -oP '(\d{1,3}\.){3}\d{1,3}:\d+' | head -n 1)
elif [ "$user_choice" == "4" ]; then
    echo -e "${CYAN}Fetching IPv6 Endpoint...${RESET}"
    # Disable job control to suppress messages
    set +m
    # Run the fetch command in a subshell to avoid job control messages
    tmpfile=$(mktemp)
    ( echo "2" | bash <(curl -fsSL https://raw.githubusercontent.com/Kolandone/Selector/main/Sel.sh) > "$tmpfile" 2>/dev/null ) &
    pid=$!
    disown $pid 2>/dev/null
    # Print dots until the fetch is complete
    while kill -0 $pid 2>/dev/null; do
        echo -n "."
        sleep 0.2
    done
    echo ""
    # Extract the first valid IPv6 address
    raw_output=$(cat "$tmpfile")
    rm -f "$tmpfile"
    fetched_ip=$(echo "$raw_output" | grep -oP '\[\s*[a-fA-F\d:]+\s*\]:\d+\s*\|\s*\d+' | awk '{print $1 " " $3}' | sort -k2 -n | head -n 1 | awk '{print $1}')
else
    echo -e "${RED}Invalid choice. Exiting...${RESET}"
    exit 1
fi

# Check if IP was fetched
if [ -z "$fetched_ip" ]; then
    echo -e "${RED}Failed to fetch a valid IP address. Exiting...${RESET}"
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
    echo -e "${RED}Error: Empty response from API.${RESET}"
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

# Generate Hiddify JSON Config
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

# Generate V2RayNG JSON Config
echo -e "\n${GREEN}🚀 V2RayNG JSON Config 🚀${RESET}"
cat << EOF
{
  "remarks": "$new_name - WoW",
  "log": {"loglevel": "warning"},
  "dns": {
    "hosts": {
      "geosite:category-ads-all": "127.0.0.1",
      "geosite:category-ads-ir": "127.0.0.1"
    },
    "servers": [
      "https://94.140.14.14/dns-query",
      {
        "address": "8.8.8.8",
        "domains": ["geosite:category-ir", "domain:.ir"],
        "expectIPs": ["geoip:ir"],
        "port": 53
      }
    ],
    "tag": "dns"
  },
  "inbounds": [
    {
      "port": 10808,
      "protocol": "socks",
      "settings": {"auth": "noauth", "udp": true, "userLevel": 8},
      "sniffing": {"destOverride": ["http", "tls"], "enabled": true, "routeOnly": true},
      "tag": "socks-in"
    },
    {
      "port": 10809,
      "protocol": "http",
      "settings": {"auth": "noauth", "udp": true, "userLevel": 8},
      "sniffing": {"destOverride": ["http", "tls"], "enabled": true, "routeOnly": true},
      "tag": "http-in"
    },
    {
      "listen": "127.0.0.1",
      "port": 10853,
      "protocol": "dokodemo-door",
      "settings": {"address": "1.1.1.1", "network": "tcp,udp", "port": 53},
      "tag": "dns-in"
    }
  ],
  "outbounds": [
    {
      "protocol": "wireguard",
      "settings": {
        "address": ["$address_ipv4/32", "$address_ipv6/128"],
        "mtu": $new_mtu,
        "peers": [{"endpoint": "$endpoint", "publicKey": "$public_key"}],
        "reserved": [$reserved],
        "secretKey": "$private_key",
        "keepAlive": 10,
        "wnoise": "quic",
        "wnoisecount": "10-15",
        "wpayloadsize": "1-8",
        "wnoisedelay": "1-3"
      },
      "streamSettings": {"sockopt": {"dialerProxy": "warp-ir"}},
      "tag": "warp-out"
    },
    {
      "protocol": "wireguard",
      "settings": {
        "address": ["$address_ipv4/32", "$address_ipv6/128"],
        "mtu": $new_mtu,
        "peers": [{"endpoint": "$endpoint", "publicKey": "$public_key"}],
        "reserved": [$reserved],
        "secretKey": "$private_key",
        "keepAlive": 10,
        "wnoise": "quic",
        "wnoisecount": "10-15",
        "wpayloadsize": "1-8",
        "wnoisedelay": "1-3"
      },
      "tag": "warp-ir"
    },
    {"protocol": "dns", "tag": "dns-out"},
    {"protocol": "freedom", "settings": {}, "tag": "direct"},
    {"protocol": "blackhole", "settings": {"response": {"type": "http"}}, "tag": "block"}
  ],
  "policy": {
    "levels": {"8": {"connIdle": 300, "downlinkOnly": 1, "handshake": 4, "uplinkOnly": 1}},
    "system": {"statsOutboundUplink": true, "statsOutboundDownlink": true}
  },
  "routing": {
    "domainStrategy": "IPIfNonMatch",
    "rules": [
      {"inboundTag": ["dns-in"], "outboundTag": "dns-out", "type": "field"},
      {"ip": ["8.8.8.8"], "outboundTag": "direct", "port": "53", "type": "field"},
      {"domain": ["geosite:category-ir", "domain:.ir"], "outboundTag": "direct", "type": "field"},
      {"ip": ["geoip:ir", "geoip:private"], "outboundTag": "direct", "type": "field"},
      {"domain": ["geosite:category-ads-all", "geosite:category-ads-ir"], "outboundTag": "block", "type": "field"},
      {"outboundTag": "warp-out", "type": "field", "network": "tcp,udp"}
    ]
  },
  "stats": {}
}
EOF

# Generate WireGuard URL
reserved_encoded=$(urlencode "$reserved")
private_key_encoded=$(urlencode "$private_key")
public_key_encoded=$(urlencode "$public_key")
address_encoded=$(urlencode "$address_ipv4/32,$address_ipv6/128")
wg_url="wireguard://$private_key_encoded@$endpoint?address=$address_encoded&reserved=$reserved_encoded&publickey=$public_key_encoded&mtu=$new_mtu#$new_name"

# Display WireGuard URL with decorative lines
echo -e "\n${CYAN}====================================${RESET}"
echo -e "${CYAN}|${RESET} ${GREEN}🔑 WireGuard URL by Argh94${RESET} ${CYAN}|${RESET}"
echo -e "${CYAN}|${RESET} ${YELLOW}$wg_url${RESET}"
echo -e "${CYAN}====================================${RESET}"

# Save configuration
output_file="warp_config_$(date +%F_%H-%M-%S).txt"
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
    echo '  "remarks": "'$new_name' - WoW",'
    echo '  "log": {"loglevel": "warning"},'
    echo '  "dns": {'
    echo '    "hosts": {'
    echo '      "geosite:category-ads-all": "127.0.0.1",'
    echo '      "geosite:category-ads-ir": "127.0.0.1"'
    echo '    },'
    echo '    "servers": ['
    echo '      "https://94.140.14.14/dns-query",'
    echo '      {'
    echo '        "address": "8.8.8.8",'
    echo '        "domains": ["geosite:category-ir", "domain:.ir"],'
    echo '        "expectIPs": ["geoip:ir"],'
    echo '        "port": 53'
    echo '      }'
    echo '    ],'
    echo '    "tag": "dns"'
    echo '  },'
    echo '  "inbounds": ['
    echo '    {'
    echo '      "port": 10808,'
    echo '      "protocol": "socks",'
    echo '      "settings": {"auth": "noauth", "udp": true, "userLevel": 8},'
    echo '      "sniffing": {"destOverride": ["http", "tls"], "enabled": true, "routeOnly": true},'
    echo '      "tag": "socks-in"'
    echo '    },'
    echo '    {'
    echo '      "port": 10809,'
    echo '      "protocol": "http",'
    echo '      "settings": {"auth": "noauth", "udp": true, "userLevel": 8},'
    echo '      "sniffing": {"destOverride": ["http", "tls"], "enabled": true, "routeOnly": true},'
    echo '      "tag": "http-in"'
    echo '    },'
    echo '    {'
    echo '      "listen": "127.0.0.1",'
    echo '      "port": 10853,'
    echo '      "protocol": "dokodemo-door",'
    echo '      "settings": {"address": "1.1.1.1", "network": "tcp,udp", "port": 53},'
    echo '      "tag": "dns-in"'
    echo '    }'
    echo '  ],'
    echo '  "outbounds": ['
    echo '    {'
    echo '      "protocol": "wireguard",'
    echo '      "settings": {'
    echo '        "address": ["'$address_ipv4'/32", "'$address_ipv6'/128"],'
    echo '        "mtu": '$new_mtu','
    echo '        "peers": [{"endpoint": "'$endpoint'", "publicKey": "'$public_key'"}],'
    echo '        "reserved": ['$reserved'],'
    echo '        "secretKey": "'$private_key'",'
    echo '        "keepAlive": 10,'
    echo '        "wnoise": "quic",'
    echo '        "wnoisecount": "10-15",'
    echo '        "wpayloadsize": "1-8",'
    echo '        "wnoisedelay": "1-3"'
    echo '      },'
    echo '      "streamSettings": {"sockopt": {"dialerProxy": "warp-ir"}},'
    echo '      "tag": "warp-out"'
    echo '    },'
    echo '    {'
    echo '      "protocol": "wireguard",'
    echo '      "settings": {'
    echo '        "address": ["'$address_ipv4'/32", "'$address_ipv6'/128"],'
    echo '        "mtu": '$new_mtu','
    echo '        "peers": [{"endpoint": "'$endpoint'", "publicKey": "'$public_key'"}],'
    echo '        "reserved": ['$reserved'],'
    echo '        "secretKey": "'$private_key'",'
    echo '        "keepAlive": 10,'
    echo '        "wnoise": "quic",'
    echo '        "wnoisecount": "10-15",'
    echo '        "wpayloadsize": "1-8",'
    echo '        "wnoisedelay": "1-3"'
    echo '      },'
    echo '      "tag": "warp-ir"'
    echo '    },'
    echo '    {"protocol": "dns", "tag": "dns-out"},'
    echo '    {"protocol": "freedom", "settings": {}, "tag": "direct"},'
    echo '    {"protocol": "blackhole", "settings": {"response": {"type": "http"}}, "tag": "block"}'
    echo '  ],'
    echo '  "policy": {'
    echo '    "levels":
