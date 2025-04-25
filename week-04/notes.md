## WEEK 4: The Manual Menace
**Goal: Shift from automation to precision. Use proxies, inspect traffic, test logic, and start scripting basic exploits.**

Tools:
```Burp Suite```
```ZAP Proxy```
```sqlmap```
```xsstrike```
```interlace``` (for chaining scripts)

Lab:
Any TryHackMe or Hack The Box machine marked "Easy–Medium"

Local instance of DVWA or Juice Shop

Create your own challenge with a bad login + known SQLi

What to Learn:
Setting up a proxy (Burp/ZAP)

Repeating requests manually

Testing injection points

Chaining tools into attack flows

Payloads/Scripting:
Interlace wrapper:

```bash
interlace -tL urls.txt -c "sqlmap -u _target_ --batch --risk=2 --level=5"
```
- XSStrike attack with payload file:

```bash
xsstrike -u "http://localhost/index.php?q=" -f payloads.txt
```
Basic Burp macro + custom header attack (hands-on work)

Notes Template:
Injection points:

Payloads tested:

Proxy workflow:

Anomalies/responses:

Final exploit path: