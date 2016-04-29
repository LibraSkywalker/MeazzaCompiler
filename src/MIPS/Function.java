package MIPS;

import MIPS.BasicBlock;

import java.util.ArrayList;

/**
 * Created by Bill on 2016/4/28.
 */
public class Function {
    ArrayList<BasicBlock> basicBlocks = new ArrayList<>();
    Integer number = 0;
    String FuncName;
    public Function(){}
    public Function(String name){
        FuncName = name;
    }

    public BasicBlock addBasicBlock(){
        BasicBlock now = new BasicBlock(FuncName + number);
        basicBlocks.add(now);
        number++;
        return now;
    }

    public String toString(){
        String str = "";
        for (BasicBlock now : basicBlocks){
            str += now.toString();
            str += "\n";
        }
        return str;
    }

    public String virtualPrint(){
        String str = "";
        for (BasicBlock now : basicBlocks){
            str += now.virtualPrint();
            str += "\n";
        }
        return str;
    }
}
