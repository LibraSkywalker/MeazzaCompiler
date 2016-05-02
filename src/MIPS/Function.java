package MIPS;

import MIPS.BasicBlock;

import java.util.ArrayList;
import java.util.LinkedList;

/**
 * Created by Bill on 2016/4/28.
 */
public class Function {
    LinkedList<BasicBlock> basicBlocks = new LinkedList<>();
    static BasicBlock currentBasicBlock;
    Integer number = 0;
    String FuncName;

    BasicBlock getCurrentBasicBlock() {
        return currentBasicBlock;
    }

    Function(String name) {
        FuncName = name;
        addBasicBlock("");
    }


    public BasicBlock addBasicBlock(){
        BasicBlock now = new BasicBlock(FuncName + "_"+ ++number);
        basicBlocks.add(now);
        currentBasicBlock = now;
        return now;
    }

    public BasicBlock addBasicBlock(String name){
        BasicBlock now = new BasicBlock(FuncName + name);
        basicBlocks.add(now);
        currentBasicBlock = now;
        return now;
    }

    public BasicBlock addBasicBlock(BasicBlock preBlock,String name){
        BasicBlock now = new BasicBlock(preBlock.getLabel() + "_" + name);
        basicBlocks.add(now);
        currentBasicBlock = now;
        return now;
    }
    public String toString(){
        String str = "";
        for (BasicBlock now : basicBlocks){
            str += "\t" + now.toString();
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
