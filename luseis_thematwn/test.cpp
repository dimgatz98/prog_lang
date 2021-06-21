#include <iostream>

using namespace std;

class A {
	public:
		void foo() {
			cout << 1 << endl; bar();
		}
		void bar(){
			cout << 2 << endl;;
		}
};

class B : public A {
	public:
		void foo() {
			cout << 3 << endl;; bar();
		}
		void bar() {
			cout << 4 << endl;;
		}
};

int main(){
	A *a = new A; a->foo();
	B *b = new B; b->foo();
	a = new B; a->foo();
	return 0;
}