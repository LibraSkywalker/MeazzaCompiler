package MIPS;

import MIPS.Instruction.Instruction;

import java.util.LinkedList;

/**
 * Created by Bill on 2016/4/26.
 */
public class BasicBlock {
    String label;
    LinkedList<Instruction> BlockStat = new LinkedList<>();

    public BasicBlock(){}

    public String getLabel() {
        return label;
    }

    public BasicBlock(String now){
        label = now;
    }

    public void add(Instruction now){
        BlockStat.add(now);
    }

    @Override
    public String toString(){
        String str = label + ":\n";
        for (Instruction now : BlockStat){
            str += now.toString();
        }
        return str;
    }
    public String virtualPrint(){
        String str = label + ":\n";
        for (Instruction now : BlockStat){
            str += now.virtualPrint();
        }
        return str;
    }
}
