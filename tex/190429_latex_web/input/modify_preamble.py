#!/usr/bin/python3
# .texファイルの通称プリアンブルについて自動処理する。

import os
import re

ROOT = os.path.abspath("../../..")  # texおよびdocsディレクトリの親ディレクトリ
os.chdir(ROOT)


templates = {}
templates["1"] = r"""
\documentclass[uplatex,dvipdfmx]{jsarticle} \usepackage{amsmath,amssymb,bm}
\usepackage{verbatim} \usepackage{svg} \usepackage{graphicx}
\usepackage[dvipdfmx]{hyperref} \usepackage{pxjahyper}
\usepackage{paracol} \usepackage{threeparttable}
\usepackage{seqsplit}"""[1:]
pattern = r"%TEMPLATE-BEGIN (.*?)\n(.*?)\n%TEMPLATE-END"
compiled = re.compile(pattern, re.MULTILINE | re.DOTALL)
sub = r"%TEMPLATE-BEGIN {}\n{}\n%TEMPLATE-END"


def is_tex(path):
    """ファイルpathが実在して（拡張子が）.texファイルなら真を返す。"""
    isfile = os.path.isfile(path)       # 存在するか
    root, ext = os.path.splitext(path)  # 拡張子を得る
    return isfile and ext == ".tex"


def has_template(path):
    """.texファイルpathにテンプレートの記載がなければ偽を返す。
    もしあればテンプレート名、内容、マッチ全体を返す。"""
    with open(path) as f:
        s = f.read()
    match = compiled.search(s)  # テンプレートの記載を探す
    if match is None:           # テンプレートの記載がない
        return False
    name = match.group(1)       # テンプレート名
    text = match.group(2)       # テンプレートの既存の内容
    return name, text, match.group()


def is_uptodate(text, name):
    """テンプレート内容textがテンプレート名nameのものとして最新なら真を返す。"""
    return templates[name] == text


def update_template(path, name):
    """.texファイルpathをテンプレート名nameのテンプレートに更新する。"""
    with open(path) as f:
        src = f.read()
    text = templates[name]
    new = sub.format(name, text)
    dst = re.sub(compiled, new, src)
    with open(path, "w") as f:
        f.write(dst)
    inc = len(dst) - len(src)  # increase.
    print("{}のテンプレートを更新しました。文字数の差は{}です。".format(path, inc))


def do_file(path):
    """ファイルpathについて必要ならテンプレートを更新する。"""
    if not is_tex(path):         # .texファイルではない
        return False
    response = has_template(path)
    if response is False:        # テンプレート部分がない
        return False
    name, text, match = response
    if is_uptodate(text, name):  # テンプレート内容がすでに最新だ
        return "uptodate"
    update_template(path, name)  # ファイルデータを更新する
    return "updated"


def get_paths_tex():
    """存在する.texファイルのパスのリストを返す。"""
    paths = []
    for root, dirs, files in os.walk("tex"):  # 各ディレクトリについて
        for file in files:                    # ディレクトリ直下の各ファイルについて
            _, ext = os.path.splitext(file)
            if ext == ".tex":                 # 拡張子が.texである
                path = os.path.join(root, file)
                paths.append(path)
    return paths


def main():
    """存在する.texファイルらのテンプレートを更新する。"""
    paths = get_paths_tex()
    print("{}個の.texファイルがあります。".format(len(paths)))
    n_update = 0
    n_uptodate = 0
    for path in paths:
        response = do_file(path)
        if response == "updated":
            n_update += 1
        elif response == "uptodate":
            n_uptodate += 1
    print("{}個のファイルはすでに最新です。".format(n_uptodate))
    print("{}個のファイルを更新しました。".format(n_update))


if __name__ == "__main__":
    main()
