#include <iostream>
#include <string>
#include <fstream>
#include <vector>
#include <utility>
#include <bits/stdc++.h>
#include <list>

using namespace std;

int reverse_bfs(std::vector<vector<pair<char, int> > > v, pair<int, int> start, int n, int m){
	list<pair<int, int> > queue;
	queue.push_back(start);
	int count = 0;
	pair<int, int> s;

	while(!queue.empty()){
        // Dequeue a vertex from queue and print it
        s = queue.front();
        //cout << s.first << " " << s.second << endl;
        queue.pop_front();
 
        if(s.first != 0 && v[s.first - 1][s.second].second != 1 && v[s.first - 1][s.second].first == 'D'){
            v[s.first - 1][s.second].second = 1;
            queue.push_back(make_pair(s.first - 1, s.second));
        	count++;
        }
        if(s.first != m - 1 && v[s.first + 1][s.second].second != 1 && v[s.first + 1][s.second].first == 'U'){
            v[s.first + 1][s.second].second = 1;
            queue.push_back(make_pair(s.first + 1, s.second));
        	count++;
        }
        if(s.second != 0 && v[s.first][s.second - 1].second != 1 && v[s.first][s.second - 1].first == 'R'){
            v[s.first][s.second - 1].second = 1;
            queue.push_back(make_pair(s.first, s.second - 1));
        	count++;
        }
        if(s.second != n - 1 && v[s.first][s.second + 1].second != 1 && v[s.first][s.second + 1].first == 'L'){
            v[s.first][s.second + 1].second = 1;
            queue.push_back(make_pair(s.first, s.second + 1));
        	count++;
        }
    }
    return count;
}

int main(int argc, char **argv){
	int m, n;
	char temp;
	vector<pair<int, int> > winning;
	//std::vector<int> cum_arr;
	ifstream f(argv[1]);
	f >> m >> n;
	std::vector<vector<pair<char, int> > > arr(m); 
	for(int i = 0 ; i < m ; i++){
		for(int	j = 0 ; j < n ; j++){
			f >> temp;
			arr[i].push_back(make_pair(temp, 0) );
		}
	}
	f.close();

	//cout << m << " " << n << endl; 
	
	/*for(int i = 0 ; i < m ; i++){
		for(int j = 0 ; j < n ; j++)
			cout << arr[i][j].first << " ";
		cout << endl;
	}*/

	for(int i = 0 ; i < m ; i++){
		if(arr[i][0].first == 'L')
			winning.push_back(make_pair(i,0));
		if(arr[i][n - 1].first == 'R')
			winning.push_back(make_pair(i,n - 1) );
	}
	for(int j = 0 ; j < n ; j++){
		if(arr[0][j].first == 'U')
			winning.push_back(make_pair(0, j));
		if(arr[m - 1][j].first == 'D')
			winning.push_back(make_pair(m - 1, j));
	}

	int winning_count = 0;
	for(int i = 0 ; i < int(winning.size()) ; i++){
		winning_count += reverse_bfs(arr, winning[i], n , m);
	}
	cout << n * m - winning_count << endl;
}