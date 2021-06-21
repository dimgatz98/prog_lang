#include <iostream>

using namespace std;

int x = 2;

void g(int a, int b) {
	cout << a << " " << x << endl;
	x = b;
}

void f(int y) {
	int x = 3;
	g(y, x);
	cout << x << endl;
}

int main() {
	f(1);
	cout << x << endl;
}