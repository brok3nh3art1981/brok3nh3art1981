#include <irrlicht/irrlicht.h>
#include<iostream>
using namespace std;
using namespace irr;
using namespace irr::core;
using namespace irr::scene;
using namespace irr::video;
using namespace irr::io;
using namespace irr::gui;
main() {
    IrrlichtDevice* d=createDevice(EDT_OPENGL,
                                   dimension2d<u32>(1366,768),
                                   16, false, false, false, 0);
    if(!d) return 0;
    d->setWindowCaption(L"hello, world");
    IVideoDriver*    r=d->getVideoDriver();
    ISceneManager*   m=d->getSceneManager();
    IGUIEnvironment* e=d->getGUIEnvironment();
    e->addStaticText(L"hello, world",
                     rect<s32>(10,10,260,22), true);
    IAnimatedMesh* mesh=m->getMesh("sydney.md2");  // Quake2形式
    if(!mesh) { d->drop(); return 0; }
    IAnimatedMeshSceneNode* node=m->addAnimatedMeshSceneNode(mesh);
    if(!node) { d->drop(); return 0; }
    node->setMaterialFlag(EMF_LIGHTING, false);
    EMD2_ANIMATION_TYPE x;
    x=EMAT_STAND;
    /* x=EMAT_RUN;
    x=EMAT_ATTACK;
    x=EMAT_PAIN_A;
    x=EMAT_PAIN_B;
    x=EMAT_PAIN_C;
    x=EMAT_JUMP;
    x=EMAT_FLIP;
    x=EMAT_SALUTE;
    x=EMAT_FALLBACK;
    x=EMAT_WAVE;
    x=EMAT_POINT;
    x=EMAT_CROUCH_STAND;
    x=EMAT_CROUCH_WALK;
    x=EMAT_CROUCH_ATTACK;
    x=EMAT_CROUCH_PAIN;
    x=EMAT_CROUCH_DEATH;
    x=EMAT_DEATH_FALLBACK;
    x=EMAT_DEATH_FALLFORWARD;
    x=EMAT_DEATH_FALLBACKSLOW;
    x=EMAT_BOOM;
    x=EMAT_COUNT; */
    node->setMD2Animation(x);
    node->setMaterialTexture(0, r->getTexture("sydney.bmp"));
    m->addCameraSceneNode(0, vector3df(10,28,-30), vector3df(0,11,0));
    // m->addCameraSceneNodeMaya();
    while(d->run()) {
        r->beginScene(true, true, SColor(255,100,101,140));
        m->drawAll();
        e->drawAll();
        r->endScene();
    }
    d->drop();
}
