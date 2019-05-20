import numpy as np
import pickle
import sys
sys.path.append("../../deep-learning-from-scratch")
from dataset.mnist import load_mnist  # noqa


def get_data():
    """MNIST Databaseのテスト用データを返す。"""
    (x_train, t_train), (x_test, t_test) = (
        load_mnist(normalize=True, flatten=True, one_hot_label=False))
    return x_test, t_test


def init_network():
    """学習済みのパラメータを読み込む。"""
    path = "../../deep-learning-from-scratch/ch03/sample_weight.pkl"
    with open(path, "rb") as f:
        network = pickle.load(f)
    return network


def predict(network, x):
    """重みnetworkと入力ベクトルxから出力ベクトルyを得る。"""
    W1, W2, W3 = network["W1"], network["W2"], network["W3"]
    b1, b2, b3 = network["b1"], network["b2"], network["b3"]

    a1 = np.dot(x, W1) + b1

    def sigmoid(x):
        return 1 / (1 + np.exp(-x))

    z1 = sigmoid(a1)
    a2 = np.dot(z1, W2) + b2
    z2 = sigmoid(a2)
    a3 = np.dot(z2, W3) + b3

    def softmax(x):
        max_ = np.max(x)
        x -= max_
        exp_ = np.exp(x)
        sum_ = np.sum(exp_)
        return exp_ / sum_

    y = softmax(a3)
    return y


x, t = get_data()
network = init_network()
# with open("del.txt", "w") as f:
#     np.set_printoptions(threshold=np.inf)
#     f.write(str(network))

count_correct = 0
count_wrong = 0
for i in range(len(x)):
    y = predict(network, x[i])
    p = np.argmax(y)
    if p == t[i]:
        count_correct += 1
    else:
        count_wrong += 1
print("count_correct:", count_correct, "count_wrong:", count_wrong)
print("Accuracy: {}".format(count_correct / len(x)))
