#!/usr/bin/python3
# GitHubリポジトリの履歴情報を全て削除して完全に初期化する。
import os
import re
import subprocess

test_url = "https://github.com/example/example.git"
test_email = "you@example.com"
test_name = "Your Name"

ROOT = os.path.abspath("../../..")
os.chdir(ROOT)


def f():
    """設定ファイル.git/configから項目url、email、nameの値を抜き出して返す。"""
    path = ".git"
    b = os.path.isdir(path)
    if not b:
        print("エラーです。ディレクトリ「" + path + "」がありません。終了します。")
        exit()

    path = os.path.join(".git", "config")
    b = os.path.isfile(path)
    if not b:
        print("エラーです。ファイル「" + path + "」がありません。終了します。")
        exit()
    with open(path) as f:
        s = f.read()

    m = re.search("url = (https://github.com/.*\.git)", s)
    if not m:
        print("エラーです。.git/configファイルにurlがありません。終了します。")
        exit()
    url = m.group(1)
    print("url:", url)

    m = re.search("email = (.+)", s)
    if not m:
        print("エラーです。.git/configファイルにemailがありません。終了します。")
        exit()
    email = m.group(1)
    print("email:", email)

    m = re.search("name = (.+)", s)
    if not m:
        print("エラーです。.git/configファイルにnameがありません。終了します。")
        exit()
    name = m.group(1)
    print("name:", name)
    return url, email, name


url, email, name = f()


# https://stackoverflow.com/questions/9683279/
#     make-the-current-commit-the-only-initial-commit-in-a-git-repository
def f(xs):
    """xsの内容をprint()してから、xsをsubprocess.call()する。"""
    print("#", " ".join(xs))
    subprocess.call(xs)

f(["git", "pull"])
f(["du", "-sh"])
f(["rm", "-rf", ".git"])
f(["du", "-sh"])
f(["git", "init"])
f(["git", "add", "."])
f(["git", "config", "user.email", email])
f(["git", "config", "user.name", name])
f(["git", "commit", "-m", "Initial commit"])
f(["git", "remote", "add", "origin", url])
f(["git", "push", "-u", "--force", "origin", "master"])
