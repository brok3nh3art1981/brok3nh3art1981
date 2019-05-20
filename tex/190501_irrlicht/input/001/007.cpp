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
                                   dimension2d<u32>(1920,1080));
    if(!v) return 0;
    IVideoDriver*    d=v->getVideoDriver();
    IGUIEnvironment* e=v->getGUIEnvironment();
    ISceneManager*   m=v->getSceneManager();
    
    IAnimatedMeshSceneNode* node0=m->addAnimatedMeshSceneNode(m->getMesh("sydney.md2"));
    if(!node0) return 0;
    ISceneNodeAnimator* a=m->createFlyCircleAnimator(vector3df(0,0,30),10, 0.01);
    if(!a) return 0;
    node0->addAnimator(a); a->drop();
    node0->setMaterialFlag(EMF_LIGHTING, false);
    node0->setFrameLoop(492, 539);
    node0->setAnimationSpeed(60);
    node0->setScale(vector3df(0.5,0.5,0.5));
    node0->setRotation(vector3df(0,90,0));
    node0->setMaterialTexture(0, d->getTexture("sydney.bmp"));
    ICameraSceneNode* c=m->addCameraSceneNode();
    c->setTarget(vector3df(0,0,0));
    a=m->createFlyCircleAnimator(vector3df(0,15,-40), 30);
    c->addAnimator(a); a->drop();
    
    ILightSceneNode* l=m->addLightSceneNode();
    l->setLightType(ELT_DIRECTIONAL);
    l->setRotation(vector3df(60,-30,0));
    
    //ISceneNode* n=m->addCubeSceneNode(10);
    ISceneNode* n=m->addSphereSceneNode(10);
    n->setMaterialFlag(EMF_LIGHTING,true);
    n->setMaterialType(EMT_REFLECTION_2_LAYER);
    
    while(v->run()) {
        d->beginScene(true, true, SColor(255,113,113,133));
        // d->beginScene(true, true, 0);
        m->drawAll();
        e->drawAll();
        d->endScene();
    }
    v->drop();
}
