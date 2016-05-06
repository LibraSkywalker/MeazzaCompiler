package RegisterControler;

import java.util.ArrayList;

import static RegisterControler.ReservedRegister.*;

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
    public int[] propertyofVReg = new  int[500000];
   state[] ColorVReg = new state[500000];
    state currentColor = new state();
    ArrayList<Integer> used = new ArrayList<>();
    public void load(VirtualReadWrite usage){
        for (Integer x : usage.reader){
            if (propertyofVReg[x] == 0){
                propertyofVReg[x] = local;
                used.add(x);
            }
            else {
                if (propertyofVReg[x] < localSaved)
                    propertyofVReg[x] = localSaved;
            }
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
        System.out.println("color change from " + ColorVReg[x] + " to " + currentColor);
        ColorVReg[x] = currentColor.copy();
    }

    public void update(int x){
        System.out.println("Register $" + x + " visited");

        if (x < 32){
            propertyofVReg[x] = globalSaved;
            return;
        }
        System.out.println("color: " + ColorVReg[x] + " required: " + currentColor);
        if (ColorVReg[x].selfColor != currentColor.selfColor){
            propertyofVReg[x] = globalSaved;
        } else {
            if (ColorVReg[x].color != currentColor.color && propertyofVReg[x] < global){
                propertyofVReg[x] = global;
            }
        }
    }

    public String toString(){
        String str = "# local:";
        for (Integer x: used){
            if (propertyofVReg[x] == local)
                str += " " + x.toString();
        }
        str += "\n";
        str += "# localSaved:";
        for (Integer x: used){
            if (propertyofVReg[x] == localSaved)
                str += " " + x.toString();
        }
        str += "\n";

        str += "# global:";
        for (Integer x: used){
            if (propertyofVReg[x] == global)
                str += " " + x.toString();
        }
        str += "\n";

        str += "# globalSaved:";
        for (Integer x: used){
            if (propertyofVReg[x] == globalSaved)
                str += " " + x.toString();
        }
        str += "\n";
        return str;
    }
}