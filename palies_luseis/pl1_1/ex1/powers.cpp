#include <iostream>
#include <fstream>
#include <vector>
#include <cmath>

#define pb push_back

using namespace std;


//https://codereview.stackexchange.com/questions/151312/integer-log2-implemented-using-binary-search
int Log(int N)
{
    int bits = sizeof(N) * 4;
    int n = 0;
    while (N > 1)
    {
        if (N >> bits)
        {
            N >>= bits;
            n += bits;
        }
        bits >>= 1;
    }
    return n;
}


int main(int argc, char **argv)
{
  ios_base::sync_with_stdio(false);
  ifstream filename;
  filename.open(argv[1]);
  int t;
  filename >> t;
  while(t--)
  {
    int n, temp = 1, carry;
    int k,  pointer = 1, count = 0, last = 0;
    filename >> n >> k;
    int logn = Log(n);
    int ans[logn+1];
    for(int i = 0; i < logn+1; i++) ans[i] = 0;
    carry = n;
    while(carry != 0)
    {
      temp = Log(carry);
      ans[temp]++;
      count++;
      carry -= 1<<temp;
    }
    cout << "[";
    if (count > k || k > n) {cout<< "]\n";}
    else
    {
      for(int i = count; i < k; i++)
      {
        while(true)
        {
          if (ans[pointer] > 0){ans[pointer]--; ans[pointer-1]+=2; break;}
          else pointer++;
        }
        if(pointer != 1) pointer--;
      }
      for (int i = 1; i < logn+1; i++)
      {
        if (ans[i] != 0) last = i;
      }
      for(int i = 0; i < last; i++) cout << ans[i] << ",";
      cout << ans[last] << "]\n";
    }
  }
  filename.close();
}
