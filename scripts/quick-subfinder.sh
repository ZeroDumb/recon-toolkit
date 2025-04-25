#!/bin/bash

# Quick Subfinder - A script to automate subdomain enumeration
# Author: ZeroDumb
# License: MIT

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
OUTPUT_FILE="subdomains.txt"
VERBOSE=false
SILENT=false
TIMEOUT=30

# Help function
show_help() {
    echo -e "${YELLOW}Quick Subfinder - Subdomain Enumeration Tool${NC}"
    echo "Usage: $0 [options] -d domain.com"
    echo
    echo "Options:"
    echo "  -d, --domain     Target domain (required)"
    echo "  -o, --output     Output file (default: subdomains.txt)"
    echo "  -v, --verbose    Verbose output"
    echo "  -s, --silent     Silent mode (minimal output)"
    echo "  -t, --timeout    Timeout in seconds (default: 30)"
    echo "  -h, --help       Show this help message"
    echo
    echo "Example:"
    echo "  $0 -d example.com -o results.txt -v"
}

# Check if required tools are installed
check_dependencies() {
    local tools=("subfinder" "httpx" "anew")
    local missing_tools=()

    for tool in "${tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            missing_tools+=("$tool")
        fi
    done

    if [ ${#missing_tools[@]} -ne 0 ]; then
        echo -e "${RED}Error: The following required tools are missing:${NC}"
        printf '%s\n' "${missing_tools[@]}"
        echo -e "Please install them before running this script."
        exit 1
    fi
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -d|--domain)
            DOMAIN="$2"
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
        -t|--timeout)
            TIMEOUT="$2"
            shift 2
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

# Check if domain is provided
if [ -z "$DOMAIN" ]; then
    echo -e "${RED}Error: Domain is required${NC}"
    show_help
    exit 1
fi

# Check dependencies
check_dependencies

# Create output directory if it doesn't exist
OUTPUT_DIR=$(dirname "$OUTPUT_FILE")
if [ ! -z "$OUTPUT_DIR" ]; then
    mkdir -p "$OUTPUT_DIR"
fi

# Start subdomain enumeration
if [ "$VERBOSE" = true ]; then
    echo -e "${GREEN}Starting subdomain enumeration for ${DOMAIN}...${NC}"
fi

# Run subfinder with timeout
timeout "$TIMEOUT" subfinder -d "$DOMAIN" -silent | \
    httpx -silent -status-code -title | \
    anew "$OUTPUT_FILE"

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
