package MIPS;

import MIPS.Instruction.*;
import RegisterControler.VirtualReadWrite;

import java.util.LinkedList;

import static RegisterControler.RegisterName.s_p;

/**
 * Created by Bill on 2016/4/26.
 */
public class BasicBlock {
    String label;
    public LinkedList<Instruction> BlockStat = new LinkedList<>();
    VirtualReadWrite usage = new VirtualReadWrite();

    public BasicBlock(){}

    public String getLabel() {
        return label;
    }

    public BasicBlock(String now){
        label = now;
    }

    public void addFirst(Instruction now) {
        BlockStat.addFirst(now);
    }

    public void cleanUp(int fsize){
        for (int i = 0; i < BlockStat.size(); i++){
            Instruction now = BlockStat.get(i);
            if (now instanceof JumpInstruction && now.operator.equals("jr")) {
                BlockStat.add(i, new ArithmeticInstruction("add", s_p, s_p, fsize, false));
                i++;
            }
        }
    }

    public void add(Instruction now){
        BlockStat.add(now);
    }

    void eliminate(){
        for (Instruction now : BlockStat){
            if (now instanceof BranchInstruction){
                if (BlockStat.indexOf(now) == 0) continue;
                Instruction pre = BlockStat.get(BlockStat.indexOf(now) - 1);
                if (pre instanceof CompareInstruction){
                    Instruction next = new BranchInstruction((CompareInstruction) pre,(BranchInstruction) now);
                    BlockStat.add(BlockStat.indexOf(now),next);
                    BlockStat.remove(now);
                    BlockStat.remove(pre);
                }
            }
        }
    }

    void configure(){
        for(int i = 0; i < BlockStat.size();){
            Instruction now = BlockStat.get(i);
            now.configure();
            i = (BlockStat.contains(now)) ? BlockStat.indexOf(now) + 1 : i;
        }
    }

    void update(){
        for (Instruction now : BlockStat){
            now.update(usage);
        }
    }

    String printUsage(){
        return usage.toString();
    }

    @Override
    public String toString(){
        String str = label + ":\n";
        for (Instruction now : BlockStat){
            str += "\t";
            str += now.toString();
        }
        return str;
    }
    public String virtualPrint(){
        String str = label + ":\n";
        for (Instruction now : BlockStat){
            str += "\t";
            str += now.virtualPrint();
        }
        return str;
    }

    public void globalize(Function Func){
        for (Instruction now : BlockStat){
            now.globalize(Func);
        }
    }
}
