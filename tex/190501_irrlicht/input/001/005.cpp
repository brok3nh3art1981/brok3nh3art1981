#include <irrlicht/irrlicht.h>
using namespace irr;
using namespace irr::core;
using namespace irr::scene;
using namespace irr::video;
using namespace irr::io;
using namespace irr::gui;
class MyEventReceiver : public IEventReceiver {
private:
    bool KeyIsDown[KEY_KEY_CODES_COUNT];  // 具体的には255
public:
    virtual bool OnEvent(const SEvent& e) {
        // SEvent#EventTypeで共用体がSKeyInputであることを特定する。
        if(e.EventType==EET_KEY_INPUT_EVENT)
            KeyIsDown[e.KeyInput.Key]=e.KeyInput.PressedDown;  //PressedDownはbool
        return false;
    }
    // virtual bool IsKeyDown(EKEY_CODE c) const {
    bool IsKeyDown(EKEY_CODE c) const {  // const関数はメンバを変えない
        return KeyIsDown[c];
    }
    MyEventReceiver() {
        for(u32 i=0; i<KEY_KEY_CODES_COUNT; ++i)
            KeyIsDown[i]=false;
    }
};
main() {
    MyEventReceiver r;
    IrrlichtDevice* v=createDevice(EDT_OPENGL,
                                   dimension2d<u32>(1366,768),
                                   16, false, false, false, &r);
    if(!v) return 0;
    IVideoDriver*    d=v->getVideoDriver();
    IGUIEnvironment* e=v->getGUIEnvironment();
    ISceneManager*   m=v->getSceneManager();
    
    ISceneNode* n0=m->addSphereSceneNode();
    if(!n0) return 0;
    n0->setPosition(vector3df(0,0,30));
    n0->setMaterialTexture(0,d->getTexture("wall.bmp"));
    n0->setMaterialFlag(EMF_LIGHTING, false);
    
    ISceneNode* n1=m->addCubeSceneNode();
    if(!n1) return 0;
    n1->setMaterialTexture(0, d->getTexture("t351sml.jpg"));
    n1->setMaterialFlag(EMF_LIGHTING, false);
    // 回転中心と半径。回転速度は指定がなければ秒間1 rad。
    ISceneNodeAnimator* a=m->createFlyCircleAnimator(vector3df(0,0,30),20);
    if(!a) return 0;
    n1->addAnimator(a); a->drop();
    
    IAnimatedMeshSceneNode* n2=m->addAnimatedMeshSceneNode(m->getMesh("ninja.b3d"));
    // IAnimatedMeshSceneNode* n2=m->addAnimatedMeshSceneNode(m->getMesh("sydney.md2"));
    if(!n2) return 0;
    a=m->createFlyStraightAnimator(vector3df(100,0,60),vector3df(-100,0,60),3500,true);
    // a=m->createFlyStraightAnimator(vector3df(-10,0,100),vector3df(10,0,-30),15000,true);
    if(!a) return 0;
    n2->addAnimator(a); a->drop();
    n2->setMaterialFlag(EMF_LIGHTING, false);
    n2->setFrameLoop(0, 13);
    // n2->setFrameLoop(492, 539);
    n2->setAnimationSpeed(15);  // 秒間フレーム数
    // n2->setAnimationSpeed(50);
    // n2->setMD2Animation(EMAT_RUN);
    n2->setScale(vector3df(2,2,2));
    // n2->setScale(vector3df(0.5,0.5,0.5));
    n2->setRotation(vector3df(0,-90,0));
    // n2->setRotation(vector3df(0,90,0));
    // n2->setMaterialTexture(0, d->getTexture("sydney.bmp"));
    ICameraSceneNode* c=m->addCameraSceneNodeFPS();
    // v->getCursorControl()->setVisible(false);
    e->addImage(d->getTexture("irrlichtlogoalpha2.tga"), position2d<s32>(10,20));
    IGUIStaticText* t=e->addStaticText(L"hello, world", rect<s32>(10, 10, 400, 20));
    t->setOverrideColor(SColor(255, 255, 255, 0));  // 黄色
    
    int lastFPS = -1;
    u32 then=v->getTimer()->getTime();
    const f32 S=5;  // movement speed.
    while(v->run()) {
        const u32 now=v->getTimer()->getTime();
        const f32 elapsed=(f32)(now-then)/1000;
        then=now;
        
        vector3df c_pos=c->getPosition();
        if(r.IsKeyDown(KEY_KEY_Z)) c_pos.X+=S*elapsed;
        c->setPosition(c_pos);
        
        vector3df pos=n0->getPosition();
        if(r.IsKeyDown(KEY_ESCAPE)) break;
        if(r.IsKeyDown(KEY_KEY_W))      pos.Y+=S*elapsed;
        else if(r.IsKeyDown(KEY_KEY_S)) pos.Y-=S*elapsed;
        if(r.IsKeyDown(KEY_KEY_A))      pos.X-=S*elapsed;
        else if(r.IsKeyDown(KEY_KEY_D)) pos.X+=S*elapsed;
        n0->setPosition(pos);
        
        d->beginScene(true, true, SColor(255,113,113,133));
        m->drawAll();
        e->drawAll();
        d->endScene();
        int fps=d->getFPS();
        if(fps!=lastFPS) {
            stringw s=L"Irrlicht Engine [";
            s+=d->getName();
            s+=L"] fps: ";
            s+=fps;
            v->setWindowCaption(s.c_str());
            lastFPS=fps;
        }
    }
    v->drop();
}
