import numpy as np
from PIL import Image
import sys
sys.path.append("../../deep-learning-from-scratch")
from dataset.mnist import load_mnist  # noqa


def image_show(img):
    pil_img = Image.fromarray(np.uint8(img))
    pil_img.show()


(x_train, t_train), (x_test, t_test) = (
    load_mnist(flatten=True, normalize=False))
img = x_train[0]
label = t_train[0]
print(label)

print(img.shape)
img = img.reshape(28, 28)
print(img.shape)


def print_as_characters(img):
    for row in img:
        for col in row:
            c = "#" if col >= 128 else "."
            print(c, end="")
        print()


print_as_characters(img)
image_show(img)
