import java.util.*;

public class XCell extends WCell {
    private XCell parent;
    private int reach_time;

    public XCell(int x, int y, int reach_time, XCell parent) {
        super(x, y);
        this.reach_time = reach_time;
        this.parent = parent;
    }

    public boolean isLate(int infected) {
          return reach_time >= infected;
    }

    public Collection< XCell >  tsiodrasNext() {
        Collection< XCell >  XCells = new ArrayList<>();
        XCells.add(new XCell(x+1, y, reach_time+1, this));
        XCells.add(new XCell(x, y-1, reach_time+1, this));
        XCells.add(new XCell(x, y+1, reach_time+1, this));
        XCells.add(new XCell(x-1, y, reach_time+1, this));
        return XCells;
    }

    public XCell getParent(){
        return parent;
    }

    public int getReachTime(){
        return reach_time;
    }

  // Dummy main to test functionality of class/superclass

  /* public static void main(String args[]) {
        char[][] map = new char[1000][1000];
        int N = 10, M = 10;
        XCell initial = new XCell(1, 2, 3, null);
        XCell second = new XCell(1, 2, 4, initial);
        for(int i = 0; i < N; i++) {
            for(int j = 0; j < M; j++) {
                map[i][j] = 'A';
            }
        }
        System.out.println((initial.equals(second))?"YES":"NO");
    }
  */

}
