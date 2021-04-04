import java.util.*;

public class VaccineState {
  private String first, second, path;
  private VaccineState previous;
  private HashSet < Character > encountered;

  public VaccineState(String first, String second, String path, HashSet <Character> encountered, VaccineState previous){
      this.first = first;
      this.second = second;
      this.path = path;
      this.previous = previous;
      this.encountered = new HashSet<>();
      this.encountered = (HashSet) encountered.clone();
      encountered = null;
  }

  public boolean isFinal(){
      return first.isEmpty();
  }

  public Collection < VaccineState > next() {
      Collection < VaccineState > states = new ArrayList<>();
      states.add(new VaccineState(this.getComplement(), second, path+"c", encountered, this));
      if(first.substring(first.length() - 1).equals(second.substring(0,1)) || !encountered.contains(first.charAt(first.length() - 1))) {
          if(!first.substring(first.length() - 1).equals(second.substring(0,1))) {
              HashSet < Character > newEncountered = new HashSet<>();
              newEncountered = (HashSet) encountered.clone();
              newEncountered.add(first.charAt(first.length() - 1));
              states.add(new VaccineState(this.getCutFirst(), this.addToSecond(), path+"p", newEncountered, this));
          }
          else {
             states.add(new VaccineState(this.getCutFirst(), this.addToSecond(), path+"p", encountered, this));
           }
      }
      states.add(new VaccineState(first, this.getReverse(), path+"r", encountered, this));
      return states;
  }

  public VaccineState getPrevious() {
      return previous;
  }

  public String getFirst() {
      return first;
  }

  public String getCutFirst() {
      return first.substring(0, first.length() - 1);
  }

  public String getComplement() {
      char[] newFirst = first.toCharArray();
      StringBuilder sb = new StringBuilder();
      for(char ch : newFirst) {
          if(ch == 'A') ch = 'U';
          else if(ch == 'G') ch = 'C';
          else if(ch == 'C') ch = 'G';
          else ch = 'A';
          sb.append(ch);
      }
      newFirst = null;
    return sb.toString();
  }

  public String getSecond() {
      return second;
  }

  public String addToSecond() {
      String lastChar = first.substring(first.length() - 1);
      return lastChar + second;
  }

  public String getReverse() {
      StringBuilder sb = new StringBuilder();
      sb.append(second);
      sb.reverse();
      return sb.toString();
  }

  public String getPath() {
      return path;
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
      return Objects.hash(first,second);
  }

}
