#!/bin/bash

# =============================================
# ULTIMATE WEBSITE CLONER TOOL
# Educational Purpose Only - Kali Linux
# =============================================

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
ORANGE='\033[0;33m'
WHITE='\033[1;37m'
NC='\033[0m'

# Global variables
FOLDER_NAME=""
WEBSITE_URL=""
DOMAIN_NAME=""
START_TIME=""

# Banner with better design
print_banner() {
    clear
    echo -e "${PURPLE}"
    echo " ██████╗ ███████╗██████╗ ███████╗██████╗ ███████╗██████╗ "
    echo "██╔════╝ ██╔════╝██╔══██╗██╔════╝██╔══██╗██╔════╝██╔══██╗"
    echo "██║  ███╗█████╗  ██████╔╝█████╗  ██████╔╝███████╗██████╔╝"
    echo "██║   ██║██╔══╝  ██╔══██╗██╔══╝  ██╔══██╗╚════██║██╔═══╝ "
    echo "╚██████╔╝███████╗██║  ██║███████╗██║  ██║███████║██║     "
    echo " ╚═════╝ ╚══════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚══════╝╚═╝     "
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║                   ULTIMATE CLONER v4.0                  ║"
    echo "║               KALI LINUX PROFESSIONAL TOOL              ║"
    echo "║               For Educational Purposes Only             ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo -e "${YELLOW}[INFO]${NC} Complete Website Cloning Suite"
    echo -e "${YELLOW}[INFO]${NC} All Files in Single Folder"
    echo -e "${YELLOW}[INFO]${NC} Advanced Features Enabled"
    echo ""
}

