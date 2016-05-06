package RegisterControler;

import java.util.ArrayList;

/**
 * Created by Bill on 2016/5/6.
 */
public class VirtualReadWrite {
    ArrayList<Integer> reader = new ArrayList<>();
    ArrayList<Integer> writer = new ArrayList<>();
    public void addReader(int x){
        if (!reader.contains(x)) reader.add(x);
    }
    public void addWriter(int x){
        if (!writer.contains(x)) writer.add(x);
    }

    @Override
    public String toString(){
        String str = "# Read:";
        for (Integer x : reader)
            str += " " + x.toString();
        str += "\n";
        str += "# Write:";
        for (Integer x : writer)
            str += " " + x.toString();
        str += "\n";
        return str;
    }
}
