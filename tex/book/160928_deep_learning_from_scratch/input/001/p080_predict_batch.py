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

batch_size = 100
count_correct = 0
count_wrong = 0
# for i in range(len(x)):
for i in range(0, len(x), batch_size):
    # y = predict(network, x[i])
    x_batch = x[i:i + batch_size]
    y_batch = predict(network, x_batch)
    # p = np.argmax(y)
    p = np.argmax(y_batch, axis=1)
    # if p == t[i]:
    #     count_correct += 1
    # else:
    #     count_wrong += 1
    count_correct += np.sum(p == t[i:i + batch_size])
    count_wrong += np.sum(p != t[i:i + batch_size])
print("count_correct:", count_correct, "count_wrong:", count_wrong)
print("Accuracy: {}".format(count_correct / len(x)))
