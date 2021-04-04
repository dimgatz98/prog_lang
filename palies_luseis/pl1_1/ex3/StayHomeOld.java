import java.io.*;
import java.util.*;

public class StayHomeOld {

    public static void main(String args[]) {
        char[][] grid = new char[1000][1000];
        int N, M;
        GridCell tsiodras = new GridCell(0, 0), office = new GridCell(0, 0), covid = new GridCell(0, 0);
        ArrayList < GridCell > airports = new ArrayList < GridCell >();

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

            //Traverse grid and find covid, tsiodras, office, airports
            for(int i = 0; i < N; i++){
                for(int j = 0; j < M; j++){
                    if(grid[i][j] == 'W'){
                        covid  = new GridCell(i,j);
                    }
                    if(grid[i][j] == 'S'){
                        tsiodras  = new GridCell(i,j);
                    }
                    if(grid[i][j] == 'T'){
                        office  = new GridCell(i,j);
                    }
                    if(grid[i][j] == 'A'){
                       airports.add(new GridCell(i,j));
                    }
                }
            }
            int[][] infected = floodFill(grid, N, M, covid, airports);
            //System.out.println(Arrays.deepToString(infected).replace("], ", "]\n"));
            String solution = pathfinder(grid, N, M, tsiodras, office, infected);
            if(!"IMPOSSIBLE".equals(solution)) System.out.println(solution.length());
            System.out.println(solution);

        }
        catch(FileNotFoundException e){System.out.println("Exception caught: Cannot find file " + args[0]);}
        catch(IOException e) {System.out.println("Exception caught: Serious IO error");}
    }

    public static int[][] floodFill(char[][] grid, int N, int M, GridCell covid, ArrayList < GridCell > airports) {
        int[][] infected = new int[N][M];
        int current_time = 0, time_airports = 0;
        boolean activated = false, entered = false;
        Set < GridCell > seen = new HashSet<>();
        Queue < GridCell > q = new ArrayDeque<>();

        for(int i = 0; i < N; i++){
            for(int j = 0; j < M; j++){
                infected[i][j] = 2000010;
            }
        }

        q.add(covid);
        seen.add(covid);
        infected[covid.getX()][covid.getY()] = 0;
        while (!q.isEmpty()) {
            GridCell c = q.remove();
            current_time = infected[c.getX()][c.getY()];
            if(((current_time == time_airports-1) || (q.isEmpty() && current_time != 0)) && !entered) {
                  for (GridCell a : airports) {
                      if(!seen.contains(a)){
                          infected[a.getX()][a.getY()] = time_airports;
                          seen.add(a);
                          q.add(a);
                      }
                  }
                  entered = true;
            }

            for (GridCell n : c.next()){
                if (!seen.contains(n) && !n.isBad(grid,N,M)){
                    q.add(n);
                    seen.add(n);
                    infected[n.getX()][n.getY()] = current_time + 2;
                    if((grid[n.getX()][n.getY()] != 'A') || activated) {
                        activated = true;
                        time_airports = current_time + 7;
                    }
                }
            }
        }

        return infected;
    }

    public static String pathfinder(char[][] grid, int N, int M, GridCell tsiodras, GridCell office, int[][] infected) {
        String path = "";
        boolean cando = false;
        Set < TsiodrasCell > seen = new HashSet<>();
        Queue < TsiodrasCell > q = new ArrayDeque<>();
        TsiodrasCell initial = new TsiodrasCell(tsiodras.getX(), tsiodras.getY(), "", 0, null);

        q.add(initial);
        while(!q.isEmpty() && !cando) {
            TsiodrasCell c = q.remove();
            GridCell currentGridCell = new GridCell(c.getX(), c.getY());
            if(currentGridCell.equals(office)) {
                path = c.getPathway();
                cando = true;
            }
            seen.add(c);
            for(TsiodrasCell n : c.tsiodrasNext()) {
                if(!seen.contains(n) && !n.isTsiodrasBad(grid, N, M, infected)) {
                    q.add(n);
                    seen.add(n);
                }
            }
        }

        if(!cando) path = "IMPOSSIBLE";
        return path;
    }

}
