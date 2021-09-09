#include <iostream>
#include <string>
#include <fstream>
#include <vector>
#include <utility>
#include <bits/stdc++.h>

using namespace std;

int solve(vector<int> &v, int res){
	vector<int> max_from_beg, min_from_end(v.size());
	
	max_from_beg.push_back(v[0]);
	for(int i = 1 ; i < int(v.size() ) ; i++){
		max_from_beg.push_back(max(max_from_beg[i - 1], v[i]));
	}

	min_from_end[v.size() - 1] = v[v.size() - 1];
	for(int i = v.size() - 2 ; i >= 0 ; i--){
		min_from_end[i] = min(min_from_end[i + 1], v[i]);
	}

	int i = 0, j = 0;
    while (j < int(v.size()) && i < int(v.size())) {
        if (max_from_beg[i] - min_from_end[j] >= 0) {
            res = max(res, int(j - i ) );
            j = j + 1;
        }
        else
            i = i + 1;
    }

    //cout << "i: " << i << " j: " << j << endl;

    return res;
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

	int res = 0;
	for(int i = 0 ; i < int(diff.size()) ; i++){
		if(i == 0){
			cum_diff.push_back(diff[0]);
		}

		else
			cum_diff.push_back(cum_diff[i - 1] + diff[i]);
	
		if(cum_diff[i] <= 0){
			res = i + 1;
		}
	}
	
    res = solve(cum_diff, res);

	cout << res << endl;
	return 0;
}