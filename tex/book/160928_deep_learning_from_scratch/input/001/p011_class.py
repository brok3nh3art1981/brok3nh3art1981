class Man:
    def __init__(self, name):  # コンストラクタ
        self.name = name       # インスタンス変数の初期化
        print("Initialized!")

    def hello(self):
        print("Hello " + self.name + "!")

    def goodbye(self):
        print("Good-bye " + self.name + "!")


m = Man("David")  # クラスManのインスタンスmを生成する
m.hello()
m.goodbye()
