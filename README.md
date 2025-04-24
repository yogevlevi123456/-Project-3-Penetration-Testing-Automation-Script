🔐 Project-3: Automated Penetration Testing Script
This script automates key steps in a penetration test with interactive user input. Its main goal is to simplify scanning, enumeration, and brute-force tasks for security assessments.

Key Features:
Root Check
Ensures the script runs with root privileges; exits otherwise.

Results Directory
Prompts the user for a results folder and creates it if missing.

Password List Option
Allows using a default or custom password list for brute-force attacks. Downloads user_pass.txt if built-in list is selected.

Scan Modes: Basic or Full

Basic: Runs nmap and masscan for quick scans.

Full: Includes deep nmap scan, brute-force with medusa, CVE extraction, and searchsploit for known exploits.

Post-Scan Tools
Lets users view results, search reports with grep, or zip all outputs.

User-Friendly Interaction
Step-by-step questions guide the user through setup and execution.

Error Handling
Validates IP format and blocks non-root execution.
