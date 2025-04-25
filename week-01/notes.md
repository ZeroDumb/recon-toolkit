##WEEK 1: The Recon Rat King
**Goal: Learn how to find, map, and understand a target without touching it. The stalker phase. Quiet, subtle, 100% legal.**

Tools:
```amass```
```subfinder```
```assetfinder```
```httpx ```
```waybackurls```

#Lab:
Use a TryHackMe box with multiple domains, or spin up an NGINX server on localhost with multiple virtual hosts (e.g., dev.local, admin.local, etc.)

Register dummy domains in /etc/hosts

What to Learn:
How to enumerate subdomains

How to validate live services

What archived URLs tell you about broken/old functionality

Payloads/Scripting:
Bash one-liner to chain recon tools:


```bash 
subfinder -d example.com -silent | httpx -silent | tee live_subs.txt 
```

Notes:
Script to pull and clean wayback URLs:


```bash 
cat live_subs.txt | while read url; do waybackurls $url; done | sort -u > archive.txt 
```

Notes Template:
Target:

Subdomains:

Live Services:

Tech Stack Clues:

Suspicious Archived URLs:

