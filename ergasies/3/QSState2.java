import java.util.*;
import java.io.*;
import java.text.BreakIterator;

public class QSState2 implements State {
    private boolean Moves;
    private State previous;
    private byte balance;
    static int[] SortedS;
    static ArrayDeque<Integer> Queue_;
    static Stack<Integer> Stack_;
    static int Qlen;
    static int Slen;
    static boolean multiflag;
    static int balancelimit;

    public QSState2(boolean M, State p, byte bal){
        Moves= M;
        previous=p;
        balance=bal;
    }
    
    @Override 
    public boolean isFinal() {
        if (balance!=0) return false;
        ArrayDeque<Integer> TestQueue_= (ArrayDeque<Integer>)Queue_.clone();
        Stack<Integer> TestStack_=(Stack<Integer>)Stack_.clone();
        find_current_state(this,TestQueue_,TestStack_);
        //System.out.println(find_depth(this));
        if (!TestStack_.isEmpty()) return false;
        boolean sorted=true;
        int i=0;
        Iterator<Integer> QueueIter= TestQueue_.iterator();
        while (QueueIter.hasNext()){
            sorted=(QueueIter.next()==SortedS[i]);
            i++;
            if (!sorted)
                break;
        }
        return sorted;
    }

    public boolean getMoves() {
        return Moves;
    }

    @Override
    public Collection<State> next(){
        Collection<State> states= new ArrayList<>();
        int depth=find_depth(this);
        byte absbalance= balance!=0 ? (byte)((balance*balance)/balance) : 0;
        if ((depth+absbalance)>QSState2.balancelimit) return states;
        if ((Qlen+balance)>0) {
            states.add(new QSState2(true,this,(byte)(this.balance-1)));
        }
        if ((Slen-balance)>0) {
            if (multiflag){
            ArrayDeque<Integer> TestQueue_= (ArrayDeque<Integer>)Queue_.clone();
            Stack<Integer> TestStack_=(Stack<Integer>)Stack_.clone();
            find_current_state(this,TestQueue_,TestStack_);
            int data=TestStack_.pop();
            TestStack_.push(data);
            if (!TestQueue_.isEmpty()) {
                if(data==TestQueue_.peekFirst()) return states;
            }
            }
            states.add(new QSState2(false,this,(byte)(this.balance+1)));
        }
        return states;
    }

    @Override
    public State getPrevious() {
        return previous;
    }

    @Override
    public String toString() {
        return String.valueOf(Moves);
    }

    @Override
    public boolean equals(Object o) {
    /*
        if (this==o) return true;
        if (o == null || getClass() != o.getClass()) return false;
    QSState other = (QSState) o;
    boolean equal=true;
    ArrayDeque<Integer> NewQueue_= (ArrayDeque<Integer>)Queue_.clone(); 
    Stack<Integer> NewStack_= (Stack<Integer>)Stack_.clone();
    ArrayDeque<Integer> NewQueue2_= (ArrayDeque<Integer>)other.Queue_.clone(); 
    Stack<Integer> NewStack2_= (Stack<Integer>)other.Stack_.clone();
    while(equal) {
        equal= (NewQueue_.pollFirst()==NewQueue2_.pollFirst());
    }
    while(equal) {
        equal= (NewStack_.pop()==NewStack2_.pop());
    }
    */
        return true;
    }

    @Override
    public int hashCode() {
        return Objects.hash(Queue_,Stack_);
    }

    private void find_current_state(State s, ArrayDeque<Integer> SQueue_, Stack<Integer> SStack_) {
        if (s.getPrevious()!=null) {
            find_current_state(s.getPrevious(),SQueue_,SStack_);
        }
        if (s.getPrevious()!=null){
            if (s.toString()=="true") {
                SStack_.push(SQueue_.pollFirst());
            }else{
                SQueue_.addLast(SStack_.pop());
            }
        }
    }
    private int find_depth(State s) {
        int depth=0;
        while(s.getPrevious()!=null){
            depth++;
            s=s.getPrevious();
        }
        return depth;
    }
}