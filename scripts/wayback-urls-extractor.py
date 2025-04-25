#!/usr/bin/env python3
"""
Wayback URLs Extractor - A script to extract and clean wayback URLs for a list of domains
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

class WaybackExtractor:
    def __init__(self, input_file: str, output_file: str):
        self.input_file = Path(input_file)
        self.output_file = Path(output_file)
        self.waybackurls_path = os.getenv('WAYBACKURLS_PATH', 'waybackurls')
        
        # Create output directory if it doesn't exist
        self.output_file.parent.mkdir(parents=True, exist_ok=True)
        
        # Validate input file
        if not self.input_file.exists():
            console.print(f"[red]Error: Input file {input_file} does not exist[/red]")
            sys.exit(1)

    def extract_urls(self) -> bool:
        """Extract wayback URLs for each domain in the input file"""
        try:
            # Read domains from input file
            with open(self.input_file, 'r') as f:
                domains = [line.strip() for line in f if line.strip()]
            
            console.print(Panel(f"Found {len(domains)} domains to process", title="Wayback URLs Extractor"))
            
            # Process each domain
            with open(self.output_file, 'w') as out_f:
                with Progress() as progress:
                    task = progress.add_task("[cyan]Processing domains...", total=len(domains))
                    
                    for domain in domains:
                        progress.update(task, advance=1, description=f"[cyan]Processing {domain}...")
                        
                        # Run waybackurls for the domain
                        cmd = [self.waybackurls_path, domain]
                        process = subprocess.Popen(
                            cmd,
                            stdout=subprocess.PIPE,
                            stderr=subprocess.PIPE,
                            text=True
                        )
                        
                        # Get output
                        output, error = process.communicate()
                        
                        if error:
                            console.print(f"[yellow]Warning for {domain}: {error.strip()}[/yellow]")
                        
                        # Write unique URLs to output file
                        if output:
                            out_f.write(f"# URLs for {domain}\n")
                            out_f.write(output)
                            out_f.write("\n\n")
            
            return True

        except Exception as e:
            console.print(f"[red]Error extracting URLs: {str(e)}[/red]")
            return False

def main():
    parser = argparse.ArgumentParser(description="Wayback URLs Extractor")
    parser.add_argument('-i', '--input', required=True, help='Input file with domains (one per line)')
    parser.add_argument('-o', '--output', required=True, help='Output file for wayback URLs')
    
    args = parser.parse_args()

    extractor = WaybackExtractor(args.input, args.output)
    
    console.print(Panel.fit(
        f"Starting wayback URLs extraction\nInput: {args.input}\nOutput: {args.output}",
        title="Wayback URLs Extractor",
        border_style="cyan"
    ))

    success = extractor.extract_urls()
    
    if success:
        console.print("[green]URL extraction completed successfully![/green]")
    else:
        console.print("[red]URL extraction failed![/red]")
        sys.exit(1)

if __name__ == "__main__":
    main() 