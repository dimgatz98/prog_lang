import java.util.*;

public class VaccineState {
  private ArrayList < Character > first, second;
  private VaccineState previous;
  private HashSet < Character > encountered;

  public VaccineState(ArrayList < Character > first, ArrayList < Character > second, HashSet <Character> encountered, VaccineState previous){
      this.first = first;
      this.second = second;
      this.encountered = encountered;
      this.previous = previous;
  }

  public boolean isFinal(){
      return first.isEmpty();
  }

  public Collection < VaccineState > next() {
      Collection < VaccineState > states = new ArrayList<>();
      states.add(new VaccineState(this.getComplement(), second, encountered, this));
      if(first.get(first.size() - 1).equals(second.get(0)) || !encountered.contains(first.get(first.size() - 1))) {
          if(!first.get(first.size() - 1).equals(second.get(0))) {
              HashSet < Character > newEncountered = new HashSet<Character>(encountered);
              newEncountered.add(first.get(first.size() - 1));
              states.add(new VaccineState(this.getCutFirst(), this.addToSecond(), newEncountered, this));
          }
          else {
             states.add(new VaccineState(this.getCutFirst(), this.addToSecond(), encountered, this));
           }
      }
      states.add(new VaccineState(first, this.getReverse(), encountered, this));
      return states;
  }

  public VaccineState getPrevious() {
      return previous;
  }

  public ArrayList < Character >  getFirst() {
      return first;
  }

  public ArrayList < Character > getCutFirst() {
      ArrayList < Character > result = new ArrayList < Character > (first);
      result.remove(result.size() - 1);
      return result;
  }

  public ArrayList < Character >  getComplement() {
      ArrayList < Character > result = new ArrayList < Character > (first);
      for(int i = 0; i < result.size(); i++) {
          if(result.get(i) == 'A') result.set(i, 'U');
          else if(result.get(i) == 'G') result.set(i, 'C');
          else if(result.get(i) == 'C') result.set(i, 'G');
          else result.set(i, 'A');
      }
      return result;
  }

  public ArrayList < Character >  getSecond() {
      return second;
  }

  public ArrayList < Character >  addToSecond() {
      ArrayList < Character > result = new ArrayList < Character > (second);
      Character lastChar = first.get(first.size() - 1);
      result.add(0, lastChar);
      return result;
  }

  public ArrayList < Character >  getReverse() {
      ArrayList <Character> result = new ArrayList <Character> (second);
      Collections.reverse(result);
      return result;
  }


  public HashSet<Character> getEncountered() {
      return encountered;
  }

  // Two states are equal if their strings are the same
  @Override
  public boolean equals(Object o){
      if (this == o) return true;
      if(o == null || getClass() != o.getClass()) return false;
      VaccineState other = (VaccineState) o;
      return first.equals(other.first) && second.equals(other.second);
  }

  // Hashing: consider only the two strings
  @Override
  public int hashCode() {
      return Objects.hash(first, second);
  }

}
