package RegisterControler;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Hashtable;

/**
 * Created by Bill on 2016/5/6.
 */
public class VirtualReadWrite {
    ArrayList<Integer> reader = new ArrayList<>();
    ArrayList<Integer> writer = new ArrayList<>();
    ArrayList<Integer> total = new ArrayList<>();

    int times[] = new int[50000];

    public void addReader(int x){
        times[x]++;
        if (!total.contains(x)) total.add(x);
        if (!reader.contains(x)) reader.add(x);
    }
    public void addWriter(int x){
        times[x]++;
        if (!total.contains(x)) total.add(x);
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
