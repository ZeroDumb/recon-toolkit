# White Hat Hacker Training Path (Weeks 1-8)

## Hacker Forward: Hygiene, Best Practices & Prerequisites

Before you start installing tools and scanning boxes like a caffeinated spider monkey, read this. Twice.

### 🔐 Digital Hygiene Checklist
- [ ] No autofill passwords in browsers (use Bitwarden or 1Password)
- [ ] Disable browser telemetry & extensions you don't trust
- [ ] Keep personal accounts separate (use different browser profiles)
- [ ] Never use real credentials on vulnerable labs
- [ ] Never run `curl | bash` unless you read the script first
- [ ] Keep personal banking, messaging, and sensitive tasks OFF your hacking machine
- [ ] Use `firejail` or Flatpak sandboxing for risky tools
- [ ] Test exploits in **VMs**, not bare metal
- [ ] Regularly backup your setup and configs
- [ ] Document everything — if you didn’t write it down, it didn’t happen

### 🧠 Best Practices
- Don’t run tools you don’t understand
- Don’t scan targets you don’t have permission to test
- Do use TryHackMe, HTB, VulnHub, or local vulnerable VMs
- Learn the protocol before you exploit the port
- Use VPNs when testing, but don’t assume they make you anonymous
- When in doubt, read the README. And the man pages. And the Arch wiki.

### ⚙️ Suggested Environment Setup
- Use separate profiles for recon and personal use
- Keep your hacking OS as minimal as possible
- Use aliases or scripts for common tasks
- Create a `~/tools/` directory for custom installs
- Version control your config files (dotfiles repo)

---

## Phase 1: Foundations & Recon (Weeks 1-4)

### **Week 1: Recon Rat King**
**Goal:** Passive and active recon to enumerate targets.

**Tools:**
- amass
- subfinder
- assetfinder
- httpx
- waybackurls

**Lab:**
- TryHackMe recon boxes OR
- Localhost with virtual hosts (edit /etc/hosts)

**Scripting / Payloads:**
```bash
subfinder -d example.com -silent | httpx -silent | tee live_subs.txt
cat live_subs.txt | while read url; do waybackurls $url; done | sort -u > archive.txt
```

**Notes Template:**
- Target:
- Subdomains:
- Live Services:
- Tech Stack Clues:
- Archived URLs:

---

### **Week 2: Brute of Fuzz**
**Goal:** Discover hidden paths, inputs, and parameters.

**Tools:**
- ffuf
- dirsearch
- gospider

**Lab:**
- DVWA / OWASP Juice Shop / TryHackMe web boxes

**Scripting / Payloads:**
```bash
ffuf -u http://localhost/FUZZ -w /usr/share/seclists/Discovery/Web-Content/common.txt -mc all
ffuf -u http://localhost/index.php?FUZZ=test -w params.txt -fs 404
gospider -s http://localhost -o spidered.txt
```

**Notes Template:**
- Paths Found:
- Parameters:
- HTTP Status Codes:
- File Types:

---

### **Week 3: Scanner General**
**Goal:** Identify misconfigs and known CVEs.

**Tools:**
- nuclei
- nmap
- dnsx
- masscan (careful)
- dalfox

**Lab:**
- Local services + Vulhub
- TryHackMe vuln boxes

**Scripting / Payloads:**
```bash
nuclei -l live_subs.txt -t cves/ -o nuclei-results.txt
dalfox url http://localhost/comment.php -o xss.txt
```

**Notes Template:**
- CVEs Identified:
- Open Ports:
- Banner Details:
- HTTP Headers:
- Exploit Potential:

---

### **Week 4: Manual Menace**
**Goal:** Live interaction, interception, and validation.

**Tools:**
- Burp Suite
- ZAP
- sqlmap
- xsstrike
- interlace

**Lab:**
- DVWA or Juice Shop
- Custom vulnerable login page
- TryHackMe or HTB boxes

**Scripting / Payloads:**
```bash
interlace -tL urls.txt -c "sqlmap -u _target_ --batch --risk=2 --level=5"
xsstrike -u "http://localhost/index.php?q=" -f payloads.txt
```

**Notes Template:**
- Injection Points:
- Proxy Capture:
- Custom Headers:
- Script Chains:
- Exploit Path:

---

## Phase 2: Deeper Dive (Weeks 5-8 — Tentative Planning)

### **Week 5: Post-Exploitation & Privilege Escalation**
- LinPEAS / WinPEAS
- GTFOBins
- SUID hunting
- Kernel exploit basics

### **Week 6: Payload Crafting & Obfuscation**
- Custom payloads
- Encoding techniques
- AV evasion basics
- `msfvenom` (in sandbox only)

### **Week 7: Intro to Red Teaming & C2**
- Sliver / Covenant
- Empire (lab only)
- Persistence techniques
- Lateral movement theory

### **Week 8: Reporting & Ethical Disclosure**
- How to write a vuln report
- Disclosure frameworks (Bugcrowd, HackerOne)
- Communication strategies
- Public writeups & blogs

---

> This doc is your roadmap. Each week builds practical knowledge, muscle memory, and intuition. You won't just use tools—you'll *understand* the systems they reveal.

Stay curious. Stay ethical. Break everything *responsibly.*

