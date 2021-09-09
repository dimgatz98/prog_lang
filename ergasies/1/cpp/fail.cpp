#include <iostream>
#include <string>
#include <fstream>
#include <vector>
#include <utility>
#include <bits/stdc++.h>

using namespace std;

//taken from https://www.geeksforgeeks.org/binary-search/
int binarySearch(std::vector<pair<int, int> > v, int l, int r, int x) { 
    if (r >= l) { 
        int mid = l + (r - l) / 2; 
  
        // If the element is present at the middle 
        // itself 
        if (v[mid].first == x) 
            return mid;
  
        // If element is smaller than mid, then 
        // it can only be present in left subarray 
        if (v[mid].first > x) 
            return binarySearch(v, l, mid - 1, x); 
  
        // Else the element can only be present 
        // in right subarray 
        return binarySearch(v, mid + 1, r, x); 
    } 
  
    // We reach here when element is not 
    // present in array 
    return -1; 
} 

void print_vect(std::vector<int> v){
	for(int i = 0 ; i < int(v.size()) ; i ++){
		cout << v[i] << " ";
	}
	cout << endl;
	return;
}

void print_pair_vect(std::vector<pair<int, int> > v){
	for(int i = 0 ; i < int(v.size()) ; i ++){
		cout << i << "'th element: " << v[i].first << " " << v[i].second << "  ";
	}
	cout << endl;
	return;
}

int main(int argc, char **argv){
	int m, n, temp, interval, solvable;
	pair<int, int> sum_i; 
	std::vector<int> diff; 
	std::vector<pair<int, int> > cum_diff;
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
			cum_diff.push_back(make_pair(diff[i], i) );
			continue;
		}

		cum_diff.push_back(make_pair(cum_diff[i - 1].first + diff[i], i));
		diff[i] = diff[i - 1] + diff[i];
	}

	//print_pair_vect(cum_diff);

	sort(cum_diff.begin(), cum_diff.end());
	
	print_pair_vect(cum_diff);
	print_vect(diff);

	int max = cum_diff[0].second;
	for(int i = 1 ; i < int(diff.size()) ; i++){
		if(cum_diff[i].second > max)
			max = cum_diff[i].second;

		else
			cum_diff[i].second = max;
		
	}
	
	int search, res = 0;
	for(int i = 0 ; i < int(diff.size()) ; i++){
		search = diff[i] - m * n;
		temp = binarySearch(cum_diff, 0, cum_diff.size(), search);
		
		cout << "searching for: " << search << " temp is: " << temp << endl;

		if(temp == -1)
			continue;

		if(res < cum_diff[temp].second - i){
			res = cum_diff[temp].second - i;
		}
	}

	cout << res << endl;

	return 0;
}