import java.util.*;

public class BfsSolver {

  //Based on the Java Lab BfsSolver
  public String solve (VaccineState initial) {
    Set < VaccineState > seen = new HashSet<>();
    Queue < VaccineState > q = new ArrayDeque<>();
    q.add(initial);
    seen.add(initial);

    while (!q.isEmpty()) {
        VaccineState c = q.remove();
        if (c.isFinal()) {
            q = null;
            seen = null;
            return findpath(c);
      }

        //Next already checks if a state is bad
        for (VaccineState n : c.next()) {
            if (!seen.contains(n)){
                if (n.isFinal()) {
                    q = null;
                    seen = null;
                    return findpath(n);
                }
                q.add(n);
                seen.add(n);
            }
        }
    }


    //WE MUST NEVER REACH THIS POINT
    System.out.println("ERROR\n");
    return null;
  }

    private static char findMove(VaccineState a, VaccineState b){
        ArrayList<Character> x1 = a.getFirst();
        ArrayList<Character> x2 = b.getFirst();
        if(x1.size() != x2.size()){
          return 'p';
        }
        else if(a.getComplement().equals(x2)){
          return 'c';
        }
        else return 'r';
   }

   private static String findpath(VaccineState c) {
       VaccineState parent = c.getPrevious();
       VaccineState current = c;
       ArrayList<Character> result = new ArrayList<Character>();

       while(parent != null){
         result.add(findMove(parent,current));
         current = parent;
         parent = current.getPrevious();
       }

       StringBuilder builder = new StringBuilder();
       builder.append('p');
       for( int i = result.size()-1; i >= 0; i--){
         builder.append(result.get(i));
       }
       //System.out.println("Builder is: " + builder.toString());
       return builder.toString();
   }
}
