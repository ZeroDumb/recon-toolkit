# 🛠️ Recon Toolkit Scripts

This directory contains automation scripts for various recon and security testing tasks.

## 📋 Scripts Overview

### `nuclei-payload-runner.py`
A Python script to automate running Nuclei scans with custom templates and configurations.
- Supports custom template directories
- Configurable scan options
- Output formatting and reporting
- Rate limiting and concurrent scan management

### `quick-subfinder.sh`
A bash script wrapper for Subfinder to automate subdomain enumeration.
- Quick subdomain discovery
- Custom output formats
- Integration with other tools
- Configurable search options

### `ffuf-launcher.sh`
A bash script wrapper for FFuf to automate directory and content discovery.
- Custom wordlist support
- Output formatting
- Rate limiting
- Common scan patterns

### `wayback-urls-extractor.py`
A Python script to extract and clean wayback URLs for a list of domains.
- Processes multiple domains from an input file
- Extracts historical URLs from Wayback Machine
- Organizes results by domain
- Progress tracking and error handling

### `parameter-fuzzer.sh`
A bash script for parameter discovery and fuzzing.
- Parameter name discovery
- Custom wordlist support
- HTTP method selection
- Response filtering by status code and size

### `dalfox-launcher.sh`
A bash script for XSS testing with dalfox.
- URL and domain scanning
- Custom payload support
- Blind XSS testing
- Proxy integration

### `interlace-wrapper.sh`
A bash script for chaining tools with interlace.
- Tool command automation
- Multi-threading support
- Rate limiting
- Output organization

## 🚀 Usage

### Nuclei Payload Runner
```bash
python3 nuclei-payload-runner.py -t templates/ -u target.com -o results/
```

### Quick Subfinder
```bash
./quick-subfinder.sh -d target.com -o subdomains.txt
```

### FFuf Launcher
```bash
./ffuf-launcher.sh -u https://target.com -w wordlist.txt -o results/
```

### Wayback URLs Extractor
```bash
python3 wayback-urls-extractor.py -i domains.txt -o wayback_urls.txt
```

### Parameter Fuzzer
```bash
./parameter-fuzzer.sh -u https://target.com/search?q=test -w params.txt -m GET -f 200,301
```

### Dalfox Launcher
```bash
./dalfox-launcher.sh -u https://target.com/search?q=test -o xss.txt -p payloads.txt
```

### Interlace Wrapper
```bash
./interlace-wrapper.sh -i urls.txt -c "sqlmap -u _target_ --batch --risk=2 --level=5"
```

## ⚙️ Configuration
- Environment variables can be set in `.env` file
- Default configurations are in each script
- Custom templates and wordlists can be added to respective directories

## 🔒 Security Note
These scripts are for authorized testing only. Always ensure you have proper permissions before running any scans.
