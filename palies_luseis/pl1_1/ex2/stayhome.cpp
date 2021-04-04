#include <bits/stdc++.h>

#define mp make_pair
#define pb push_back
#define X first
#define Y second
#define MAXTIME 2e6+10

using namespace std;


typedef pair<int, int> pii;
typedef pair<char, int> pci;
typedef pair<string, int> psi;

vector< vector < pci > > grid;
vector< pii > airports;
pii covid, tsiodras, grafeio;
bool activated, entered, flag;
vector< vector < bool > > visited;
int row_nums, col_nums, time_airports;

void init_visited(int lines, int columns)
{
  visited.clear();
  vector<bool> help;
  for(int i = 0; i < lines; i++)
  {
    for(int j = 0; j < columns; j++)
    {
        help.pb(false);
    }
    visited.pb(help);
    help.clear();
  }
}

void flood_fill()
{
  queue<pii> q;
  pii up, down, left, right, position;
  int curr_time;
  q.push(covid);
  while(!q.empty())
  {
    position = q.front();
    visited[position.X][position.Y] = true;
    curr_time = grid[position.X][position.Y].Y;
    q.pop();
    if((curr_time == time_airports-1 || (q.empty() && curr_time != 0)) && !entered)
    {
      for(pii airport : airports)
      {
        if(!visited[airport.X][airport.Y])
        {
           grid[airport.X][airport.Y].Y = time_airports;
           q.push(airport);
           visited[airport.X][airport.Y] = true;
        }
      }
      entered = true;
    }
    if(position.Y > 0)
    {
      left = mp(position.X , position.Y - 1);
      if(!visited[left.X][left.Y] && grid[left.X][left.Y].X != 'X' && grid[left.X][left.Y].X != 'A')
      {
        grid[left.X][left.Y].Y = curr_time+2;
        q.push(left);
        visited[left.X][left.Y] = true;
      }
      else if(!visited[left.X][left.Y] && grid[left.X][left.Y].X == 'A' && !activated)
      {
        q.push(left);
        visited[left.X][left.Y] = true;
        grid[left.X][left.Y].Y = curr_time+2;
        time_airports = curr_time+7;
        activated = true;
      }
      else if(!visited[left.X][left.Y] && grid[left.X][left.Y].X == 'A')
      {
        q.push(left);
        grid[left.X][left.Y].Y = curr_time+2;
        visited[left.X][left.Y] = true;
      }
    }
    if(position.Y < col_nums-1)
    {
      right = mp(position.X , position.Y + 1);
      if(!visited[right.X][right.Y] && grid[right.X][right.Y].X != 'X' && grid[right.X][right.Y].X != 'A')
      {
        grid[right.X][right.Y].Y = curr_time+2;
        q.push(right);
        visited[right.X][right.Y] = true;
      }
      else if(!visited[right.X][right.Y] && grid[right.X][right.Y].X == 'A' && !activated)
      {
        q.push(right);
        visited[right.X][right.Y] = true;
        grid[right.X][right.Y].Y = curr_time+2;
        time_airports = curr_time+7;
        activated = true;
      }
      else if(!visited[right.X][right.Y] && grid[right.X][right.Y].X == 'A')
      {
        q.push(right);
        grid[right.X][right.Y].Y = curr_time+2;
        visited[right.X][right.Y] = true;
      }
    }
    if(position.X > 0)
    {
      up = mp(position.X - 1, position.Y);
      if(!visited[up.X][up.Y] && grid[up.X][up.Y].X != 'X' && grid[up.X][up.Y].X != 'A')
      {
        grid[up.X][up.Y].Y = curr_time+2;
        q.push(up);
        visited[up.X][up.Y] = true;
      }
      else if(!visited[up.X][up.Y] && grid[up.X][up.Y].X == 'A' && !activated)
      {
        q.push(up);
        visited[up.X][up.Y] = true;
        grid[up.X][up.Y].Y = curr_time+2;
        time_airports = curr_time+7;
        activated = true;
      }
      else if(!visited[up.X][up.Y] && grid[up.X][up.Y].X == 'A')
      {
        q.push(up);
        grid[up.X][up.Y].Y = curr_time+2;
        visited[up.X][up.Y] = true;
      }
    }
    if(position.X < row_nums-1)
    {
      down = mp(position.X + 1 , position.Y);
      if(!visited[down.X][down.Y] && grid[down.X][down.Y].X != 'X' && grid[down.X][down.Y].X != 'A')
      {
        grid[down.X][down.Y].Y = curr_time+2;
        q.push(down);
        visited[down.X][down.Y] = true;
      }
      else if(!visited[down.X][down.Y] && grid[down.X][down.Y].X == 'A' && !activated)
      {

        q.push(down);
        visited[down.X][down.Y] = true;
        grid[down.X][down.Y].Y = curr_time+2;
        time_airports = curr_time+7;
        activated = true;
      }
      else if(!visited[down.X][down.Y] && grid[down.X][down.Y].X == 'A')
      {

        q.push(down);
        grid[down.X][down.Y].Y = curr_time+2;
        visited[down.X][down.Y] = true;
      }
    }
  }
}

