package MIPS;

import AST.Expression.CompareExpression;
import MIPS.Instruction.*;
import RegisterControler.RegisterStatic;
import RegisterControler.VirtualReadWrite;

import java.util.LinkedList;

import static MIPS.IRControler.state;
import static RegisterControler.ReservedRegister.global;
import static RegisterControler.ReservedRegister.local;

/**
 * Created by Bill on 2016/4/26.
 */
public class BasicBlock {
    String label;
    LinkedList<Instruction> BlockStat = new LinkedList<>();
    VirtualReadWrite usage = new VirtualReadWrite();

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

    void eliminate(){
        for (Instruction now : BlockStat){
            if (now instanceof BranchInstruction){
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
