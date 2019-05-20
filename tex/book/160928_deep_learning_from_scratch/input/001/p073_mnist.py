import sys
sys.path.append("../../deep-learning-from-scratch")
from dataset.mnist import load_mnist  # noqa

(x_train, t_train), (x_test, t_test) = (
    load_mnist(flatten=True, normalize=False))

print(x_train.shape)  # 訓練画像
print(t_train.shape)  # 訓練ラベル
print(x_test.shape)   # テスト画像
print(t_test.shape)   # テストラベル
