#!/usr/bin/env python3
"""
Auto sync documentation to public repository
Uses SSH authentication, no token needed
"""

import os
import shutil
import stat
import subprocess
import sys
from pathlib import Path


def remove_readonly(func, path, _):
    """Handle readonly files on Windows"""
    os.chmod(path, stat.S_IWRITE)
    func(path)


# Config
PUBLIC_REPO_SSH = "git@github.com:MZSH-UEPlugins/UEPluginDocs.git"
PUBLIC_REPO_BRANCH = "main"

def run_command(cmd, cwd=None, check=True):
    """Execute command"""
    print(f"Running: {' '.join(cmd)}")
    result = subprocess.run(cmd, cwd=cwd, capture_output=True, text=True, encoding='utf-8', errors='ignore')
    if check and result.returncode != 0:
        print(f"ERROR: {result.stderr}")
        print(f"OUTPUT: {result.stdout}")
        sys.exit(1)
    return result

def main():
    # Get project root (parent of .Template)
    script_dir = Path(__file__).parent.absolute()
    project_root = script_dir.parent if script_dir.name == ".Template" else script_dir
    project_name = project_root.name

    print(f"Project detected: {project_name}")
    print(f"Project root: {project_root}")

    # Check Docs
    docs_path = project_root / "Docs"

    if not docs_path.exists():
        print(f"ERROR: Docs directory not found at {docs_path}")
        sys.exit(1)

    # Create temp directory
    temp_dir = project_root / ".temp-sync"
    if temp_dir.exists():
        print(f"Cleaning old temp directory...")
        shutil.rmtree(temp_dir, onerror=remove_readonly)
    temp_dir.mkdir()

    try:
        # Clone public repo
        print("\nCloning public repository...")
        run_command(["git", "clone", "--depth", "1", "-b", PUBLIC_REPO_BRANCH, PUBLIC_REPO_SSH, str(temp_dir / "repo")])

        repo_dir = temp_dir / "repo"
        target_dir = repo_dir / project_name

        # Create target directory
        print(f"Creating target directory: {target_dir}")
        target_dir.mkdir(parents=True, exist_ok=True)

        # Remove all old content in target directory
        for item in target_dir.iterdir():
            if item.is_file():
                item.unlink()
            elif item.is_dir():
                shutil.rmtree(item)

        # Copy Docs content directly to target directory (flatten)
        print("\nCopying Docs content...")
        for item in docs_path.iterdir():
            if item.is_file():
                shutil.copy2(item, target_dir / item.name)
                print(f"  Copied: {item.name}")
            elif item.is_dir():
                shutil.copytree(item, target_dir / item.name)
                print(f"  Copied: {item.name}/")

        # Commit and push
        print("\nCommitting changes...")
        run_command(["git", "config", "user.name", "Auto Sync"], cwd=repo_dir)
        run_command(["git", "config", "user.email", "mengzhishanghun@users.noreply.github.com"], cwd=repo_dir)
        run_command(["git", "add", "."], cwd=repo_dir)

        # Check for changes
        status = run_command(["git", "status", "--porcelain"], cwd=repo_dir, check=False)
        if not status.stdout.strip():
            print("\nNo documentation changes, skip sync")
        else:
            print("Changes detected, committing...")
            run_command(["git", "commit", "-m", f"Update docs for {project_name}"], cwd=repo_dir)
            print("Pushing to remote...")
            run_command(["git", "push"], cwd=repo_dir)
            print(f"\nSUCCESS! Docs synced to:")
            print(f"https://github.com/MZSH-UEPlugins/UEPluginDocs/tree/main/{project_name}")

    except Exception as e:
        print(f"\nEXCEPTION: {str(e)}")
        import traceback
        traceback.print_exc()
        sys.exit(1)
    finally:
        # Cleanup temp directory
        print("\nCleaning up temp files...")
        if temp_dir.exists():
            try:
                shutil.rmtree(temp_dir, onerror=remove_readonly)
            except Exception as e:
                print(f"Warning: Failed to cleanup temp dir: {e}")

    print("\nDone!")

if __name__ == "__main__":
    main()
