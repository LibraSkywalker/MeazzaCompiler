package MIPS.Instruction;

import MIPS.Function;
import RegisterControler.VirtualReadWrite;

import java.util.LinkedList;

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

    public int configure(Function func, LinkedList<Instruction> BlockStat, int position){
        rSrc = Translate(func,vSrc);
        rDest = Translate(func,vDest);
        if (rDest.equals("")) { //delete
            BlockStat.remove(this);
            return position - 1;
        }
        if (rSrc.equals("Memory")){
            int pos = func.localState.Dic[SaveInAddress].indexOf(vSrc) * 4;
            Instruction now = new AddBinInstruction("lw",Rsrc1,s_p,pos);
            BlockStat.add(position,now);
            now.configure(func,BlockStat,position);
            rSrc = Rsrc1.toString();
            position++;
        }
        if (rDest.equals("Memory")){
            int pos = func.localState.Dic[SaveInAddress].indexOf(vDest) * 4;
            Instruction now = new AddBinInstruction("sw",Rdest,s_p,pos);
            BlockStat.add(position + 1,now);
            now.configure(func,BlockStat,position + 1);
            rDest = Rdest.toString();
            position++;
        }
        return position;
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
