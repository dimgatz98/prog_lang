#include <iostream>
#include <string>
#include <fstream>
#include <vector>
#include <utility>
#include <bits/stdc++.h>

using namespace std;

void print_vect(std::vector<int> v){
	for(int i = 0 ; i < int(v.size()) ; i ++){
		cout << v[i] << "  ";
	}
	cout << endl;
	return;
}

int solve(vector<int> v){
	vector<int> max_from_beg, min_from_end;

	max_from_beg.push_back(v[0]);
	for(int i = 1 ; i < int(v.size() ) ; i++){
		max_from_beg.push_back(max(max_from_beg[i - 1], v[i]));
	}

	min_from_end.push_back(v[v.size() - 1]);
	for(int i = v.size() - 2 ; i >= 0 ; i--){
		min_from_end.push_back(min(min_from_end[v.size() - i - 2], v[i]));
	}

	print_vect(min_from_end);
	print_vect(max_from_beg);

	int i = 0, j = 0, res = -1;
    while (j < int(v.size()) && i < int(v.size()) ) {
        if (max_from_beg[i] >= min_from_end[j]) {
            res = max(res, j - i);
            j = j + 1;
        }
        else
            i = i + 1;
    }
 
    return res + 1;
}

int main(int argc, char **argv){
	int m, n, temp;
	std::vector<int> diff; 
	std::vector<int> cum_diff;
	ifstream f(argv[1]);
	f >> m >> n;
	for(int i = 0 ; i < m ; i++){
		f >> temp;
		diff.push_back(temp + n);
	}
	f.close();

	for(int i = 0 ; i < int(diff.size()) ; i++){
		if(i == 0){
			cum_diff.push_back(diff[0]);
		}

		else
			cum_diff.push_back(cum_diff[i - 1] + diff[i]);
	}
	
    print_vect(diff);	
    print_vect(cum_diff);

    int res = solve(cum_diff);

	cout << res << endl;
	return 0;
}