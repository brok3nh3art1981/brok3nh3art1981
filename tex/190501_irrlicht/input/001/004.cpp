#include <irrlicht/irrlicht.h>
using namespace irr;
using namespace irr::core;
using namespace irr::scene;
using namespace irr::video;
using namespace irr::io;
using namespace irr::gui;
class CSampleSceneNode : public ISceneNode {
    aabbox3d<f32> Box;  // Axially Aligned Bounding Box (AABB)
    S3DVertex Vertices[4];
    SMaterial Material;
public:
    // コンストラクタ。まず親クラスのコンストラクタを呼ぶ。
    CSampleSceneNode(ISceneNode* p, ISceneManager* m, s32 id) : ISceneNode(p, m, id) {
        Material.Wireframe = false;
        Material.Lighting = false;
        // S3DVertex(位置, 法線ベクトル, 色, テクスチャ座標); 正四面体ではない。
        /*Vertices[0] = S3DVertex(0,0,10,    1,1,0, SColor(255,0,255,255), 0, 1);  // シアン
        Vertices[1] = S3DVertex(10,0,-10,  1,0,0, SColor(255,255,0,255), 1, 1);  // マゼンタ
        Vertices[2] = S3DVertex(0,20,0,    0,1,1, SColor(255,255,255,0), 1, 0);  // イエロー
        Vertices[3] = S3DVertex(-10,0,-10, 0,0,1, SColor(255,0,255,0),   0, 0);  // グリーン*/
        // 正四面体とする。
        Vertices[0] = S3DVertex( 10,-10, 10, 1,1,0, SColor(255,0,255,255), 0, 1);  // シアン
        Vertices[1] = S3DVertex( 10, 10,-10, 1,0,0, SColor(255,255,0,255), 1, 1);  // マゼンタ
        Vertices[2] = S3DVertex(-10, 10, 10, 0,1,1, SColor(255,255,255,0), 1, 0);  // イエロー
        Vertices[3] = S3DVertex(-10,-10,-10, 0,0,1, SColor(255,0,255,0),   0, 0);  // グリーン
        Box.reset(Vertices[0].Pos);  // AABBを1点で初期化
        for(s32 i=1; i<4; ++i)       // AABBに含む点を与えてAABBを広げる
            Box.addInternalPoint(Vertices[i].Pos);
    }
    virtual void OnRegisterSceneNode() {
        if (IsVisible) {
            // レンダリングパイプラインに登録する。これによりrender()が呼ばれる。
            SceneManager->registerNodeForRendering(this);
        }
        ISceneNode::OnRegisterSceneNode();  // 子ノードらを登録する。
    }
    virtual void render() {
        u16 indices[] = {0,2,3, 2,1,3, 1,0,3, 2,0,1};
        IVideoDriver* r=SceneManager->getVideoDriver();
        r->setMaterial(Material);
        r->setTransform(ETS_WORLD, AbsoluteTransformation);
        r->drawVertexPrimitiveList(&Vertices[0], 4, &indices[0], 4,
                                   EVT_STANDARD, EPT_TRIANGLES, EIT_16BIT);
    }
    virtual const aabbox3d<f32>& getBoundingBox() const {return Box;}
    virtual u32 getMaterialCount() const {return 1;}
    virtual SMaterial& getMaterial(u32 i) {return Material;}  // iは常に0
};
main() {
    IrrlichtDevice* d=createDevice(EDT_OPENGL,
                                   dimension2d<u32>(1366,768));
    if(!d) return 0;
    d->setWindowCaption(L"hello, world");
    IVideoDriver*  r=d->getVideoDriver();
    ISceneManager* m=d->getSceneManager();
    // positionおよびlookatを指定する。下から見ている。
    m->addCameraSceneNode(0, vector3df(0,-40,0), vector3df(0,0,0));
    // m->addCameraSceneNodeMaya();
    CSampleSceneNode* n=new CSampleSceneNode(m->getRootSceneNode(), m, 666);
    // 各軸まわりに0.01秒に左回転する角度を指定する。
    ISceneNodeAnimator* a=m->createRotationAnimator(vector3df(0.8, 0, 0.8));
    if(!a) return 0;
    n->addAnimator(a);
    a->drop(); a=0;
    n->drop(); n=0;
    
    u32 frames=0;
    while(d->run()) {
        r->beginScene(true, true, SColor(0,100,100,100));
        m->drawAll();
        r->endScene();
        if(++frames=100) {
            stringw s=L"Irrlicht Engine [";
            s+=r->getName();
            s+=L"] FPS: ";
            s+=(s32)r->getFPS();
            d->setWindowCaption(s.c_str());
            frames=0;
        }
    }
    d->drop();
}
