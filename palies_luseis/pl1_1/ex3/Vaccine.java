import java.util.*;
import java.io.*;

public class Vaccine {

  public static void main(String args[]) {
    try {
      Scanner scanner = new Scanner(new File(args[0]));
      int N = scanner.nextInt();
      String useless = scanner.nextLine();

      HashSet <Character> encountered = new HashSet<>();
      ArrayList<Character> first = new ArrayList<Character>();
      ArrayList<Character> second = new ArrayList<Character>();
      for(int i = 0; i < N; i++ ){
          String starter = scanner.nextLine();
          for (char c : starter.toCharArray()) {
              first.add(c);
          }
          second.add(first.get(first.size() - 1));
          first.remove(first.size()-1);
          encountered.add(second.get(0));
          BfsSolver solver = new BfsSolver();
          VaccineState initial = new VaccineState(first, second, encountered, null);
          //System.out.println(initial.getFirst().toString() + " " + initial.getSecond().toString());
          String result = solver.solve(initial);
          long allocatedMemory = (Runtime.getRuntime().totalMemory()-Runtime.getRuntime().freeMemory()) / 1024;
          System.out.println(allocatedMemory + " KB");
          System.out.println(result);
          first.clear();
          encountered.clear();
          second.clear();
          System.gc();
      }
    }
    catch (FileNotFoundException e){
      System.out.println("Input file not found.");
    }
  }
}
