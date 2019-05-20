// g++ example.cpp -lSDL2 -lSDL2_image
#include <cassert>
#include <iostream>
#include <SDL2/SDL.h>
#include <SDL2/SDL_image.h>
main() {
    assert(SDL_Init(SDL_INIT_VIDEO) >= 0);
    assert(SDL_SetHint(SDL_HINT_RENDER_SCALE_QUALITY, "1"));
    SDL_Window* w=SDL_CreateWindow(
            "window title",
            SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED,
            640, 480, SDL_WINDOW_SHOWN);
    assert(w);
    SDL_Renderer* r=SDL_CreateRenderer(w, -1, SDL_RENDERER_ACCELERATED);
    assert(r);
    SDL_SetRenderDrawColor(r, 0xff, 0xff, 0xff, 0xff);
    assert(IMG_Init(IMG_INIT_PNG) & IMG_INIT_PNG);
    SDL_Surface* s=SDL_GetWindowSurface(w);

    SDL_Surface* png=IMG_Load("png.png"); assert(png);
    SDL_Texture* t=SDL_CreateTextureFromSurface(r, png); assert(t);
    SDL_FreeSurface(png); png=NULL;

    bool b=true; SDL_Event e;
    while(b) {
        while(SDL_PollEvent(&e)) {
            if(e.type==SDL_QUIT) b=false;
        }
        SDL_RenderClear(r);
        SDL_RenderCopy(r, t, NULL, NULL);
        SDL_RenderPresent(r);
    }

    SDL_DestroyTexture(t);
    SDL_DestroyRenderer(r); r=NULL;
    SDL_DestroyWindow(w); w=NULL;
    IMG_Quit();
    SDL_Quit();
}

