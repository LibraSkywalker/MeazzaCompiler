package RegisterControler;

import java.util.ArrayList;

import static MIPS.TextControler.GlobalState;
import static RegisterControler.RegisterName.*;

/**
 * Created by Bill on 2016/5/4.
 */
public class RegisterStatic {
    public class state{
        int selfColor;
        int color;
        @Override
        public String toString() {
            return "<" + selfColor + "," + color + ">";
        }

        state copy(){
            state now = new state();
            now.selfColor = selfColor;
            now.color = color;
            return now;
        }


    }

    public class Property {
        int property = 0;
        int times = 0;
    }
    Property[] StateOfVReg = new Property[500000];
    state[] ColorOfVReg = new state[500000];

    public int property(int i){
        return StateOfVReg[i].property;
    }

    state currentColor = new state();
    ArrayList<Integer> used = new ArrayList<>();
    ArrayList<Integer> total = new ArrayList<>();
    public ArrayList<Integer> []Dic = new ArrayList[5];

    public RegisterStatic(){
        for (int i = 0; i < 5; i++)
            Dic[i] = new ArrayList<>();
    }

    public int times(int i){
        return StateOfVReg[i].times;
    }
    public void load(VirtualReadWrite usage){

        for (Integer x : usage.reader){
            if (!used.contains(x)) used.add(x);
            if (StateOfVReg[x] == null){
                StateOfVReg[x] = new Property();
            }
            if (StateOfVReg[x].times == 0){
                StateOfVReg[x].property = local;
            }
            else {
                if (StateOfVReg[x].property < localSaved)
                    StateOfVReg[x].property = localSaved;
            }
        }

        for (Integer x : usage.total){
            if (StateOfVReg[x] == null){
                StateOfVReg[x] = new Property();
            }
            if (!total.contains(x))
                total.add(x);
            StateOfVReg[x].times += usage.times[x];
        }

    }

    public void load(RegisterStatic lastState){
        for (Integer now : lastState.total) {
            if (!total.contains(now)) {
                total.add(now);
                System.out.println(StateOfVReg[now] + "@");
                StateOfVReg[now] = new Property();
            }
            StateOfVReg[now].times += lastState.StateOfVReg[now].times;
        }

        for (Integer now : lastState.used) {
            if (!used.contains(now)) {
                used.add(now);
            }
            StateOfVReg[now].property = lastState.StateOfVReg[now].property;
        }
    }

    public void call(){
        currentColor.color++;
    }

    public void selfCall(){
        currentColor.color = 0;
        currentColor.selfColor ++;
    }

    public void set(int x){
        System.out.println("Register $" + x + " settled");
        System.out.println("color change from " + ColorOfVReg[x] + " to " + currentColor);
        ColorOfVReg[x] = currentColor.copy();
    }

    public void update(int x){
        System.out.println("Register $" + x + " visited");

        if (x < 32){
            StateOfVReg[x].property = local;
            return;
        }
        System.out.println("color" + x +": " + ColorOfVReg[x] + " required: " + currentColor);
        if (ColorOfVReg[x].selfColor != currentColor.selfColor){
            StateOfVReg[x].property = SaveInAddress;
        } else {
            if (ColorOfVReg[x].color != currentColor.color && StateOfVReg[x].property < global){
                StateOfVReg[x].property = global;
            }
        }
    }

    public void adjust(){
        int count = 0;
        for (Integer x : used)
            if (GlobalState.StateOfVReg[x].property == localSaved)
                count++;
        while (count-- > 9){
            int min = 0;
            for (Integer x : used)
                if (GlobalState.StateOfVReg[x].property == localSaved)
                    if (min == 0) min = x;
                    else if (GlobalState.StateOfVReg[min].times > GlobalState.StateOfVReg[x].times)
                        min = x;
            GlobalState.StateOfVReg[min].property = global; //too much localSaved;
        }

        count = 0;
        for (Integer x : used)
            if (GlobalState.StateOfVReg[x].property == global)
                count++;
        while (count-- > 7){
            int min = 0;
            for (Integer x : used)
                if (GlobalState.StateOfVReg[x].property == global)
                    if (min == 0) min = x;
                    else if (GlobalState.StateOfVReg[min].times > GlobalState.StateOfVReg[x].times)
                        min = x;
            GlobalState.StateOfVReg[min].property = SaveInAddress; //to much globalRegister;
        }
    }

    public void save(){
        for (Integer x: used){
            Dic[GlobalState.StateOfVReg[x].property].add(x);
        }
    }

    public String toString(){
        String str = "# local:";
        for (Integer x: Dic[local]){
                str += " " + x.toString();
        }
        str += "\n";
        str += "# localSaved:";
        for (Integer x: Dic[localSaved]){
            str += " " + x.toString();
        }
        str += "\n";

        str += "# global:";
        for (Integer x: Dic[global]){
            str += " " + x.toString();
        }
        str += "\n";

        str += "# Save in address:";
        for (Integer x: Dic[SaveInAddress]){
            str += " " + x.toString();
        }
        str += "\n";
        str += "# times:";
        for (Integer x: total){
                str += " $" + x.toString() +": " + StateOfVReg[x].times + " ";
        }
        str += "\n";
        return str;
    }

    public int numToSave(){
        return Dic[SaveInAddress].size();
    }
}