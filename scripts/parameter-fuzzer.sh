#!/bin/bash

# Parameter Fuzzer - A script to automate parameter discovery and fuzzing
# Author: ZeroDumb
# License: MIT

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
WORDLIST="/usr/share/seclists/Discovery/Web-Content/burp-parameter-names.txt"
THREADS=40
TIMEOUT=30
VERBOSE=false
SILENT=false
METHOD="GET"
PARAM_VALUE="FUZZ"
OUTPUT_FILE="parameter_fuzz_results.txt"
FILTER_STATUS=""
FILTER_SIZE=""

# Help function
show_help() {
    echo -e "${YELLOW}Parameter Fuzzer - Parameter Discovery Tool${NC}"
    echo "Usage: $0 [options] -u https://target.com/path?param=value"
    echo
    echo "Options:"
    echo "  -u, --url        Target URL with parameter to fuzz (required)"
    echo "  -w, --wordlist   Wordlist file (default: burp-parameter-names.txt)"
    echo "  -t, --threads    Number of threads (default: 40)"
    echo "  -m, --method     HTTP method (GET, POST, etc.) (default: GET)"
    echo "  -v, --value      Value to use for the parameter (default: FUZZ)"
    echo "  -o, --output     Output file (default: parameter_fuzz_results.txt)"
    echo "  -f, --filter     Filter by status code (e.g., 200,301,302)"
    echo "  -s, --size       Filter by response size (e.g., 1234)"
    echo "  -V, --verbose    Verbose output"
    echo "  -S, --silent     Silent mode (minimal output)"
    echo "  -h, --help       Show this help message"
    echo
    echo "Example:"
    echo "  $0 -u https://example.com/search?q=test -w params.txt -m GET -f 200,301"
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
        -m|--method)
            METHOD="$2"
            shift 2
            ;;
        -v|--value)
            PARAM_VALUE="$2"
            shift 2
            ;;
        -o|--output)
            OUTPUT_FILE="$2"
            shift 2
            ;;
        -f|--filter)
            FILTER_STATUS="$2"
            shift 2
            ;;
        -s|--size)
            FILTER_SIZE="$2"
            shift 2
            ;;
        -V|--verbose)
            VERBOSE=true
            shift
            ;;
        -S|--silent)
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

# Extract base URL and parameter
BASE_URL=$(echo "$URL" | cut -d'?' -f1)
PARAM=$(echo "$URL" | cut -d'?' -f2 | cut -d'=' -f1)
VALUE=$(echo "$URL" | cut -d'?' -f2 | cut -d'=' -f2)

# Start parameter fuzzing
if [ "$VERBOSE" = true ]; then
    echo -e "${GREEN}Starting parameter fuzzing for ${URL}...${NC}"
    echo -e "Wordlist: ${YELLOW}$WORDLIST${NC}"
    echo -e "Threads: ${YELLOW}$THREADS${NC}"
    echo -e "Method: ${YELLOW}$METHOD${NC}"
fi

# Build ffuf command
FFUF_CMD="ffuf -u \"${BASE_URL}?${PARAM}=${PARAM_VALUE}\" -w ${WORDLIST}:FUZZ -t ${THREADS} -o ${OUTPUT_FILE} -of json -s"

# Add method if not GET
if [ "$METHOD" != "GET" ]; then
    FFUF_CMD="${FFUF_CMD} -X ${METHOD}"
fi

# Add filters if specified
if [ ! -z "$FILTER_STATUS" ]; then
    FFUF_CMD="${FFUF_CMD} -fc ${FILTER_STATUS}"
fi

if [ ! -z "$FILTER_SIZE" ]; then
    FFUF_CMD="${FFUF_CMD} -fs ${FILTER_SIZE}"
fi

# Run ffuf with timeout
if [ "$VERBOSE" = true ]; then
    echo -e "Running command: ${YELLOW}${FFUF_CMD}${NC}"
fi

timeout "$TIMEOUT" bash -c "$FFUF_CMD"

# Check if the scan was successful
if [ $? -eq 0 ]; then
    if [ "$SILENT" = false ]; then
        echo -e "${GREEN}Parameter fuzzing completed successfully!${NC}"
        echo -e "Results saved to: ${YELLOW}$OUTPUT_FILE${NC}"
    fi
else
    echo -e "${RED}Parameter fuzzing failed or timed out after ${TIMEOUT} seconds${NC}"
    exit 1
fi 