#define NDEBUG
#include <cassert>
#include <iostream>
bool f() {
    std::printf("hello, world\n");
    return false;
}
main() {
    assert(f());
}
