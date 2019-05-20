// g++ example.cpp -lSDL2
#include <cassert>
#include <SDL2/SDL.h>
main() {
    assert(SDL_Init(SDL_INIT_VIDEO) >= 0);  // SDLを初期化
    SDL_Window* w=SDL_CreateWindow(         // ウィンドウを作る
            "window title",
            SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED,
            320, 240, SDL_WINDOW_SHOWN);
    assert(w!=NULL);
    SDL_Surface* s=SDL_GetWindowSurface(w);
    // サーフェスを青で塗りつぶす
    SDL_FillRect(s, NULL, SDL_MapRGB(s->format, 0x00, 0x00, 0xff));
    SDL_UpdateWindowSurface(w);
    SDL_Delay(1000);  // 1秒待つ
    SDL_DestroyWindow(w);
    SDL_Quit();
}

