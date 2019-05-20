#include <iostream>
#include <irrlicht/irrlicht.h>
using namespace irr;
using namespace irr::core;
using namespace irr::scene;
using namespace irr::video;
using namespace irr::io;
using namespace irr::gui;
main() {
    IrrlichtDevice* v=createDevice(EDT_OPENGL,
//                                   dimension2d<u32>(1366,768));
                                   dimension2d<u32>(1920,1080));
    if(!v) return 0;
    IVideoDriver*    d=v->getVideoDriver();
    IGUIEnvironment* e=v->getGUIEnvironment();
    ISceneManager*   m=v->getSceneManager();
    
    SExposedVideoData data=d->getExposedVideoData();
    void* x11Context = data.OpenGLLinux.X11Context;
    void* x11Display = data.OpenGLLinux.X11Display;
    unsigned long x11Window = data.OpenGLLinux.X11Window;
    printf("X11Context: %p\n", x11Context);
    printf("X11Display: %p\n", x11Display);
    printf("X11Window: %ld\n", x11Window);
    
    IAnimatedMeshSceneNode* node0=m->addAnimatedMeshSceneNode(m->getMesh("sydney.md2"));
    if(!node0) return 0;
    ISceneNodeAnimator* a=m->createFlyCircleAnimator(vector3df(0,0,30),10);
    if(!a) return 0;
    node0->addAnimator(a); a->drop();
    node0->setMaterialFlag(EMF_LIGHTING, false);
    node0->setFrameLoop(492, 539);
    node0->setAnimationSpeed(60);
    node0->setScale(vector3df(0.5,0.5,0.5));
    node0->setRotation(vector3df(0,90,0));
    node0->setMaterialTexture(0, d->getTexture("sydney.bmp"));
    ICameraSceneNode* c=m->addCameraSceneNodeFPS();
    
    while(v->run()) {
        d->beginScene(true, true, SColor(255,113,113,133));
        m->drawAll();
        e->drawAll();
        d->endScene();
    }
    v->drop();
}
