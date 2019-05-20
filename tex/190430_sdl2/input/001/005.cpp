// g++ example.cpp -lSDL2
#include <cassert>
#include <iostream>
#include <vector>
#include <SDL2/SDL.h>
main() {
    assert(SDL_Init(SDL_INIT_VIDEO) >= 0);
    SDL_Window* w=SDL_CreateWindow(
            "window title",
            SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED,
            640, 480, SDL_WINDOW_SHOWN);
    assert(w!=NULL);
    SDL_Surface* s=SDL_GetWindowSurface(w);

    std::vector<SDL_Surface*> ss(5);
    ss[0]=SDL_LoadBMP("bmp.bmp");       assert(ss[0]!=NULL);
    ss[1]=SDL_LoadBMP("bmp_up.bmp");    assert(ss[1]!=NULL);
    ss[2]=SDL_LoadBMP("bmp_down.bmp");  assert(ss[2]!=NULL);
    ss[3]=SDL_LoadBMP("bmp_left.bmp");  assert(ss[3]!=NULL);
    ss[4]=SDL_LoadBMP("bmp_right.bmp"); assert(ss[4]!=NULL);
    
    bool b=true; SDL_Event e; SDL_Surface* c=ss[0];
    while(b) {
        while(SDL_PollEvent(&e)!=0) {
            if(e.type==SDL_QUIT) b=false;
            if(e.type==SDL_KEYDOWN) {
                int x=e.key.keysym.sym;
                if(x==SDLK_UP)    c=ss[1];
                if(x==SDLK_DOWN)  c=ss[2];
                if(x==SDLK_LEFT)  c=ss[3];
                if(x==SDLK_RIGHT) c=ss[4];
            }
        }
        SDL_BlitSurface(c, NULL, s, NULL);
        SDL_UpdateWindowSurface(w);
    }

    for(SDL_Surface* x:ss) SDL_FreeSurface(s);
    SDL_DestroyWindow(w);
    SDL_Quit();
}

