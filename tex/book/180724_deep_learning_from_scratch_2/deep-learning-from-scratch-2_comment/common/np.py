# coding: utf-8
from common.config import GPU


if GPU:  # 変数GPUはconfig.pyでデフォルトでFalseとして定義されている。
    import cupy as np  # Prefered Networksによるnumpy互換GPUライブラリ。
    np.cuda.set_allocator(np.cuda.MemoryPool().malloc)
    np.add.at = np.scatter_add

    print('\033[92m' + '-' * 60 + '\033[0m')    # 単に修飾する
    print(' ' * 23 + '\033[92mGPU Mode (cupy)\033[0m')  # GPUモード
    print('\033[92m' + '-' * 60 + '\033[0m\n')  # 単に修飾する
else:
    import numpy as np  # 普通npと言えばこれである。
