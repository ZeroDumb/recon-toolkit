## WEEK 2: The Brute of Fuzz
**Goal: Discover hidden files, parameters, and juicy inputs with brute force + patterns. Learn what most devs forgot to lock up.**

Tools:
```ffuf ```
```gospider ```
```dirsearch ```


Lab:
DVWA (Damn Vulnerable Web App)

OWASP Juice Shop

Or use a TryHackMe web-focused challenge

What to Learn:
Directory fuzzing

Parameter discovery

Crawling + filtering responses

Wordlists (SecLists is your holy book)

# Payloads/Scripting:
Fuzz hidden dirs:

```bash 

ffuf -u http://localhost/FUZZ -w /usr/share/seclists/Discovery/Web-Content/common.txt -mc all 
```

Parameter brute-forcing:

```bash 
ffuf -u http://localhost/index.php?FUZZ=test -w params.txt -fs 404 
```

Auto-crawl and scan:


```bash 
gospider -s http://localhost -o spidered.txt 
```

Notes Template:
Path found:

Parameters detected:

Files exposed:

Response patterns (status, size):

Weird behavior on fuzz: