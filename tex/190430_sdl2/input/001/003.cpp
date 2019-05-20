// g++ example.cpp -lSDL2
#include <cassert>
#include <SDL2/SDL.h>
main() {
    assert(SDL_Init(SDL_INIT_VIDEO) >= 0);
    SDL_Window* w=SDL_CreateWindow(
            "window title",
            SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED,
            640, 480, SDL_WINDOW_SHOWN);
    assert(w!=NULL);
    SDL_Surface* s=SDL_GetWindowSurface(w);

    SDL_Surface* bmp=SDL_LoadBMP("bmp.bmp");
    assert(bmp!=NULL);

    SDL_BlitSurface(bmp, NULL, s, NULL);
    SDL_UpdateWindowSurface(w);
    SDL_Delay(1000);

    SDL_FreeSurface(bmp);
    SDL_DestroyWindow(w);
    SDL_Quit();
}

