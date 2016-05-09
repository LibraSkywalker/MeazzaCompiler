package MIPS.Instruction;

import MIPS.Function;
import RegisterControler.VirtualReadWrite;

import java.util.LinkedList;

import static MIPS.IRControler.getBlock;
import static MIPS.IRControler.getFunction;
import static RegisterControler.RegisterName.*;
import static RegisterControler.RegisterName.Rsrc1;
import static RegisterControler.RegisterName.s_p;

/**
 * Created by Bill on 2016/4/26.
 */
public class RegBinInstruction extends BinaryInstruction{
    Integer vSrc,immediate;
    String rSrc;
    RegBinInstruction(){}

    public RegBinInstruction(String OP, int dest, int src, boolean isRegister){
        operator = OP;
        vDest = dest;
        isReg = isRegister;
        if (isReg) vSrc = src;
        else immediate = src;
    }

    public void configure(){
        rSrc = Translate(vSrc);
        rDest = Translate(vDest);
        if (rDest.equals("")) { //delete
            getBlock().BlockStat.remove(this);
            return;
        }

        if (rSrc.equals("Memory")){
            int pos = getFunction().localState.Dic[SaveInAddress].indexOf(vSrc) * 4;
            Instruction now = new AddBinInstruction("lw",Rsrc1,s_p,pos);
            getBlock().BlockStat.add(getBlock().BlockStat.indexOf(this),now);
            now.configure();
            rSrc = Rsrc1.toString();
        }

        if (rDest.equals("Memory")){
            int pos = getFunction().localState.Dic[SaveInAddress].indexOf(vDest) * 4;
            Instruction now = new AddBinInstruction("sw",Rdest,s_p,pos);
            getBlock().BlockStat.add(getBlock().BlockStat.indexOf(this) + 1,now);
            rDest = Rdest.toString();
        }
    }

    public String toString(){
        return operator + " " + "$" + rDest + " " + ( isReg ? "$" + rSrc : immediate) +"\n";
    }

    public String virtualPrint(){
        return operator + " " + "$" + vDest + " " + ( isReg ? "$" + vSrc : immediate) +"\n";
    }



    public void update(VirtualReadWrite usage){
        if (vSrc != null) usage.addReader(vSrc);
        usage.addWriter(vDest);
    }

    @Override
    public void globalize(Function Func) {
        if (vSrc != null) Func.localState.update(vSrc);
        Func.localState.set(vDest);
    }
}
