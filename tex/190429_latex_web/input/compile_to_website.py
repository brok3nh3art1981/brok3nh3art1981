#!/usr/bin/python3
# texディレクトリ以下にある.texファイルらをコンパイルしてdocsディレクトリ以下に構成する。
import hashlib
import json
import os
import shutil
import subprocess
import sys

ROOT = os.path.abspath("../../..")  # texおよびdocsディレクトリの親ディレクトリ
os.chdir(ROOT)                      # カレントディレクトリを変更する


# log.txtファイルは、.pdfのパスから.texディレクトリのハッシュへの辞書である。
# すでに最新の.texディレクトリを改めてコンパイルしないためのキャッシュである。
def write_log(d):
    """辞書dをJSON形式でファイルtex/log.txtに書き込む。"""
    path = os.path.join("tex", "log.txt")  # e.g. tex/log.txt
    s = json.dumps(d)                      # JSON形式の文字列にする
    with open(path, "w") as f:             # ファイルlog.txtを開く
        f.write(s)                         # 書き込む


if "--clear" in sys.argv:  # コマンドライン引数に--clearがあればキャッシュを初期化する
    write_log({})


def f():
    """ファイルtex/log.texを読み込んで辞書として返す。"""
    path = os.path.join("tex", "log.txt")
    if not os.path.isfile(path):           # log.txtがなければ作る
        print(path + "がありません。作成します。")
        write_log({})
    with open(path) as f:
        s = f.read()
    return json.loads(s)


log = f()

# .texファイルのあるディレクトリを葉ディレクトリとして集める。
tex_dirs = []
for root, dirs, files in os.walk("tex"):
    for file in files:
        _, ext = os.path.splitext(file)
        if ext == ".tex":
            tex_dirs.append(root)
            break
print(".texファイルのあるディレクトリは以下の{}個です。{}".format(len(tex_dirs), tex_dirs))

# 既存の.pdfファイルらのパスを集める。
pdfs = set()
count = 0
for root, dirs, files in os.walk("docs"):
    for file in files:
        _, ext = os.path.splitext(file)
        path = os.path.join(root, file)
        if ext == ".pdf":
            pdfs.add(path)
        if ext == ".html":
            os.remove(path)
            count += 1
print("{}個のHTMLファイルを削除しました。".format(count))
print("既存の.pdfファイルは以下の{}個です。{}".format(len(pdfs), pdfs))


def call(xs):
    """xsの内容をprint()してから、xsをsubprocess.call()する。"""
    print("    #####BEGIN#####", " ".join(xs))
    subprocess.call(xs)
    print("    #####END#####", xs[0])


def compile(path):
    """.texファイルpathをコンパイルする。"""
    dirname = os.path.dirname(path)  # .pdfファイルや中間ファイルを生成するディレクトリ
    # call(["ptex2pdf", "-l", "-u", "-ot", '"--shell-escape -synctex=1"',
    #       path, "-output-directory", dirname])
    os.chdir(dirname)
    basename = os.path.basename(path)
    call(["ptex2pdf", "-l", "-u", "-ot",
          '"--shell-escape -synctex=1"', basename])
    os.chdir(ROOT)


def get_named(path_pdf):
    """コンパイル直後の.pdfファイルpath_pdfに対応するdocs以下での名前を返す。"""
    path_pdf = os.path.normpath(path_pdf)
    xs = path_pdf.split(os.sep)
    xs = ["docs"] + xs[1:-2] + [xs[-2] + ".pdf"]
    path_named = os.path.join(*xs)
    return path_named


def get_hash(path):
    """ファイルpathのSHA1を返す。"""
    with open(path, "rb") as f:
        bytes = f.read()
    return hashlib.sha1(bytes).hexdigest()


