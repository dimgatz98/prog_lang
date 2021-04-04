#include <bits/stdc++.h>

using namespace std;

int main()
{
  int decider;
  ofstream outfile;
  outfile.open("vaccine.txt");
  outfile << 10 << endl;
  for(int j = 0; j < 10; j++)
  {
    for(int i = 0; i < 50; i++)
    {
      decider = (rand() % 4);
      if(decider == 0) outfile << 'A';
      else if(decider == 1) outfile << 'C';
      else if(decider == 2) outfile << 'G';
      else outfile << 'U';
    }
    outfile << endl;
  }
  outfile.close();
}
