import java.util.*;

public class Testing {
  public static void main(String[] args) {
      String s = "hello";
      char[] arr = s.toCharArray();
      StringBuilder sb = new StringBuilder();
      for(char ch : arr) {
            ch = 'W';
            sb.append(ch);
      }
      String fin = new String(arr);
      //for(char ch: arr) {
        //System.out.print(ch);
      //}
      System.out.println(sb.toString());
  }
}
