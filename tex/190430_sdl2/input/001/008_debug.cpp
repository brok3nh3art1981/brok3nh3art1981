// g++ example.cpp -lSDL2
#include <cassert>
#include <iostream>
#include <SDL2/SDL.h>
main() {
    assert(SDL_Init(SDL_INIT_VIDEO) >= 0);
    SDL_Window* w=SDL_CreateWindow(
            "window title",
            SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED,
            640, 480, SDL_WINDOW_SHOWN);
    assert(w!=NULL);
    SDL_Surface* s=SDL_GetWindowSurface(w);

    SDL_Surface* bmp0=SDL_LoadBMP("bmp_small.bmp"); assert(bmp0!=NULL);
    SDL_Surface* bmp1=SDL_ConvertSurface(bmp0, s->format, 0); assert(bmp1!=NULL);
    
    SDL_PixelFormat* f=s->format;
    printf("palette=%p\n", f->palette);
    printf("BitsPerPixel=%d\n", f->BitsPerPixel);
    printf("BytesPerPixel=%d\n", f->BytesPerPixel);
    printf("Rmask=%x\n", f->Rmask);
    printf("Gmask=%x\n", f->Gmask);
    printf("Bmask=%x\n", f->Bmask);
    printf("Amask=%x\n", f->Amask);
    return 0;
    
    bool b=true; SDL_Event e;
    SDL_Rect r; r.x=0; r.y=0; r.w=640; r.h=480;
    while(b) {
        while(SDL_PollEvent(&e)!=0) {
            if(e.type==SDL_QUIT) b=false;
        }
        SDL_BlitScaled(bmp1, NULL, s, &r);
        SDL_UpdateWindowSurface(w);
    }

    SDL_FreeSurface(bmp0);
    SDL_FreeSurface(bmp1);
    SDL_DestroyWindow(w);
    SDL_Quit();
}

