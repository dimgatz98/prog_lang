import java.util.*;


public class WCell {
    protected int x, y;

    public WCell(int x, int y) {
        this.x = x;
        this.y = y;
    }

    public boolean isBad(char[][] grid, int N, int M) {
        return x < 0
            || x >= N
            || y < 0
            || y >= M
            || grid[x][y] == 'X';
    }

    public Collection< WCell > next() {
        Collection< WCell >  cells = new ArrayList<>();
        cells.add(new WCell(x+1, y));
        cells.add(new WCell(x-1, y));
        cells.add(new WCell(x, y-1));
        cells.add(new WCell(x, y+1));
        return cells;
    }

    public int getX() {
        return x;
    }

    public int getY() {
        return y;
    }

    //Based on the equals and hashcode override from the Java Lab: https://web.microsoftstream.com/video/44309dc7-5d4d-4455-858a-4e00c49c665b
  /*  @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        WCell other = (WCell) o;
        return x == other.x && y == other.y;
    }
*/
    @Override
    public int hashCode(){
        return Objects.hash(x,y);
    }
}
