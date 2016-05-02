package MIPS;

/**
 * Created by Bill on 2016/5/2.
 */
public class PseudoVar {
    String name,type,value;
    static Integer counter = 0;

    PseudoVar(String _value){
        name = "String" + counter++;
        value = "\"" + _value + "\"";
        type = ".asciiz";
    }

    PseudoVar(Integer _value){
        name = "length" + counter;
        value = _value.toString();
        type = ".word";
    }

    public String toString(){
        return "\t" + name + ": \t" + type + " \t" + value + "\n";
    }


}
