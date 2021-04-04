import java.io.*;
import java.util.*;

public class StayHome {

    public static void main(String args[]) {
      //long allocatedMemory = (Runtime.getRuntime().totalMemory()-Runtime.getRuntime().freeMemory()) / 1024;
      //System.out.println(allocatedMemory + " KB");
        char[][] grid = new char[1000][1000];
        int N, M;
        WCell tsiodras = new WCell(0, 0), office = new WCell(0, 0), covid = new WCell(0, 0);
        ArrayList < WCell > airports = new ArrayList < WCell >();

        try {
            //Read file and fill grid
            File inFile = new File(args[0]);
            BufferedReader br = new BufferedReader(new FileReader(inFile));
            String temp;
            int lines = 0;
            while((temp = br.readLine()) != null){
                grid[lines] = temp.toCharArray();
                lines++;
            }
            N = lines;
            M = grid[0].length;
            br = null;
            inFile = null;
            temp = null;
            //Traverse grid and find covid, tsiodras, office, airports
            for(int i = 0; i < N; i++){
                for(int j = 0; j < M; j++){
                    if(grid[i][j] == 'W'){
                        covid  = new WCell(i,j);
                    }
                    if(grid[i][j] == 'S'){
                        tsiodras  = new WCell(i,j);
                    }
                    if(grid[i][j] == 'T'){
                        office  = new WCell(i,j);
                    }
                    if(grid[i][j] == 'A'){
                       airports.add(new WCell(i,j));
                    }
                }
            }
           //long allocatedMemory = (Runtime.getRuntime().totalMemory()-Runtime.getRuntime().freeMemory()) / 1024;
           //System.out.println(allocatedMemory + " KB");
            int[][] infected = floodFill(grid, N, M, covid, airports);
            //allocatedMemory = (Runtime.getRuntime().totalMemory()-Runtime.getRuntime().freeMemory()) / 1024;
            //System.out.println(allocatedMemory + " KB");
            //System.out.println(Arrays.deepToString(infected).replace("], ", "]\n"));
            String solution = pathfinder(grid, N, M, tsiodras, office, infected);
            //allocatedMemory = (Runtime.getRuntime().totalMemory()-Runtime.getRuntime().freeMemory()) / 1024;
            //System.out.println(allocatedMemory + " KB");
            if(!"IMPOSSIBLE".equals(solution)) System.out.println(solution.length());
            System.out.println(solution);

        }
        catch(FileNotFoundException e){System.out.println("Exception caught: Cannot find file " + args[0]);}
        catch(IOException e) {System.out.println("Exception caught: Serious IO error");}
    }

    public static int[][] floodFill(char[][] grid, int N, int M, WCell covid, ArrayList < WCell > airports) {
        int[][] infected = new int[N][M];
        int current_time = 0, time_airports = 0;
        boolean activated = false, entered = false;
        boolean[][] visited = new boolean[N][M];
        Queue < WCell > q = new ArrayDeque<>();
        WCell c;

        for(int i = 0; i < N; i++){
            for(int j = 0; j < M; j++){
                visited[i][j] = false;
                infected[i][j] = 2000010;
            }
        }
        //long maxmemory = 0;
        //long allocatedMemory = (Runtime.getRuntime().totalMemory()-Runtime.getRuntime().freeMemory()) / 1024;
        //System.out.println(allocatedMemory + " KB");
        //if(allocatedMemory > maxmemory) maxmemory = allocatedMemory;
        q.add(covid);
        visited[covid.getX()][covid.getY()] = true;
        infected[covid.getX()][covid.getY()] = 0;
        while (!q.isEmpty()) {
            c = q.remove();
            current_time = infected[c.getX()][c.getY()];
            if(((current_time == time_airports-1) || (q.isEmpty() && current_time != 0)) && !entered) {
                  for (WCell a : airports) {
                      if(!visited[a.getX()][a.getY()]){
                          infected[a.getX()][a.getY()] = time_airports;
                          visited[a.getX()][a.getY()] = true;
                          q.add(a);
                      }
                  }
                  entered = true;
            }

            for (WCell n : c.next()){
                if (!n.isBad(grid,N,M) && !visited[n.getX()][n.getY()]){
                    q.add(n);
                    visited[n.getX()][n.getY()] = true;
                    infected[n.getX()][n.getY()] = current_time + 2;
                    if((grid[n.getX()][n.getY()] == 'A') && !activated) {
                        activated = true;
                        time_airports = current_time + 7;
                    }
                }
            }
          //allocatedMemory = (Runtime.getRuntime().totalMemory()-Runtime.getRuntime().freeMemory()) / 1024;
          //if(allocatedMemory > maxmemory) maxmemory = allocatedMemory;
        }

       //allocatedMemory = (Runtime.getRuntime().totalMemory()-Runtime.getRuntime().freeMemory()) / 1024;
      //if(allocatedMemory > maxmemory) maxmemory = allocatedMemory;
      //System.out.println("Max memory used: " + maxmemory + " KB");
        return infected;
    }

