#include <bits/stdc++.h>


using namespace std;

#define MAXN 1000010
#define pb push_back

int N, M, starter, first;
bool visited[MAXN];
vector < vector <int> > adj(MAXN);
stack < int > cycle;
stack < int > vertices;
stack < int > tree;
vector <int> answer;

void init()
{
  for(int i = 0; i <= N; i++) visited[i] = false;
  for(int i = 0; i <= N; i++) adj[i].clear();
  answer.clear();
  while(!cycle.empty()) cycle.pop();
  while(!tree.empty()) tree.pop();
  while(!vertices.empty()) vertices.pop();
  cycle.push(0);
  starter = first = 0;
}

void dfs(int vertex, int parent)
{
    visited[vertex] = true;
    for(unsigned i = 0; i < adj[vertex].size(); i++) {
        if(!visited[ adj[ vertex ][ i ] ]) {
            dfs(adj[vertex][i], vertex);
            if(cycle.top() == adj[vertex][i] && adj[vertex][i] != starter){
            //  cout << "adding vertex " << vertex << endl;
              cycle.push(vertex);
            }
        }
        else if (adj[vertex][i] != parent && vertex != starter){
            cycle.push(vertex);
            first = vertex;
          //   cout << "first node found: " << vertex << endl;
            starter = adj[vertex][i];
          //  cout << "starter is: "<< starter <<  endl;
        }
    }
}

int count_aux(int vertex, int root)
{
  int result = 1;
    for(unsigned i = 0; i < adj[vertex].size(); i++) {
      if(adj[vertex][i] != root)
          result += count_aux(adj[ vertex ][ i ], vertex);
    }
    return result;
}


int count_trees(int vertex, int parent)
{
    int result = 1;
    cycle.pop();
    for(unsigned i = 0; i < adj[vertex].size(); i++) {
        if(adj[ vertex ][ i ] != cycle.top() && adj[ vertex ][ i ] != parent && adj[ vertex ][ i ] != starter) {
            result += count_aux(adj[ vertex ][ i ], vertex);
        }
    }
    return result;
}


int main(int argc, char** argv)
{
  //ios::sync_with_stdio(false);
  //cin.tie(0);
  ifstream filename;
  filename.open(argv[1]);
  int T;
  filename >> T;
  while(T--) {
      bool flag = true;
      int a, b, temp, parent;
      filename >> N >> M;
      init();
      for(int i = 0; i < M; i++) {
          filename >> a >> b;
          adj[a].pb(b);
          adj[b].pb(a);
      }
      //for(int i = 0; i < adj[10].size(); i++) cout << adj[10][i] << endl;
      if(N!=M) cout << "NO CORONA" << "\n";
      else {
          dfs(1,0);
          for(int i = 1; i <= N; i++) {
              if(!visited[i]) {cout << "NO CORONA" << "\n"; flag = false; break;}
          }
          if(flag) {
              /*while(!cycle.empty()) {
                  cout << cycle.top() << endl;
                  cycle.pop();
              }*/
              cout << "CORONA " << cycle.size()-1 << "\n";
              parent = cycle.top();
              answer.pb(count_trees(cycle.top(), first));
              while(cycle.top() != 0) {
                  temp = cycle.top();
                  answer.pb(count_trees(cycle.top(), parent));
                  parent = temp;
              }
              sort(answer.begin(), answer.end());
              for(unsigned i = 0; i < answer.size()-1; i++) cout << answer[i] << " ";
              cout << answer[answer.size()-1] << "\n";
          }
      }
  }
}
