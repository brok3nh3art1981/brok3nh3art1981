# p. 41
import sys
sys.path.append('..')  # 親ディレクトリのファイルをインポートするための設定
from dataset import spiral
import matplotlib.pyplot as plt


x, t = spiral.load_data()
print('x', x.shape)  # (300, 2); 300個の平面座標データ
print('t', t.shape)  # (300, 3); 300個の3クラスone-hot表現正解データ

# plt.style.use('dark_background')
# データ点のプロット
# これらNとCLS_NUMの値が偶然dataset.spiralの実装と一致してるから動く
N = 100
CLS_NUM = 3
markers = ['o', 'x', '^']  # データのクラスの記号の形
for i in range(CLS_NUM):   # 各クラスについて。クラスごとに描画する。
    plt.scatter(x[i*N:(i+1)*N, 0],  # このクラスの範囲の第0列つまりx座標らを抽出
                x[i*N:(i+1)*N, 1],  # このクラスの範囲の第1列つまりy座標らを抽出
                s=40,  # 点を描く大きさ
                marker=markers[i])
plt.show()
