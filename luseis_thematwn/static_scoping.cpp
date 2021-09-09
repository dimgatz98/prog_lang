#include <iostream>

using namespace std;

int z = 3;

void g(int a, int b) {
    cout << z << " " <<  b << endl;
    z = a + 1;
}

void f(int x) {
    int z = 2;
    g(x, z);
    cout << z << endl;
}

int main() {
    f(42);
    cout << z << endl;
}