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
public class ArithmeticInstruction extends TernaryInstruction{
    Integer vDest;
    String rDest;
    ArithmeticInstruction(){}
    public ArithmeticInstruction(String OP, int dest, int src1, int src2, boolean isRegister){
        operator = OP;
        isReg = isRegister;
        vDest = dest;
        vSrc1 = src1;
        if (isReg) vSrc2 = src2;
        else immediate = src2;
    }


    public void configure(){
        rSrc1 = Translate(vSrc1);
        rSrc2 = Translate(vSrc2);
        rDest = Translate(vDest);
        if (rDest.equals("")) { //delete
            getBlock().BlockStat.remove(this);
            return;
        }
        if (rSrc1.equals("Memory")){
            int pos = getFunction().localState.Dic[SaveInAddress].indexOf(vSrc1) * 4;
            Instruction now = new AddBinInstruction("lw",Rsrc1,s_p,pos);
            getBlock().BlockStat.add(getBlock().BlockStat.indexOf(this),now);
            now.configure();
            rSrc1 = Rsrc1.toString();
        }

        if (rSrc2.equals("Memory")){
            int pos = getFunction().localState.Dic[SaveInAddress].indexOf(vSrc2) * 4;
            Instruction now = new AddBinInstruction("lw",Rsrc2,s_p,pos);
            getBlock().BlockStat.add(getBlock().BlockStat.indexOf(this),now);
            now.configure();
            rSrc2 = Rsrc2.toString();
        }
        if (rDest.equals("Memory")){
            int pos = getFunction().localState.Dic[SaveInAddress].indexOf(vDest) * 4;
            Instruction now = new AddBinInstruction("sw",Rdest,s_p,pos);
            getBlock().BlockStat.add(getBlock().BlockStat.indexOf(this) + 1,now);
            rDest = Rdest.toString();
        }
    }

    public String toString(){
        return operator + " " + "$" + rDest + " " + "$" + rSrc1 + " " + (isReg ? "$" + rSrc2 : immediate) + "\n";
    }

    public String virtualPrint(){
        return operator + " " + "$" + vDest + " " + "$" + vSrc1 + " " + (isReg ? "$" + vSrc2 : immediate) + "\n";
    }

    public void update(VirtualReadWrite usage){
        if (vSrc1 != null) usage.addReader(vSrc1);
        if (vSrc2 != null) usage.addReader(vSrc2);
        usage.addWriter(vDest);
    }

    @Override
    public void globalize(Function Func) {
        if (vSrc1 != null) Func.localState.update(vSrc1);
        if (vSrc2 != null) Func.localState.update(vSrc2);
        Func.localState.set(vDest);
    }
}
