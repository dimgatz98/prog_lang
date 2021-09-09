import java.util.*;
import java.io.*;

public class Test{
    public static void main(String[] args){
        String queue = "Hello world!";
        ArrayDeque<ArrayDeque<String> > permutations = new ArrayDeque<ArrayDeque<String> >();
        ArrayDeque<String> singleList = new ArrayDeque<String>();
        singleList.add(queue);
        singleList.add("");
        singleList.add("");
        permutations.add(singleList); 
        Iterator<ArrayDeque<String> > iter = permutations.iterator();
        while(iter.hasNext() ) { 
            Iterator<String> siter = iter.next().iterator();
            while(siter.hasNext()){
                 String s = siter.next();
                 System.out.println(s);
             }
        }
    }
}        