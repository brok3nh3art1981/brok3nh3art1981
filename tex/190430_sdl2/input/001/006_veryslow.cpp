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

    SDL_Surface* bmp=NULL;
    SDL_Surface* tmp=SDL_LoadBMP("bmp_small.bmp"); assert(tmp!=NULL);
    bmp=SDL_ConvertSurface(tmp, s->format, 0);     assert(bmp!=NULL);
    
    
    bool b=true; SDL_Event e;
    SDL_Rect r; r.x=0; r.y=0; r.w=640; r.h=480;
    while(b) {
        while(SDL_PollEvent(&e)!=0) {
            if(e.type==SDL_QUIT) b=false;
        }
        SDL_BlitScaled(bmp, NULL, s, &r);
        SDL_UpdateWindowSurface(w);
    }

    SDL_FreeSurface(bmp);
    SDL_DestroyWindow(w);
    SDL_Quit();
}