    public static String pathfinder(char[][] grid, int N, int M, WCell tsiodras, WCell office, int[][] infected) {
        String path;
        boolean cando = false;
        boolean[][] visited = new boolean[N][M];
        Queue < XCell > q = new ArrayDeque<>();
        XCell initial = new XCell(tsiodras.getX(), tsiodras.getY(), 0, null);
        XCell c, finalCell = new XCell(0,0,0,null);

        for(int i = 0; i < N; i++){
            for(int j = 0; j < M; j++){
                visited[i][j] = false;
            }
        }
        //long allocatedMemory = (Runtime.getRuntime().totalMemory()-Runtime.getRuntime().freeMemory()) / 1024;
        //long maxmemory = allocatedMemory;
        q.add(initial);
        visited[initial.getX()][initial.getY()] = true;
        while(!q.isEmpty() && !cando) {
             c = q.remove();
            if(c.getX() == office.getX() && c.getY() == office.getY()) {
                finalCell = c;
                cando = true;
            }
            for(XCell n : c.tsiodrasNext()) {
                if(!n.isBad(grid, N, M) && !n.isLate(infected[n.getX()][n.getY()]) && !visited[n.getX()][n.getY()]) {
                    q.add(n);
                    visited[n.getX()][n.getY()] = true;
                }
            }
          //allocatedMemory = (Runtime.getRuntime().totalMemory()-Runtime.getRuntime().freeMemory()) / 1024;
          //if(allocatedMemory > maxmemory) maxmemory = allocatedMemory;
        }
      //  allocatedMemory = (Runtime.getRuntime().totalMemory()-Runtime.getRuntime().freeMemory()) / 1024;
        //if(maxmemory < allocatedMemory) maxmemory = allocatedMemory;
        //System.out.println("Max memory used: " + maxmemory + " KB");
        if(!cando) {path = "IMPOSSIBLE"; return path;}
        else
          return findpath(finalCell);
    }

    private static String findpath(XCell c) {
        XCell parent = c.getParent();
        XCell current = c;
        ArrayList<Character> result = new ArrayList<Character>();

        while(parent != null){
          result.add(findMove(parent,current));
          current = parent;
          parent = current.getParent();
        }

        StringBuilder builder = new StringBuilder();
        for( int i = result.size()-1; i >= 0; i--){
          builder.append(result.get(i));
        }
        return builder.toString();
    }

    private static char findMove(XCell a, XCell b){
        int x1 = a.getX(), y1 = a.getY();
        int x2 = b.getX(), y2 = b.getY();
        if(y1 == y2){
          if (x2 == x1+1){
            return 'D';
          }
          return 'U';
        }
        else {
          if(y2 == y1+1){
            return 'R';
          }
          return 'L';
        }
   }

}