# Check dependencies
check_dependencies() {
    echo -e "${YELLOW}[CHECK]${NC} Checking system dependencies..."
    
    local deps=("wget" "curl" "tree" "unzip" "file")
    local missing=()
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing+=("$dep")
        fi
    done
    
    if [ ${#missing[@]} -ne 0 ]; then
        echo -e "${RED}[MISSING]${NC} Installing: ${missing[*]}"
        apt-get update > /dev/null 2>&1
        apt-get install -y "${missing[@]}" > /dev/null 2>&1
    fi
    
    echo -e "${GREEN}[READY]${NC} All dependencies installed"
}

# Create simple folder name
create_folder_name() {
    local url=$1
    # Extract only domain and remove www
    local domain=$(echo "$url" | sed 's#^https://##;s#^http://##;s#^www.##' | cut -d'/' -f1)
    DOMAIN_NAME="$domain"
    echo "$domain"
}

# Get website URL
get_website_url() {
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║                    TARGET WEBSITE                        ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    echo -e "${YELLOW}[EXAMPLES]${NC}"
    echo -e "  ${GREEN}example.com${NC}"
    echo -e "  ${GREEN}github.com/username/project${NC}"
    echo -e "  ${GREEN}subdomain.example.com/path${NC}"
    echo ""
    
    while true; do
        echo -n -e "${GREEN}[🌐 URL]${NC} Enter website (without https://) > "
        read user_input
        
        if [ -z "$user_input" ]; then
            echo -e "${RED}[ERROR]${NC} Please enter a website URL"
            continue
        fi
        
        # Basic validation
        if [[ "$user_input" == *.* ]]; then
            WEBSITE_URL="$user_input"
            FOLDER_NAME=$(create_folder_name "$user_input")
            break
        else
            echo -e "${RED}[ERROR]${NC} Please enter a valid URL with domain"
        fi
    done
    
    echo -e "${BLUE}[TARGET]${NC} Website: ${GREEN}https://$WEBSITE_URL${NC}"
    echo -e "${BLUE}[FOLDER]${NC} Output: ${GREEN}$FOLDER_NAME${NC}"
}

# Advanced cloning with single folder structure
clone_website_advanced() {
    local url=$1
    
    echo ""
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║                  ADVANCED CLONING                        ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    # Remove existing folder
    if [ -d "$FOLDER_NAME" ]; then
        echo -e "${YELLOW}[CLEANUP]${NC} Removing existing folder: $FOLDER_NAME"
        rm -rf "$FOLDER_NAME"
    fi
    
    # Create main folder
    mkdir -p "$FOLDER_NAME"
    cd "$FOLDER_NAME" || return 1
    
    START_TIME=$(date +%s)
    
    echo -e "${YELLOW}[CONFIG]${NC} Download configuration:"
    echo -e "  ${BLUE}•${NC} Target: ${GREEN}https://$url${NC}"
    echo -e "  ${BLUE}•${NC} Output: ${GREEN}$FOLDER_NAME/${NC}"
    echo -e "  ${BLUE}•${NC} Mode: ${GREEN}Single Folder Structure${NC}"
    echo ""
    
    # Advanced wget command for single folder
    echo -e "${BLUE}[PHASE 1]${NC} Downloading main website structure..."
    
    wget \
        --recursive \
        --level=inf \
        --no-clobber \
        --page-requisites \
        --adjust-extension \
        --convert-links \
        --backup-converted \
        --no-parent \
        --no-check-certificate \
        --timeout=30 \
        --tries=3 \
        --wait=2 \
        --random-wait \
        --user-agent="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36" \
        --execute robots=off \
        --directory-prefix="." \
        --no-host-directories \
        --cut-dirs=100 \
        "https://$url" 2>&1 | tee wget.log &
    
    local wget_pid=$!
    
    # Progress animation
    echo -n -e "${YELLOW}[PROGRESS]${NC} Cloning "
    local spin=('⣷' '⣯' '⣟' '⡿' '⢿' '⣻' '⣽' '⣾')
    local i=0
    while kill -0 "$wget_pid" 2>/dev/null; do
        i=$(( (i+1) % 8 ))
        echo -ne "\r${YELLOW}[PROGRESS]${NC} Cloning ${spin[$i]} "
        sleep 0.5
    done
    
    wait $wget_pid
    local exit_code=$?
    
    echo -e "\r${GREEN}[PROGRESS]${NC} Download completed!          "
    
    # Post-processing
    echo -e "${BLUE}[PHASE 2]${NC} Organizing files..."
    
    # Fix file permissions
    chmod -R 755 .
    
    # Remove wget log
    rm -f wget.log
    
    cd ..
    
    local end_time=$(date +%s)
    local duration=$((end_time - START_TIME))
    
    echo -e "${GREEN}[TIME]${NC} Cloning completed in ${duration} seconds"
    return $exit_code
}

# Comprehensive analysis
analyze_website() {
    echo ""
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║                   COMPREHENSIVE ANALYSIS                 ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    if [ ! -d "$FOLDER_NAME" ]; then
        echo -e "${RED}[ERROR]${NC} Folder not found: $FOLDER_NAME"
        return 1
    fi
    
    cd "$FOLDER_NAME" || return 1
    
    echo -e "${YELLOW}[SCANNING]${NC} Analyzing cloned website..."
    
    # Basic file counts
    local total_files=$(find . -type f 2>/dev/null | wc -l)
    local total_dirs=$(find . -type d 2>/dev/null | wc -l)
    local total_size=$(du -sh . 2>/dev/null | cut -f1)
    
    echo -e "${GREEN}[OVERVIEW]${NC}"
    echo -e "  📁 Total Files: ${WHITE}$total_files${NC}"
    echo -e "  📂 Total Folders: ${WHITE}$((total_dirs - 1))${NC}"
    echo -e "  💾 Total Size: ${WHITE}$total_size${NC}"
    
    # File type analysis
    echo ""
    echo -e "${GREEN}[FILE TYPES]${NC}"
    
    local html_count=$(find . -name "*.html" -o -name "*.htm" 2>/dev/null | wc -l)
    local css_count=$(find . -name "*.css" 2>/dev/null | wc -l)
    local js_count=$(find . -name "*.js" 2>/dev/null | wc -l)
    local php_count=$(find . -name "*.php" 2>/dev/null | wc -l)
    local json_count=$(find . -name "*.json" 2>/dev/null | wc -l)
    local xml_count=$(find . -name "*.xml" 2>/dev/null | wc -l)
    
    local img_count=$(find . \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" -o -name "*.svg" -o -name "*.webp" -o -name "*.bmp" \) 2>/dev/null | wc -l)
    local font_count=$(find . \( -name "*.woff" -o -name "*.woff2" -o -name "*.ttf" -o -name "*.otf" -o -name "*.eot" \) 2>/dev/null | wc -l)
    
    echo -e "  🌐 HTML/HTM: ${WHITE}$html_count${NC}"
    echo -e "  🎨 CSS: ${WHITE}$css_count${NC}"
    echo -e "  ⚡ JavaScript: ${WHITE}$js_count${NC}"
    echo -e "  🐘 PHP: ${WHITE}$php_count${NC}"
    echo -e "  📊 JSON: ${WHITE}$json_count${NC}"
    echo -e "  📄 XML: ${WHITE}$xml_count${NC}"
    echo -e "  🖼️  Images: ${WHITE}$img_count${NC}"
    echo -e "  🔤 Fonts: ${WHITE}$font_count${NC}"
    
    # Directory structure
    echo ""
    echo -e "${GREEN}[DIRECTORY STRUCTURE]${NC}"
    ls -la | head -20
    
    # Important files
    echo ""
    echo -e "${GREEN}[KEY FILES]${NC}"
    find . -maxdepth 1 -type f \( -name "*.html" -o -name "index.*" -o -name "main.*" -o -name "default.*" \) 2>/dev/null | head -10
    
    # Recent files
    echo ""
    echo -e "${GREEN}[RECENT FILES]${NC}"
    find . -type f -exec ls -lt --time=ctime {} + 2>/dev/null | head -10 | awk '{print $6, $7, $8, $9}'
    
    cd ..
}

# Security analysis
security_scan() {
    echo ""
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║                     SECURITY SCAN                        ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    cd "$FOLDER_NAME" || return 1
    
    echo -e "${YELLOW}[SCANNING]${NC} Performing security analysis..."
    
    # Look for interesting files
    local interesting_files=(
        ".env" ".git" ".htaccess" "robots.txt" "sitemap.xml" 
        "config.json" "package.json" "composer.json" "web.config"
        "backup" "admin" "login" "phpinfo" "test"
    )
    
    echo -e "${GREEN}[INTERESTING FILES]${NC}"
    for file in "${interesting_files[@]}"; do
        local found=$(find . -iname "*$file*" 2>/dev/null | head -5)
        if [ -n "$found" ]; then
            echo -e "  🔍 ${WHITE}$file${NC}:"
            echo "$found" | while read -r line; do
                echo -e "     📄 $line"
            done
        fi
    done
    
    # Check for common vulnerabilities patterns
    echo ""
    echo -e "${GREEN}[CODE PATTERNS]${NC}"
    
    local patterns=(
        "password" "api_key" "secret" "token" 
        "admin" "login" "auth" "session"
    )
    
    for pattern in "${patterns[@]}"; do
        local count=$(grep -r -i "$pattern" . 2>/dev/null | grep -v "node_modules" | grep -v ".git" | wc -l)
        if [ "$count" -gt 0 ]; then
            echo -e "  🔎 ${WHITE}$pattern${NC}: $count occurrences"
        fi
    done
    
    cd ..
}

# Generate report
generate_report() {
    local report_file="${FOLDER_NAME}_report.txt"
    
    echo ""
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║                      FINAL REPORT                        ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    {
        echo "=== ULTIMATE WEBSITE CLONER REPORT ==="
        echo "Website: https://$WEBSITE_URL"
        echo "Cloned to: $FOLDER_NAME"
        echo "Date: $(date)"
        echo "Time taken: $(( $(date +%s) - START_TIME )) seconds"
        echo ""
        echo "=== FILE STATISTICS ==="
        cd "$FOLDER_NAME" && find . -type f | sed 's/.*\.//' | sort | uniq -c | sort -nr
    } > "$report_file"
    
    echo -e "${GREEN}[REPORT]${NC} Detailed report saved to: ${WHITE}$report_file${NC}"
    
    # Show quick stats from report
    echo ""
    echo -e "${YELLOW}[QUICK STATS]${NC}"
    head -20 "$report_file"
}

# Show exploration guide
exploration_guide() {
    echo ""
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║                    EXPLORATION GUIDE                     ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    
    echo -e "${GREEN}[QUICK START]${NC}"
    echo -e "  ${WHITE}cd $FOLDER_NAME${NC}"
    echo -e "  ${WHITE}ls -la${NC}                          # See all files"
    echo ""
    
    echo -e "${GREEN}[FILE EXPLORATION]${NC}"
    echo -e "  ${WHITE}find . -name '*.html' | head -10${NC} # Find HTML files"
    echo -e "  ${WHITE}find . -name '*.js' | head -10${NC}   # Find JavaScript files"
    echo -e "  ${WHITE}find . -name '*.css' | head -10${NC}  # Find CSS files"
    echo -e "  ${WHITE}find . -name '*.php' | head -10${NC}  # Find PHP files"
    echo ""
    
    echo -e "${GREEN}[CONTENT ANALYSIS]${NC}"
    echo -e "  ${WHITE}grep -r 'password' . --include='*.js'${NC}    # Search in JS files"
    echo -e "  ${WHITE}grep -r 'admin' . --include='*.php'${NC}      # Search in PHP files"
    echo -e "  ${WHITE}tree -L 2${NC}                               # Show directory tree"
    echo ""
    
    echo -e "${GREEN}[SECURITY CHECKS]${NC}"
    echo -e "  ${WHITE}find . -name '*.env'${NC}                    # Environment files"
    echo -e "  ${WHITE}find . -name '.htaccess'${NC}                # Apache config"
    echo -e "  ${WHITE}find . -name 'config.*'${NC}                 # Configuration files"
}

# Main function
main() {
    print_banner
    check_dependencies
    get_website_url
    
    echo ""
    echo -e "${YELLOW}[INITIALIZING]${NC} Starting advanced cloning process..."
    
    if clone_website_advanced "$WEBSITE_URL"; then
        echo -e "${GREEN}"
        echo "╔══════════════════════════════════════════════════════════╗"
        echo "║                   CLONING COMPLETED!                    ║"
        echo "║                     ✅ SUCCESS ✅                       ║"
        echo "╚══════════════════════════════════════════════════════════╝"
        echo -e "${NC}"
        
        analyze_website
        security_scan
        generate_report
        exploration_guide
        
        echo ""
        echo -e "${GREEN}[LOCATION]${NC} ${WHITE}cd $FOLDER_NAME${NC}"
        echo -e "${GREEN}[FILES]${NC} ${WHITE}ls -la${NC} to view all files"
        echo ""
        echo -e "${BLUE}[EDUCATIONAL USE]${NC} Use responsibly for learning purposes!"
        
    else
        echo -e "${RED}"
        echo "╔══════════════════════════════════════════════════════════╗"
        echo "║                   CLONING FAILED!                       ║"
        echo "║                     ❌ ERROR ❌                         ║"
        echo "╚══════════════════════════════════════════════════════════╝"
        echo -e "${NC}"
    fi
}

# Run main function
main "$@"
