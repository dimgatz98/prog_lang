#include <iostream>
#include <string>
#include <fstream>
#include <vector>
#include <utility>
#include <bits/stdc++.h>
#include <list>

using namespace std;

int reverse_bfs(std::vector<vector<char> > &v, pair<int, int> start, int n, int m){
	list<pair<int, int> > queue;
	queue.push_back(start);
	int count = 0;
	pair<int, int> s;

	while(!queue.empty()){
        s = queue.front();
        queue.pop_front();
        count++;
 
        if(s.first != 0 && v[s.first - 1][s.second] == 'D'){
            queue.push_back(make_pair(s.first - 1, s.second));
        }
        if(s.first != m - 1 && v[s.first + 1][s.second] == 'U'){
            queue.push_back(make_pair(s.first + 1, s.second));
        }
        if(s.second != 0 && v[s.first][s.second - 1] == 'R'){
            queue.push_back(make_pair(s.first, s.second - 1));
        }
        if(s.second != n - 1 && v[s.first][s.second + 1] == 'L'){
            queue.push_back(make_pair(s.first, s.second + 1));
        }
    }
    return count;
}

int main(int argc, char **argv){
	int m, n;
	char temp;
	vector<pair<int, int> > winning;
	ifstream f(argv[1]);
	f >> m >> n;
	std::vector<vector<char> > arr(m); 
	for(int i = 0 ; i < m ; i++){
		for(int	j = 0 ; j < n ; j++){
			f >> temp;
			arr[i].push_back(temp);
		}
	}
	f.close();

	for(int i = 0 ; i < m ; i++){
		if(arr[i][0] == 'L')
			winning.push_back(make_pair(i,0));
		if(arr[i][n - 1] == 'R')
			winning.push_back(make_pair(i,n - 1) );
	}
	for(int j = 0 ; j < n ; j++){
		if(arr[0][j] == 'U')
			winning.push_back(make_pair(0, j));
		if(arr[m - 1][j] == 'D')
			winning.push_back(make_pair(m - 1, j));
	}

	int winning_count = 0;
	for(int i = 0 ; i < int(winning.size()) ; i++){
		winning_count += reverse_bfs(arr, winning[i], n , m);
	}
	cout << n * m - winning_count << endl;
}