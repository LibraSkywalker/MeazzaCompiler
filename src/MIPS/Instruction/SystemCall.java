package MIPS.Instruction;

import MIPS.Function;
import RegisterControler.VirtualReadWrite;

import java.util.LinkedList;

/**
 * Created by Bill on 2016/5/2.
 */
public class SystemCall extends Instruction{
    public String virtualPrint(){
        return "syscall\n";
    }

    public String toString(){
        return "syscall\n";
    }

    public int configure(Function func, LinkedList<Instruction> BlockStat, int position){
        return position;
    }

    public void update(VirtualReadWrite usage){
    }

    @Override
    public void globalize(Function Func) {

    }
}