void tsiodras_home()
{
  queue <pair<pii, psi> > q;
  pii up, down, left, right;
  pair<pii, psi> position;
  string newposup, newposdown, newposleft, newposright;
  int curr_time = 0;
  q.push(mp(tsiodras, mp("", 0)));
  while(!q.empty())
  {
    position = q.front();
    newposup = newposdown = newposright = newposleft = position.Y.X;
    curr_time = position.Y.Y;
    if(position.X == grafeio) {cout << position.Y.X.length() << endl; cout << position.Y.X << endl; flag = true; return;}
    visited[position.X.X][position.X.Y] = true;
    curr_time = position.Y.Y;
    q.pop();
    if(position.X.X < row_nums-1)
    {
      down = mp(position.X.X + 1, position.X.Y);
      if(!visited[down.X][down.Y] && grid[down.X][down.Y].X != 'X' && grid[down.X][down.Y].Y > curr_time+1)
      {
        newposdown.pb('D');
        q.push(mp(down, mp(newposdown, curr_time+1)));
        visited[down.X][down.Y] = true;
      }
    }
    if(position.X.Y > 0)
    {
      left = mp(position.X.X , position.X.Y - 1);
      if(!visited[left.X][left.Y] && grid[left.X][left.Y].X != 'X' && grid[left.X][left.Y].Y > curr_time+1)
      {
        newposleft.pb('L');
        q.push(mp(left, mp(newposleft, curr_time+1)));
        visited[left.X][left.Y] = true;
      }
    }
    if(position.X.Y < col_nums-1)
    {
      right = mp(position.X.X , position.X.Y + 1);
      if(!visited[right.X][right.Y] && grid[right.X][right.Y].X != 'X' && grid[right.X][right.Y].Y > curr_time+1)
      {
        newposright.pb('R');
        q.push(mp(right, mp(newposright, curr_time+1)));
        visited[right.X][right.Y] = true;
      }
    }
    if(position.X.X > 0)
    {
      up = mp(position.X.X - 1, position.X.Y);
      if(!visited[up.X][up.Y] && grid[up.X][up.Y].X != 'X' && grid[up.X][up.Y].Y > curr_time+1)
      {
        newposup.pb('U');
        q.push(mp(up, mp(newposup, curr_time+1)));
        visited[up.X][up.Y] = true;
      }
    }
  }
}

int main(int argc, char **argv)
{
  flag = activated = entered = false;
  time_airports = 0;
  ifstream filename;
  filename.open(argv[1]);
  vector<pci> curr_row;
  string row = "";
  row_nums = col_nums = 0;
  while(getline(filename, row))
  {
    if(row.length() > 0) col_nums = row.length();
    else row_nums--;
    curr_row.clear();
    for(unsigned i = 0; i < row.length(); i++)
    {
      col_nums = row.length();
      if(row[i] == 'W') {covid = mp(row_nums, i); curr_row.pb(mp(row[i], 0));}
      else if(row[i] == 'S') {tsiodras = mp(row_nums, i); curr_row.pb(mp(row[i], MAXTIME));}
      else if(row[i] == 'T') {grafeio = mp(row_nums, i); curr_row.pb(mp(row[i], MAXTIME));}
      else curr_row.pb(mp(row[i], MAXTIME));
      if(row[i] == 'A') airports.pb(mp(row_nums, i));
    }
    grid.pb(curr_row);
    ++row_nums;
  }
  curr_row.clear();
  init_visited(row_nums, col_nums);
  flood_fill();
  init_visited(row_nums, col_nums);
  tsiodras_home();
  if(!flag) cout << "IMPOSSIBLE" << endl;
}
