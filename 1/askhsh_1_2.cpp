#include <iostream>
#include <string>
#include <fstream>
#include <vector>
#include <utility>
#include <bits/stdc++.h>

using namespace std;

int findMaxLenSubarray(int arr[], int n, int S){
    // create an empty map to store the ending index of the first subarray
    // having some sum
    unordered_map<int, int> map;
 
    // insert `(0, -1)` pair into the set to handle the case when a
    // subarray with sum `S` starts from index 0
    map[0] = -1;
 
    int sum = 0;
 
    // `len` stores the maximum length of subarray with sum `S`
    int len = 0;
 
    // stores ending index of the maximum length subarray having sum `S`
    int ending_index = -1;
 
    // traverse the given array
    for (int i = 0; i < n; i++)
    {
        // sum of elements so far
        sum += arr[i];
 
        // if the sum is seen for the first time, insert the sum with its
        // into the map
        if (map.find(sum) == map.end()) {
            map[sum] = i;
        }
 
        // update length and ending index of the maximum length subarray
        // having sum `S`
        if (map.find(sum - S) != map.end() && len < i - map[sum - S])
        {
            len = i - map[sum - S];
            ending_index = i;
        }
    }
 
    return len;
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
	
	int res = getLargestSubsequenceSize(diff);

	cout << res << endl;
	return 0;
}