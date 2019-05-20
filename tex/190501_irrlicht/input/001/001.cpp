#include <irrlicht/irrlicht.h>
main() {
    irr::IrrlichtDevice* d = irr::createDevice(irr::video::EDT_SOFTWARE,
                                               irr::core::dimension2d<irr::u32>(640, 480),
                                               16, false, false, false, 0);
    d->setWindowCaption(L"hello, world");
    irr::gui::IGUIEnvironment* e = d->getGUIEnvironment();
    e->addStaticText(L"hello, world",
                     irr::core::rect<irr::s32>(10,10,260,22),
                     true);
    irr::video::IVideoDriver* r = d->getVideoDriver();
    while(d->run())
    {
        r->beginScene(true, true, irr::video::SColor(255,100,101,140));
        e->drawAll();
        r->endScene();
    }
    d->drop();
}
