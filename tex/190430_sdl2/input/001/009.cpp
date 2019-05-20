// g++ example.cpp -lSDL2 -lSDL2_image
#include <cassert>
#include <iostream>
#include <SDL2/SDL.h>
#include <SDL2/SDL_image.h>
main() {
    assert(SDL_Init(SDL_INIT_VIDEO) >= 0);
    SDL_Window* w=SDL_CreateWindow(
            "window title",
            SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED,
            640, 480, SDL_WINDOW_SHOWN);
    assert(w!=NULL);
    assert(IMG_Init(IMG_INIT_PNG) & IMG_INIT_PNG);
    SDL_Surface* s=SDL_GetWindowSurface(w);

    SDL_Surface* png0=IMG_Load("png.png"); assert(png0!=NULL);
    // SDL_Surface* png1=SDL_ConvertSurface(png0, s->format, 0); assert(png1!=NULL);

    bool b=true; SDL_Event e;
    while(b) {
        while(SDL_PollEvent(&e)!=0) {
            if(e.type==SDL_QUIT) b=false;
        }
        SDL_BlitSurface(png0, NULL, s, NULL);
        SDL_UpdateWindowSurface(w);
    }

    SDL_FreeSurface(png0);
    // SDL_FreeSurface(png1);
    SDL_DestroyWindow(w); w=NULL;
    IMG_Quit();
    SDL_Quit();
}

