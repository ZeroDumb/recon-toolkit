#!/bin/bash

# FFuf Launcher - A script to automate directory and content discovery
# Author: ZeroDumb
# License: MIT

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
WORDLIST="/usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt"
THREADS=40
TIMEOUT=30
VERBOSE=false
SILENT=false
EXTENSIONS="php,asp,aspx,jsp,html,js"
OUTPUT_FILE="ffuf_results.txt"

# Help function
show_help() {
    echo -e "${YELLOW}FFuf Launcher - Directory Discovery Tool${NC}"
    echo "Usage: $0 [options] -u https://target.com"
    echo
    echo "Options:"
    echo "  -u, --url        Target URL (required)"
    echo "  -w, --wordlist   Wordlist file (default: dirbuster medium)"
    echo "  -t, --threads    Number of threads (default: 40)"
    echo "  -e, --ext        File extensions to scan (default: php,asp,aspx,jsp,html,js)"
    echo "  -o, --output     Output file (default: ffuf_results.txt)"
    echo "  -v, --verbose    Verbose output"
    echo "  -s, --silent     Silent mode (minimal output)"
    echo "  -h, --help       Show this help message"
    echo
    echo "Example:"
    echo "  $0 -u https://example.com -w custom_wordlist.txt -e php,html -t 50"
}

# Check if ffuf is installed
check_dependencies() {
    if ! command -v ffuf &> /dev/null; then
        echo -e "${RED}Error: ffuf is not installed${NC}"
        echo "Please install ffuf before running this script."
        exit 1
    fi
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -u|--url)
            URL="$2"
            shift 2
            ;;
        -w|--wordlist)
            WORDLIST="$2"
            shift 2
            ;;
        -t|--threads)
            THREADS="$2"
            shift 2
            ;;
        -e|--ext)
            EXTENSIONS="$2"
            shift 2
            ;;
        -o|--output)
            OUTPUT_FILE="$2"
            shift 2
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -s|--silent)
            SILENT=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            show_help
            exit 1
            ;;
    esac
done

# Check if URL is provided
if [ -z "$URL" ]; then
    echo -e "${RED}Error: URL is required${NC}"
    show_help
    exit 1
fi

# Check if wordlist exists
if [ ! -f "$WORDLIST" ]; then
    echo -e "${RED}Error: Wordlist file not found: $WORDLIST${NC}"
    exit 1
fi

# Check dependencies
check_dependencies

# Create output directory if it doesn't exist
OUTPUT_DIR=$(dirname "$OUTPUT_FILE")
if [ ! -z "$OUTPUT_DIR" ]; then
    mkdir -p "$OUTPUT_DIR"
fi

# Start directory discovery
if [ "$VERBOSE" = true ]; then
    echo -e "${GREEN}Starting directory discovery for ${URL}...${NC}"
    echo -e "Wordlist: ${YELLOW}$WORDLIST${NC}"
    echo -e "Threads: ${YELLOW}$THREADS${NC}"
    echo -e "Extensions: ${YELLOW}$EXTENSIONS${NC}"
fi

# Run ffuf with timeout
timeout "$TIMEOUT" ffuf \
    -u "${URL}/FUZZ" \
    -w "$WORDLIST" \
    -t "$THREADS" \
    -e "$EXTENSIONS" \
    -o "$OUTPUT_FILE" \
    -of json \
    -s \
    -fc 404

# Check if the scan was successful
if [ $? -eq 0 ]; then
    if [ "$SILENT" = false ]; then
        echo -e "${GREEN}Scan completed successfully!${NC}"
        echo -e "Results saved to: ${YELLOW}$OUTPUT_FILE${NC}"
    fi
else
    echo -e "${RED}Scan failed or timed out after ${TIMEOUT} seconds${NC}"
    exit 1
fi
