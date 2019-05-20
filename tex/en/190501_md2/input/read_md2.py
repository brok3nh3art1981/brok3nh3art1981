import array
import collections
import struct
path = "sydney.md2"
with open(path, mode="rb") as f:
    bytes=f.read()
values = struct.unpack_from(17*"I", bytes, 0)
ofs = 17*4
keys = ("ident version skinwidth skinheight framesize num_skins num_xyz "
        "num_st num_tris num_glcmds num_frames ofs_skins ofs_st ofs_tris "
        "ofs_frames ofs_glcmds ofs_end").split()
d = collections.OrderedDict(zip(keys, values))
desc = {}
desc["ident"]      = '識別子。必ず"IDP2"(844121161)。'
desc["version"]    = "必ず8"
desc["skinwidth"]  = "テクスチャの幅"
desc["skinheight"] = "テクスチャの高さ"
desc["framesize"]  = "1つのフレームのバイトサイズ"
desc["num_skins"]  = "テクスチャの数"
desc["num_xyz"]    = "頂点の数"
desc["num_st"]     = "テクスチャ座標の数"
desc["num_tris"]   = "三角形の数"
desc["num_glcmds"] = "OpenGLコマンドの数"
desc["num_frames"] = "フレームの合計個数"
desc["ofs_skins"]  = "スキン名らのオフセット"
desc["ofs_st"]     = "s-tテクスチャ座標へのオフセット"
desc["ofs_tris"]   = "三角形らへのオフセット"
desc["ofs_frames"] = "フレームのデータへのオフセット"
desc["ofs_glcmds"] = "OpenGLコマンドらへのオフセット"
desc["ofs_end"]    = "ファイル終端へのオフセット"
for k, v in d.items():
    s = "  " + desc[k] if k in desc else ""
    print("{:<10}{:>15}{}".format(k, v, s))

ss = []
ts = []
for i in range(d["num_st"]):  # テクスチャ座標ら
    s, t = struct.unpack_from("hh", bytes, ofs)
    ss.append(s)
    ts.append(t)
    # print("st{}_{}_{} ".format(i, s, t), end="")
    ofs += 2*2
print("ofs=", ofs)
def f():
    """テクスチャ座標らを散布図としてプロットする。"""
    import matplotlib.pyplot as plt
    plt.scatter(ss, ts)
    plt.show()
# f()

for i in range(d["num_tris"]):  # 三角形ら
    xs = struct.unpack_from("3h3h", bytes, ofs)
    vertexindex = xs[0:3]   # 3つの頂点それぞれの頂点ID
    textureindex = xs[3:6]  # 3つの頂点それぞれのテクスチャ座標ID
    # print(vertexindex, textureindex)
    ofs += 3*2 + 3*2
print("ofs=", ofs)

for i in range(d["num_frames"]):  # キーフレームら
    xs = struct.unpack_from("3f3f16c", bytes, ofs)
    scale = xs[0:3]
    translate = xs[3:6]
    name = b"".join(xs[6:]).decode("utf-8").strip("\0")
    # print(scale, translate, name)
    ofs += 3*4 + 3*4 + 16*1
    for j in range(d["num_xyz"]):
        xs = struct.unpack_from("3BB", bytes, ofs)
        v = xs[0:3]
        lightnormalindex = xs[3]
        # print(v, lightnormalindex)
        ofs += 3*1 + 1
print("ofs=", ofs)

i_primitive = 0
# for i in range(d["num_glcmds"]):
while True:  # OpenGLコマンドら
    n_vertices, = struct.unpack_from("i", bytes, ofs)
    ofs += 4
    if n_vertices == 0:
        break
    if n_vertices > 0:
        primitive = "GL_TRIANGLE_STRIP"
    else:
        primitive = "GL_TRIANGLE_FAN"
    n_vertices = abs(n_vertices)
    # print(i_primitive, n_vertices, primitive)
    for j in range(n_vertices):
        s, t, index = struct.unpack_from("ffI", bytes, ofs)
        # print("   ", s, t, index)
        ofs += 3*4
    i_primitive += 1
print("ofs=", ofs)
