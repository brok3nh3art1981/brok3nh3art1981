import numpy as np
import matplotlib.pyplot as plt


def function_1(x):
    """微分される関数の例である。"""
    return 0.01*x**2 + 0.1*x


def numerical_diff(f, x):
    """関数fの引数xにおける微分係数を中心差分による数値微分で返す。"""
    h = 1e-4  # 0.0001
    return (f(x+h) - f(x-h)) / (2*h)


x = np.arange(0, 20, 0.1)
y = function_1(x)
diff5 = numerical_diff(function_1, 5)
y5 = diff5*x + function_1(5)-5*diff5
diff10 = numerical_diff(function_1, 10)
y10 = diff10*x + function_1(10)-10*diff10
plt.xlabel("x")
plt.ylabel("f(x)")
plt.plot(x, y, label="f(x)")
plt.plot(x, y5, label="diff@5", linestyle="--")
plt.plot(x, y10, label="diff@10", linestyle="--")
plt.legend()
plt.show()
