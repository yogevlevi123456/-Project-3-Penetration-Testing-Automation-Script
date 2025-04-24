🛡️ Project-3: Automated Penetration Testing Script
A user-guided Bash script designed to automate essential penetration testing tasks like scanning, enumeration, and brute-force attacks.

🔑 Core Features:
1️⃣ 👤 Root Check
Ensures the script runs with root privileges. Exits if not.

2️⃣ 📁 Results Directory Setup
Asks for a folder to store results — creates it if it doesn’t exist.

3️⃣ 🔐 Password List Selection
Choose between a built-in password list (downloaded from GitHub) or a custom one.

4️⃣ 🔍 Scan Modes: Basic or Full

🧪 Basic: Quick nmap + masscan scans.

🛠️ Full: Deep nmap scan, medusa brute-force, CVE extraction + searchsploit.

5️⃣ 📄 Post-Scan Options
View files, search with grep, or zip all results.

6️⃣ 💬 Interactive Flow
Prompts the user at each step (e.g., IP address, scan type, continue?).

7️⃣ ⚠️ Error Handling
Validates IP format and blocks non-root users.

