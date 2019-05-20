#include <irrlicht/irrlicht.h>
using namespace irr;
using namespace irr::core;
using namespace irr::scene;
using namespace irr::video;
using namespace irr::io;
using namespace irr::gui;
main() {
    IrrlichtDevice* d=createDevice(EDT_OPENGL,
                                   dimension2d<u32>(1366,768));
    if(!d) return 0;
    d->setWindowCaption(L"hello, world");
    IVideoDriver*    r=d->getVideoDriver();
    ISceneManager*   m=d->getSceneManager();
    d->getFileSystem()->addFileArchive("map-20kdm2.pk3");
    IAnimatedMesh* mesh=m->getMesh("20kdm2.bsp");
    if(!mesh) { d->drop(); return 0; }
    ISceneNode* node=m->addOctreeSceneNode(mesh->getMesh(0), 0, -1, 1024);
    if(!node) { d->drop(); return 0; }
    node->setPosition(vector3df(-1300,-144,-1249));
    m->addCameraSceneNodeFPS();
    // m->addCameraSceneNodeMaya();
    d->getCursorControl()->setVisible(false);
    int lastFPS=-1;
    while(d->run()) {
        if(!d->isWindowActive()) { d->yield(); continue; }
        r->beginScene(true, true, SColor(255,200,200,200));
        m->drawAll();
        r->endScene();
        int fps=r->getFPS();
        if(lastFPS!=fps) {
            stringw s=L"Irrlicht Engine - Quake 3 Map example [";
            s+=r->getName();
            s+="] FPS:";
            s+=fps;
            d->setWindowCaption(s.c_str());
            lastFPS=fps;
        }
    }
    d->drop();
}
/*
map-20kdm2
├── levelshots
│   └── 20kdm2.tga
├── maps
│   ├── 20kdm2.aas
│   └── 20kdm2.bsp
├── models
│   └── mapobjects
│       ├── gratelamp
│       │   ├── gratetorch2b.tga
│       │   └── gratetorch2.jpg
│       └── timlamp
│           └── timlamp.tga
├── scripts
│   ├── 20kdm2.arena
│   ├── common.shader
│   ├── e7.shader
│   ├── liquid.shader
│   ├── models.shader
│   ├── sfx.shader
│   └── sky.shader
└── textures
    ├── e7
    │   ├── e7beam01.jpg
    │   ├── e7beam02_red.jpg
    │   ├── e7bigwall.jpg
    │   ├── e7bmtrim2.jpg
    │   ├── e7bmtrim.jpg
    │   ├── e7brickfloor01.jpg
    │   ├── e7brnmetal.jpg
    │   ├── e7dimfloor.jpg
    │   ├── e7panelwood.jpg
    │   ├── e7sbrickfloor.jpg
    │   ├── e7steptop2.jpg
    │   ├── e7steptop.jpg
    │   ├── e7swindow.jpg
    │   └── e7walldesign01b.jpg
    ├── gothic_floor
    │   └── xstepborder5.jpg
    ├── gothic_trim
    │   └── metalblackwave01.jpg
    ├── liquids
    │   └── lavahell.jpg
    ├── sfx
    │   ├── flame1.jpg
    │   ├── flame2.jpg
    │   ├── flame3.jpg
    │   ├── flame4.jpg
    │   ├── flame5.jpg
    │   ├── flame6.jpg
    │   ├── flame7.jpg
    │   ├── flame8.jpg
    │   └── flameball.jpg
    ├── skies
    │   ├── killsky_1.jpg
    │   └── killsky_2.jpg
    └── stone
        └── pjrock1.jpg
*/
