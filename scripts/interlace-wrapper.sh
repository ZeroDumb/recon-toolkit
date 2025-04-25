#!/bin/bash

# Interlace Wrapper - A script to automate chaining tools with interlace
# Author: ZeroDumb
# License: MIT

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
INPUT_FILE=""
COMMAND=""
OUTPUT_DIR="interlace_output"
VERBOSE=false
SILENT=false
TIMEOUT=300
THREADS=10
DELAY=0

# Help function
show_help() {
    echo -e "${YELLOW}Interlace Wrapper - Tool Chaining Automation${NC}"
    echo "Usage: $0 [options] -i targets.txt -c \"tool -u _target_ [options]\""
    echo
    echo "Options:"
    echo "  -i, --input      Input file with targets (one per line) (required)"
    echo "  -c, --command    Command to run with _target_ placeholder (required)"
    echo "  -o, --output     Output directory (default: interlace_output)"
    echo "  -t, --threads    Number of threads (default: 10)"
    echo "  -d, --delay      Delay between requests in seconds (default: 0)"
    echo "  -v, --verbose    Verbose output"
    echo "  -s, --silent     Silent mode (minimal output)"
    echo "  -h, --help       Show this help message"
    echo
    echo "Example:"
    echo "  $0 -i urls.txt -c \"sqlmap -u _target_ --batch --risk=2 --level=5\""
}

# Check if interlace is installed
check_dependencies() {
    if ! command -v interlace &> /dev/null; then
        echo -e "${RED}Error: interlace is not installed${NC}"
        echo "Please install interlace before running this script."
        exit 1
    fi
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -i|--input)
            INPUT_FILE="$2"
            shift 2
            ;;
        -c|--command)
            COMMAND="$2"
            shift 2
            ;;
        -o|--output)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        -t|--threads)
            THREADS="$2"
            shift 2
            ;;
        -d|--delay)
            DELAY="$2"
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

# Check if input file is provided
if [ -z "$INPUT_FILE" ]; then
    echo -e "${RED}Error: Input file is required${NC}"
    show_help
    exit 1
fi

# Check if command is provided
if [ -z "$COMMAND" ]; then
    echo -e "${RED}Error: Command is required${NC}"
    show_help
    exit 1
fi

# Check if input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo -e "${RED}Error: Input file not found: $INPUT_FILE${NC}"
    exit 1
fi

# Check dependencies
check_dependencies

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Start tool chaining
if [ "$VERBOSE" = true ]; then
    echo -e "${GREEN}Starting tool chaining with interlace...${NC}"
    echo -e "Input file: ${YELLOW}$INPUT_FILE${NC}"
    echo -e "Command: ${YELLOW}$COMMAND${NC}"
    echo -e "Threads: ${YELLOW}$THREADS${NC}"
    echo -e "Delay: ${YELLOW}$DELAY${NC} seconds"
fi

# Build interlace command
INTERLACE_CMD="interlace -tL \"${INPUT_FILE}\" -c \"${COMMAND}\" -threads ${THREADS} -o \"${OUTPUT_DIR}\""

# Add delay if specified
if [ "$DELAY" -gt 0 ]; then
    INTERLACE_CMD="${INTERLACE_CMD} -delay ${DELAY}"
fi

# Run interlace with timeout
if [ "$VERBOSE" = true ]; then
    echo -e "Running command: ${YELLOW}${INTERLACE_CMD}${NC}"
fi

timeout "$TIMEOUT" bash -c "$INTERLACE_CMD"

# Check if the scan was successful
if [ $? -eq 0 ]; then
    if [ "$SILENT" = false ]; then
        echo -e "${GREEN}Tool chaining completed successfully!${NC}"
        echo -e "Results saved to: ${YELLOW}$OUTPUT_DIR${NC}"
    fi
else
    echo -e "${RED}Tool chaining failed or timed out after ${TIMEOUT} seconds${NC}"
    exit 1
fi 