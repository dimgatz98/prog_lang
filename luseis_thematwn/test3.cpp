#include <iostream>

using namespace std;

#define foo(x, y, z) int a = z;z = y;y = x;x = a;

int main() {
	int k = 3 % 5, j = 2 % 4;
	int t[5] = {1,3,2,3,1};
	foo(t[k], t[j], k);
	for(int i = 0 ; i < 5 ; i ++){
		cout << t[i] << " ";
	}
	cout << endl;
	cout << k << endl;
}