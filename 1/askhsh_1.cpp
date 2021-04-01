#include <iostream>
#include <string>
#include <fstream>
#include <vector>
#include <utility>
#include <bits/stdc++.h>

using namespace std;

bool compare(pair<int, int> a, pair<int, int> b){
	if(a.first == b.first){
		return a.second < b.second;
	}
	return a.first > b.first;
}

int binary_search(vector<pair<int, int> > &cum_diff, int n, int val){
  	int l = 0;
    int h = n - 1;
    int mid;
  
    int ans = -1;
  
    while (l <= h) {
        mid = (l + h) / 2;
        if(cum_diff[mid].first >= val){
            ans = mid;
            l = mid + 1;
        }
        else
            h = mid - 1;
    }
    return ans;
}

void print_vect(std::vector<pair<int, int> > v){
	for(int i = 0 ; i < int(v.size()) ; i ++){
		cout << v[i].first << "," << v[i].second << "  ";
	}
	cout << endl;
	return;
}

int main(int argc, char **argv){
	int m, n, temp;
	std::vector<int> diff; 
	std::vector<pair<int, int> > cum_diff;
	ifstream f(argv[1]);
	f >> m >> n;
	for(int i = 0 ; i < m ; i++){
		f >> temp;
		diff.push_back(temp + n);
	}
	f.close();
	
    int res = 0;
	for(int i = 0 ; i <= int(diff.size()) ; i++){
		if(i == 0){
			cum_diff.push_back(make_pair(diff[0], 0));
		}

		else
			cum_diff.push_back(make_pair(cum_diff[i - 1].first + diff[i], i));
		
		if(cum_diff[i].first <= 0){
			res = i + 1;
		}
	}
	
	sort(cum_diff.begin(), cum_diff.end(), compare);
	
	vector<int> min_index;
	min_index.push_back(cum_diff[0].second);
	for(int i = 1; i < int(cum_diff.size()); i++) {
	    min_index.push_back(min(min_index[i - 1], cum_diff[i].second));
    }

    int sum = 0, index;
	for(int i = 0 ; i < int(cum_diff.size()) ; i++){		
		sum += diff[i];
		index = binary_search(cum_diff, int(cum_diff.size()), sum);
        if(index != -1 && min_index[index] < i && res < i - min_index[index])
            res = i - min_index[index];
	}

	cout << res << endl;
	return 0;
}