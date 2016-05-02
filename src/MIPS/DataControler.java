package MIPS;

import java.util.ArrayList;

/**
 * Created by Bill on 2016/5/2.
 */
public class DataControler {
    ArrayList<PseudoVar> data = new ArrayList<>();

    public String add(String value){
        PseudoVar now = new PseudoVar(value);
        data.add(now);
        return now.name;
    }

    public String add(int value){
        PseudoVar now = new PseudoVar(value);
        data.add(now);
        return now.name;
    }

    public String toString(){
        String str = ".data\n";
        for (PseudoVar now : data){
            str += now.toString();
        }
        return str;
    }
}
