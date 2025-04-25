#!/usr/bin/env python3
"""
Nuclei Payload Runner - A script to automate Nuclei scans with custom templates
"""

import os
import sys
import argparse
import subprocess
from pathlib import Path
from typing import List, Optional
from dotenv import load_dotenv
from rich.console import Console
from rich.progress import Progress
from rich.panel import Panel

# Load environment variables
load_dotenv()

# Initialize Rich console
console = Console()

class NucleiRunner:
    def __init__(self, templates_dir: str, target: str, output_dir: str):
        self.templates_dir = Path(templates_dir)
        self.target = target
        self.output_dir = Path(output_dir)
        self.nuclei_path = os.getenv('NUCLEI_PATH', 'nuclei')
        
        # Create output directory if it doesn't exist
        self.output_dir.mkdir(parents=True, exist_ok=True)
        
        # Validate templates directory
        if not self.templates_dir.exists():
            console.print(f"[red]Error: Templates directory {templates_dir} does not exist[/red]")
            sys.exit(1)

    def validate_target(self) -> bool:
        """Validate the target URL/domain"""
        # Add your target validation logic here
        return True

    def run_scan(self, template: Optional[str] = None) -> bool:
        """Run Nuclei scan with specified template"""
        try:
            cmd = [
                self.nuclei_path,
                '-target', self.target,
                '-o', str(self.output_dir / f"scan_{template or 'all'}.json"),
                '-json'
            ]

            if template:
                cmd.extend(['-t', str(self.templates_dir / template)])
            else:
                cmd.extend(['-t', str(self.templates_dir)])

            # Add rate limiting if configured
            if os.getenv('NUCLEI_RATE_LIMIT'):
                cmd.extend(['-rate-limit', os.getenv('NUCLEI_RATE_LIMIT')])

            console.print(Panel(f"Running scan with command: {' '.join(cmd)}", title="Nuclei Scan"))
            
            process = subprocess.Popen(
                cmd,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                text=True
            )

            with Progress() as progress:
                task = progress.add_task("[cyan]Scanning...", total=None)
                
                while True:
                    output = process.stdout.readline()
                    if output == '' and process.poll() is not None:
                        break
                    if output:
                        console.print(output.strip())

            return process.returncode == 0

        except Exception as e:
            console.print(f"[red]Error running scan: {str(e)}[/red]")
            return False

def main():
    parser = argparse.ArgumentParser(description="Nuclei Payload Runner")
    parser.add_argument('-t', '--templates', required=True, help='Path to templates directory')
    parser.add_argument('-u', '--target', required=True, help='Target URL or domain')
    parser.add_argument('-o', '--output', required=True, help='Output directory')
    parser.add_argument('--template', help='Specific template to use')
    
    args = parser.parse_args()

    runner = NucleiRunner(args.templates, args.target, args.output)
    
    if not runner.validate_target():
        console.print("[red]Invalid target specified[/red]")
        sys.exit(1)

    console.print(Panel.fit(
        f"Starting Nuclei scan\nTarget: {args.target}\nTemplates: {args.templates}",
        title="Nuclei Payload Runner",
        border_style="cyan"
    ))

    success = runner.run_scan(args.template)
    
    if success:
        console.print("[green]Scan completed successfully![/green]")
    else:
        console.print("[red]Scan failed![/red]")
        sys.exit(1)

if __name__ == "__main__":
    main()
