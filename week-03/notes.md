## WEEK 3: The Scanner General
**Goal: Identify known vulnerabilities using structured, efficient scanning. Replace brute force with surgical strikes.**

Tools:
```nuclei ```
```nmap ```
```dnsx ```
```masscan ``` (carefully, locally only)
```dalfox ```

Lab:
- Use a local vulnerable web app + open ports

- Test custom-built dummy services on your SurfaceBook VM

- Optionally, use vulhub or TryHackMe vulnerability boxes

What to Learn:
- Using templates with nuclei

- Writing custom nuclei YAMLs

- Scanning networks

- Targeted XSS testing

# Payloads/Scripting:
Nuclei run:

``` bash 
nuclei -l live_subs.txt -t cves/ -o nuclei-results.txt 

```
Dalfox single page test:

``` bash 
dalfox url http://localhost/comment.php -o xss.txt 
```

Custom scanner launcher script:

``` bash

#!/bin/bash
for url in $(cat live.txt); do
  nuclei -u $url -t technologies/ -o tech_scan_$url.txt
done

```
# Notes Template:
Tool used:

Templates fired:

Ports open:

CVEs found:

Observed headers/misconfigs: