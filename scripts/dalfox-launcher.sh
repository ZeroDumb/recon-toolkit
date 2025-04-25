#!/bin/bash

# Dalfox Launcher - A script to automate XSS testing with dalfox
# Author: ZeroDumb
# License: MIT

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
OUTPUT_FILE="dalfox_results.txt"
VERBOSE=false
SILENT=false
TIMEOUT=60
PAYLOAD_FILE=""
BLIND_URL=""
DOMAIN=""
COOKIE=""
HEADER=""
METHOD="GET"
DATA=""
PROXY=""

# Help function
show_help() {
    echo -e "${YELLOW}Dalfox Launcher - XSS Testing Tool${NC}"
    echo "Usage: $0 [options] -u https://target.com/path?param=value"
    echo
    echo "Options:"
    echo "  -u, --url        Target URL with parameter to test (required)"
    echo "  -o, --output     Output file (default: dalfox_results.txt)"
    echo "  -p, --payload    Custom payload file"
    echo "  -b, --blind      Blind XSS callback URL"
    echo "  -d, --domain     Domain to scan (for crawling)"
    echo "  -c, --cookie     Cookie to use"
    echo "  -H, --header     Custom header (format: 'Name: Value')"
    echo "  -m, --method     HTTP method (GET, POST, etc.) (default: GET)"
    echo "  -D, --data       POST data"
    echo "  -x, --proxy      Proxy URL (e.g., http://127.0.0.1:8080)"
    echo "  -v, --verbose    Verbose output"
    echo "  -s, --silent     Silent mode (minimal output)"
    echo "  -h, --help       Show this help message"
    echo
    echo "Example:"
    echo "  $0 -u https://example.com/search?q=test -o xss.txt -p payloads.txt"
}

# Check if dalfox is installed
check_dependencies() {
    if ! command -v dalfox &> /dev/null; then
        echo -e "${RED}Error: dalfox is not installed${NC}"
        echo "Please install dalfox before running this script."
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
        -o|--output)
            OUTPUT_FILE="$2"
            shift 2
            ;;
        -p|--payload)
            PAYLOAD_FILE="$2"
            shift 2
            ;;
        -b|--blind)
            BLIND_URL="$2"
            shift 2
            ;;
        -d|--domain)
            DOMAIN="$2"
            shift 2
            ;;
        -c|--cookie)
            COOKIE="$2"
            shift 2
            ;;
        -H|--header)
            HEADER="$2"
            shift 2
            ;;
        -m|--method)
            METHOD="$2"
            shift 2
            ;;
        -D|--data)
            DATA="$2"
            shift 2
            ;;
        -x|--proxy)
            PROXY="$2"
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
if [ -z "$URL" ] && [ -z "$DOMAIN" ]; then
    echo -e "${RED}Error: Either URL or domain is required${NC}"
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

# Start XSS testing
if [ "$VERBOSE" = true ]; then
    echo -e "${GREEN}Starting XSS testing...${NC}"
    if [ ! -z "$URL" ]; then
        echo -e "Target URL: ${YELLOW}$URL${NC}"
    fi
    if [ ! -z "$DOMAIN" ]; then
        echo -e "Target Domain: ${YELLOW}$DOMAIN${NC}"
    fi
fi

# Build dalfox command
DALFOX_CMD="dalfox"

# Add URL or domain
if [ ! -z "$URL" ]; then
    DALFOX_CMD="${DALFOX_CMD} url \"${URL}\""
elif [ ! -z "$DOMAIN" ]; then
    DALFOX_CMD="${DALFOX_CMD} scan \"${DOMAIN}\""
fi

# Add output file
DALFOX_CMD="${DALFOX_CMD} --output \"${OUTPUT_FILE}\""

# Add payload file if specified
if [ ! -z "$PAYLOAD_FILE" ]; then
    if [ ! -f "$PAYLOAD_FILE" ]; then
        echo -e "${RED}Error: Payload file not found: $PAYLOAD_FILE${NC}"
        exit 1
    fi
    DALFOX_CMD="${DALFOX_CMD} --payload-file \"${PAYLOAD_FILE}\""
fi

# Add blind XSS callback URL if specified
if [ ! -z "$BLIND_URL" ]; then
    DALFOX_CMD="${DALFOX_CMD} --blind \"${BLIND_URL}\""
fi

# Add cookie if specified
if [ ! -z "$COOKIE" ]; then
    DALFOX_CMD="${DALFOX_CMD} --cookie \"${COOKIE}\""
fi

# Add header if specified
if [ ! -z "$HEADER" ]; then
    DALFOX_CMD="${DALFOX_CMD} --header \"${HEADER}\""
fi

# Add method if not GET
if [ "$METHOD" != "GET" ]; then
    DALFOX_CMD="${DALFOX_CMD} --method ${METHOD}"
fi

# Add data if specified
if [ ! -z "$DATA" ]; then
    DALFOX_CMD="${DALFOX_CMD} --data \"${DATA}\""
fi

# Add proxy if specified
if [ ! -z "$PROXY" ]; then
    DALFOX_CMD="${DALFOX_CMD} --proxy \"${PROXY}\""
fi

# Add verbose flag if specified
if [ "$VERBOSE" = true ]; then
    DALFOX_CMD="${DALFOX_CMD} --verbose"
fi

# Run dalfox with timeout
if [ "$VERBOSE" = true ]; then
    echo -e "Running command: ${YELLOW}${DALFOX_CMD}${NC}"
fi

timeout "$TIMEOUT" bash -c "$DALFOX_CMD"

# Check if the scan was successful
if [ $? -eq 0 ]; then
    if [ "$SILENT" = false ]; then
        echo -e "${GREEN}XSS testing completed successfully!${NC}"
        echo -e "Results saved to: ${YELLOW}$OUTPUT_FILE${NC}"
    fi
else
    echo -e "${RED}XSS testing failed or timed out after ${TIMEOUT} seconds${NC}"
    exit 1
fi 