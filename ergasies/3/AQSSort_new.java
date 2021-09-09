import java.util.*;
import java.io.*;

public class AQSSort{

    public static void main(String[] args){
        ArrayDeque<Integer> QueueIn= new ArrayDeque<>();
        Stack<Integer> StackIn= new Stack<>();
        int N = 0;
        int[] Values_;
        Values_= new int[N];
        
        //read input
        try{
            File myObj = new File(args[0]);
            Scanner myReader = new Scanner(myObj);
            N = myReader.nextInt();
            Values_= new int[N];
            for (int i = 0; i < N; i++) {
                int data= myReader.nextInt();
                QueueIn.addLast(data);
                Values_[i]=data;
            }
            myReader.close(); 
        }
        catch (Exception e){
            System.err.println(e);
        }

        //sort array
        int[] OldVal = new int[N];
        for (int i=0; i<N; i++) {
            OldVal[i]=Values_[i];
        }
        Arrays.sort(Values_);
       
        if (Arrays.equals(Values_,OldVal)){
            System.out.println("empty");
        }
        else{
            ArrayDeque<Integer> permutations = new ArrayDeque<>();
            permutations.add(new ArrayList<List <String> > ([ [queue, [], [] ] ]) );
            //length = -1
            
            while(1){
                i = permutations.pop();
                
                if(i[0] != []){
                    temp1 = i[2]
                    temp1.append("Q")
                    temp2 = i[0][1:].copy()
                    temp3 = i[1].copy()
                    temp3.append(i[0][0])
                    
                    if(len(temp3) == 0 and temp2 == sorted_queue):
                        res = temp1
                        return

                    if(not (string_from_list(temp2), string_from_list(temp3) ) in visited ):
                       visited.add( (string_from_list(temp2), string_from_list(temp3) ) )
                       permutations.append( [temp2, temp3, temp1] )
                }

                if(i[1] != []):
                    temp1 = i[2].copy()
                    temp1.append("S")
                    temp2 = i[0].copy()
                    temp2.append(i[1][-1])
                    temp3 = i[1][:-1].copy()
                    
                    if(len(temp3) == 0 and temp2 == sorted_queue):
                        res = temp1
                        return

                    if(not (string_from_list(temp2), string_from_list(temp3) ) in visited):
                        visited.add( (string_from_list(temp2), string_from_list(temp3) ) )
                        permutations.append( [temp2, temp3, temp1] )
            }
        }
    }

    private static void printSolution(State s) {
        if (s.getPrevious() != null) {
          printSolution(s.getPrevious());
        }
        if (s.getPrevious() != null) {
            if ((s.toString()=="true")) {
                System.out.print("Q");
            }else{
                System.out.print("S");
            }
        }
    }
}        