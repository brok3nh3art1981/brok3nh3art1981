import numpy as np
import matplotlib.cm
import matplotlib.pyplot as plt
import mpl_toolkits.mplot3d


def f(x1, x2):
    return 0.5*x1 + 0.5*x2


x1 = np.linspace(0, 1, 100)
x2 = np.linspace(0, 1, 100)
X1, X2 = np.meshgrid(x1, x2)
Y = f(X1, X2)

fig = plt.figure()
ax = plt.axes(projection=mpl_toolkits.mplot3d.Axes3D.name)
ax.set_title("y = 0.5*x1 + 0.5*x2")
ax.set_xlabel('x1')
ax.set_ylabel('x2')
ax.set_zlabel('y')
cmap = matplotlib.cm.get_cmap('binary')
cmap.set_over('r')
ax.contour3D(X1, X2, Y, 50, cmap=cmap, vmax=0.7)
fig.savefig("output.pdf", bbox_inches='tight')
plt.show()
