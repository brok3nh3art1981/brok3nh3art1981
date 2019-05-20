import numpy as np
import matplotlib.pyplot as plt
import mpl_toolkits.mplot3d


def function_2(x):
    return x[0]**2 + x[1]**2


x0 = np.linspace(-3, 3, 20)
x1 = np.linspace(-3, 3, 20)
X0, X1 = np.meshgrid(x0, x1)
xss = np.array([X0, X1])
Y = function_2(xss)

# plt.style.use("dark_background")
ax = plt.axes(projection=mpl_toolkits.mplot3d.Axes3D.name)
ax.set_xlabel('x0')
ax.set_ylabel('x1')
ax.set_zlabel('f(x)')
# ax.contour3D(X0, X1, Y, 50, cmap="binary")
# ax.plot_wireframe(X0, X1, Y)
ax.plot_surface(X0, X1, Y, cmap="binary")
plt.show()
