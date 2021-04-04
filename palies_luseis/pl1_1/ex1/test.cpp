#include <fstream>
#include <iostream>

using namespace std;

int main(int argc, char** argv)
{
  //ios::sync_with_stdio(false);
  //cin.tie(0);
  ifstream filename;
  filename.open(argv[1]);
  int T;
  filename >> T;
  while(T--)
  {
    int a, b, N, M;
    filename >> N >> M;
    for(int i = 0; i < M; i++) filename >> a >> b;
    cout << N << " " << M << endl;
  }
}
