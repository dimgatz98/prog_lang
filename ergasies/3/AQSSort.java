import java.util.*;
import java.io.*;

public class AQSSort{

    public static void main(String[] args){

        Solver solver= new BFSolver();
        ArrayDeque<Integer> QueueIn= new ArrayDeque<>();
        Stack<Integer> StackIn= new Stack<>();
        int N=0;
        int[] Values_;
        Values_= new int[N];
        try{
            File myObj = new File(args[0]);
            Scanner myReader = new Scanner(myObj);
            N = myReader.nextInt();
            Values_= new int[N];
            for (int i=0; i<N; i++) {
                int data= myReader.nextInt();
                QueueIn.addLast(data);
                Values_[i]=data;
            }
            myReader.close(); 
        }
        catch (Exception e){
            System.err.println(e);
        }

        State initial= new QSState2(true,null,(byte)0);
        int[] OldVal=new int[N];
        for (int i=0; i<N; i++) {
            OldVal[i]=Values_[i];
        }
        Arrays.sort(Values_);
        QSState2.multiflag=false;
        QSState2.balancelimit=3*Values_.length+1;
        int temp=-1;
        for (int i=0; i<Values_.length; i++) {
            if (Values_[i]==temp) {
                QSState2.multiflag=true;
                break;
            }
            temp=Values_[i];
        }

        if (Arrays.equals(Values_,OldVal)){
            System.out.println("empty");
        }else{
            QSState2.SortedS=Values_;
            QSState2.Qlen=Values_.length;
            QSState2.Slen=0;
            QSState2.Queue_=QueueIn;
            QSState2.Stack_=StackIn;
            State result=solver.solve(initial);
            printSolution(result);
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