def get_hash_tex(path_tex):
    """.texファイルpath_texおよびその参照ディレクトリについてハッシュを返す。"""
    hash_tex = get_hash(path_tex)
    dirname = os.path.dirname(path_tex)
    dir_input = os.path.join(dirname, "input")
    if os.path.isdir(dir_input):  # 参照ディレクトリがあるか
        hashes = []               # ファイルのSHA1を集める
        for root, dirs, files in os.walk(dir_input):
            for file in files:    # それぞれのファイルについて
                path = os.path.join(root, file)
                hashes.append(get_hash(path))
        hash_tex = "-".join([hash_tex] + hashes)  # 安易に連結する
    return hash_tex


n_update = 0
n_uptodate = 0
updated = []
log_new = {}
pdfs_new = set()
for tex_dir in tex_dirs:
    listdir = os.listdir(tex_dir)  # 葉ディレクトリの中のファイルら
    for relative in listdir:
        path = os.path.join(tex_dir, relative)
        if os.path.isdir(path):  # ディレクトリは無視する
            continue
        root, ext = os.path.splitext(path)
        if ext == ".tex":  # 必ずある
            path_tex = path
            path_pdf = root + ".pdf"     # コンパイルで作られる.pdfの名前
            path_named = get_named(path_pdf)
            hash_tex = get_hash_tex(path_tex)
            break  # 最初に見つかった.texファイルのみ処理する
    if path_named in log:                # 以前にコンパイルされたことがある
        if log[path_named] == hash_tex:  # 前回のコンパイルから更新がない
            uptodate = True              # すでに最新だ
        else:
            uptodate = False
    else:
        uptodate = False
    if uptodate:
        n_uptodate += 1
    else:
        compile(path_tex)
        dirname = os.path.dirname(path_named)
        os.makedirs(dirname, exist_ok=True)
        shutil.copyfile(path_pdf, path_named)  # docsディレクトリの下にコピーする
        n_update += 1
        updated.append(os.path.basename(path_named))
    log_new[path_named] = hash_tex  # .pdfに対応する.texのSHA1を記録する
    pdfs_new.add(path_named)        # 対応する.texファイルがある.pdfファイルを記録する
write_log(log_new)
print(".texファイル{}個中{}個について.pdfファイルを更新しました。{}"
      .format(n_update+n_uptodate, n_update, updated))
# print(".texファイルに対応する.pdfファイルは以下の{}個です。{}"
#      .format(len(pdfs_new), pdfs_new));
pdfs_delete = pdfs - pdfs_new
print("削除された.pdfファイルは以下の{}個です。{}"
      .format(len(pdfs_delete), pdfs_delete))

for pdf in pdfs_delete:
    print("PDFファイルを削除します。" + pdf)
    os.remove(pdf)

for root, dirs, files in os.walk("docs", topdown=False):
    dirs = [dir for dir in dirs if os.path.isdir(os.path.join(root, dir))]
    is_leaf = dirs == []
    if is_leaf:
        has_pdf = False
        for file in files:
            _, ext = os.path.splitext(file)
            if ext == ".pdf":
                has_pdf = True
        if not has_pdf:
            for file in files:
                print("ファイルを削除します。", os.path.join(root, file))
                os.remove(os.path.join(root, file))
            print("ディレクトリを削除します。", root)
            os.rmdir(root)

# HTMLファイルらを作成する。
count = 0
for root, dirs, files in os.walk("docs"):
    dirs, files = sorted(dirs), sorted(files)
    path = os.path.join(root, "index.html")
    s = """<!doctype html>
<html>
  <head>
    <meta charset="utf-8">
  </head>
  <body>
    <h1>{}</h1>
    <ul>
""".format(root)
    for dir in dirs:
        s += ('<li><a href="{}/index.html">{}/index.html</a></li>\n'
              .format(dir, dir))
    for file in files:
        s += '<li><a href="{}">{}</a></li>\n'.format(file, file)
    s += """    </ul>
  </body>
</html>"""
    with open(path, "w") as f:
        f.write(s)
    count += 1
print("{}個のHTMLファイルを作成しました。".format(count))
