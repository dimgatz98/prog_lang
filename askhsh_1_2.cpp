#include <iostream>
#include <string>
#include <fstream>
#include <vector>
#include <utility>
#include <bits/stdc++.h>

using namespace std;

void print_vect(std::vector<int> v){
	for(int i = 0 ; i < int(v.size()) ; i ++){
		cout << v[i] << " ";
	}
	cout << endl;
	return;
}

int main(int argc, char **argv){
	int m, n, temp;
	pair<int, int> sum_i; 
	std::vector<int> diff; 
	std::vector<int> cum_diff;
	ifstream f(argv[1]);
	f >> m >> n;
	for(int i = 0 ; i < m ; i++){
		f >> temp;
		diff.push_back(temp);
	}
	f.close();
	cout << m << " " << n << endl; 
	print_vect(diff);

	for(int i = 0 ; i < int(diff.size()) ; i++){
		if(i == 0){
			cum_diff.push_back(diff[i]);
			continue;
		}

		cum_diff.push_back(cum_diff[i - 1] + diff[i]);
	}
	print_vect(cum_diff);

	int res = 0, j = 0, k = int(diff.size()) - 1;
	for(int i = 0 ; i <= int(diff.size()) / 2 + 1 ; i++){
		if(cum_diff[k] - cum_diff[j] <= -1 * (k - j) * n){
			//cout << "k: " << k << " j: " << j << endl;
			res = k - j;
			break;
		}

		if(cum_diff[k] - cum_diff[k - 1] > cum_diff[j + 1] - cum_diff[j])
			k = k - 1;
		else
			j = j + 1;
	}

	cout << res << endl;
	return 0;
}