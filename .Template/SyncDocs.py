#!/usr/bin/env python3
# 自动同步文档到公开仓库（SSH 认证）

import os, shutil, stat, subprocess, sys
from pathlib import Path

PUBLIC_REPO_SSH = "git@github.com:MZSH-UEPlugins/UEPluginDocs.git"
PUBLIC_REPO_BRANCH = "main"


def remove_readonly(func, path, _):
    os.chmod(path, stat.S_IWRITE)
    func(path)


def run_cmd(cmd, cwd=None, check=True):
    print(f"Running: {' '.join(cmd)}")
    result = subprocess.run(cmd, cwd=cwd, capture_output=True, text=True, encoding='utf-8', errors='ignore')
    if check and result.returncode != 0:
        print(f"ERROR: {result.stderr}\nOUTPUT: {result.stdout}")
        sys.exit(1)
    return result

def is_template_repo():
    """检查当前仓库是否为 GitHub 模板仓库"""
    try:
        # 获取远程仓库 URL
        result = subprocess.run(
            ["git", "remote", "get-url", "origin"],
            capture_output=True, text=True, encoding='utf-8', errors='ignore'
        )
        if result.returncode != 0 or not result.stdout.strip():
            print("No remote origin found, skip sync")
            return True

        remote_url = result.stdout.strip()
        # 解析 owner/repo（支持 SSH 和 HTTPS 格式）
        if "github.com" not in remote_url:
            print("Not a GitHub repo, skip sync")
            return True

        if remote_url.startswith("git@"):
            # git@github.com:owner/repo.git
            repo_path = remote_url.split(":")[-1].replace(".git", "")
        else:
            # https://github.com/owner/repo.git
            repo_path = remote_url.split("github.com/")[-1].replace(".git", "")

        # 调用 GitHub API 检查是否为模板仓库
        result = subprocess.run(
            ["gh", "api", f"repos/{repo_path}", "--jq", ".is_template"],
            capture_output=True, text=True, encoding='utf-8', errors='ignore'
        )
        if result.returncode != 0:
            print(f"Failed to query GitHub API, skip sync")
            return True

        if result.stdout.strip() == "true":
            print("Template repo detected, skip sync")
            return True

        return False
    except Exception as e:
        print(f"Error checking repo: {e}, skip sync")
        return True


def main():
    script_dir = Path(__file__).parent.absolute()
    project_root = script_dir.parent if script_dir.name == ".Template" else script_dir
    project_name = project_root.name
    docs_path = project_root / "Docs"
    temp_dir = project_root / ".temp-sync"

    print(f"Project: {project_name} ({project_root})")

    if is_template_repo():
        return

    if not docs_path.exists():
        print(f"ERROR: Docs not found at {docs_path}")
        sys.exit(1)

    if temp_dir.exists():
        shutil.rmtree(temp_dir, onerror=remove_readonly)
    temp_dir.mkdir()

    try:
        print("\nCloning public repository...")
        run_cmd(["git", "clone", "--depth", "1", "-b", PUBLIC_REPO_BRANCH, PUBLIC_REPO_SSH, str(temp_dir / "repo")])

        repo_dir = temp_dir / "repo"
        target_dir = repo_dir / project_name
        target_dir.mkdir(parents=True, exist_ok=True)

        # 清空目标目录
        for item in target_dir.iterdir():
            (shutil.rmtree if item.is_dir() else os.unlink)(item)

        # 复制 Docs 内容
        print("\nCopying Docs...")
        for item in docs_path.iterdir():
            dest = target_dir / item.name
            (shutil.copytree if item.is_dir() else shutil.copy2)(item, dest)
            print(f"  {item.name}{'/' if item.is_dir() else ''}")

        # 提交推送
        print("\nCommitting...")
        run_cmd(["git", "config", "user.name", "Auto Sync"], cwd=repo_dir)
        run_cmd(["git", "config", "user.email", "mengzhishanghun@users.noreply.github.com"], cwd=repo_dir)
        run_cmd(["git", "add", "."], cwd=repo_dir)

        status = run_cmd(["git", "status", "--porcelain"], cwd=repo_dir, check=False)
        if not status.stdout.strip():
            print("\nNo changes, skip sync")
        else:
            run_cmd(["git", "commit", "-m", f"Update docs for {project_name}"], cwd=repo_dir)
            run_cmd(["git", "push"], cwd=repo_dir)
            print(f"\nSUCCESS! https://github.com/MZSH-UEPlugins/UEPluginDocs/tree/main/{project_name}")

    except Exception as e:
        import traceback
        print(f"\nEXCEPTION: {e}")
        traceback.print_exc()
        sys.exit(1)
    finally:
        print("\nCleaning up...")
        if temp_dir.exists():
            shutil.rmtree(temp_dir, onerror=remove_readonly, ignore_errors=True)

    print("Done!")

if __name__ == "__main__":
    main()
