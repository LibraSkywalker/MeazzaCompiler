package MIPS;

import MIPS.Instruction.Instruciton;

import java.util.LinkedList;

/**
 * Created by Bill on 2016/4/26.
 */
public class BasicBlock {
    String label;
    LinkedList<Instruciton> BlockStat = new LinkedList<>();

    public BasicBlock(){}

    public BasicBlock(String now){
        label = now;
    }

    public void add(Instruciton now){
        BlockStat.add(now);
    }

    @Override
    public String toString(){
        String str = label + ":\n";
        for (Instruciton now : BlockStat){
            str += now.toString();
        }
        return str;
    }
    public String virtualPrint(){
        String str = label + ":\n";
        for (Instruciton now : BlockStat){
            str += now.virtualPrint();
        }
        return str;
    }
}
