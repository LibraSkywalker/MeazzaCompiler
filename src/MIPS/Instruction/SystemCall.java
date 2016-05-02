package MIPS.Instruction;

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
}
