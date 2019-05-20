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

    SDL_Surface* bmp=SDL_LoadBMP("bmp.bmp");
    assert(bmp!=NULL);

    bool quit=false;
    SDL_Event e;
    while(!quit) {  // メインループ
        while(SDL_PollEvent(&e)!=0) {  // イベントキューを走査する
            // ウィンドウのクローズボタンが押されたら終了する
            if(e.type==SDL_QUIT) quit=true;
        }
        SDL_BlitSurface(bmp, NULL, s, NULL);
        SDL_UpdateWindowSurface(w);
    }

    SDL_FreeSurface(bmp);
    SDL_DestroyWindow(w);
    SDL_Quit();
}

