package MIPS.Instruction;

import MIPS.Function;
import RegisterControler.VirtualReadWrite;

import java.util.LinkedList;

import static RegisterControler.RegisterName.*;
import static RegisterControler.RegisterName.Rdest;
import static RegisterControler.RegisterName.s_p;

/**
 * Created by Bill on 2016/4/26.
 */
public class CompareInstruction extends TernaryInstruction{
    Integer vDest;
    String rDest;
    CompareInstruction(){}
    public CompareInstruction(String OP, int dest, int src1, int src2, boolean isRegister){
        operator = OP;
        isReg = isRegister;
        vDest = dest;
        vSrc1 = src1;
        if (isReg) vSrc2 = src2;
        else immediate = src2;
    }

    public int configure(Function func, LinkedList<Instruction> BlockStat, int position){
        rSrc1 = Translate(func,vSrc1);
        rSrc2 = Translate(func,vSrc2);
        rDest = Translate(func,vDest);
        if (rDest.equals("")) { //delete
            BlockStat.remove(this);
            return position - 1;
        }

        if (rSrc1.equals("localMemory")){
            int pos = func.localState.Dic[local].indexOf(vSrc1) * 4;
            Instruction now1 = new AddBinInstruction("la",Rsrc1,"VReg");
            Instruction now2 = new AddBinInstruction("lw",Rsrc1,Rsrc1,pos);
            BlockStat.add(position,now2);
            now2.configure(func,BlockStat,position);
            BlockStat.add(position,now1);
            now1.configure(func,BlockStat,position);
            rSrc1 = Rsrc1.toString();
            position += 2;
        }

        if (rSrc1.equals("Memory")){
            int pos = func.localState.Dic[SaveInAddress].indexOf(vSrc1) * 4;
            Instruction now = new AddBinInstruction("lw",Rsrc1,s_p,pos);
            BlockStat.add(position,now);
            now.configure(func,BlockStat,position);
            rSrc1 = Rsrc1.toString();
            position++;
        }

        if (rSrc2.equals("localMemory")){
            int pos = func.localState.Dic[local].indexOf(vSrc2) * 4;
            Instruction now1 = new AddBinInstruction("la",Rsrc2,"VReg");
            Instruction now2 = new AddBinInstruction("lw",Rsrc2,Rsrc2,pos);
            BlockStat.add(position,now2);
            now2.configure(func,BlockStat,position);
            BlockStat.add(position,now1);
            now1.configure(func,BlockStat,position);
            rSrc2 = Rsrc2.toString();
            position += 2;
        }
        if (rSrc2.equals("Memory")){
            int pos = func.localState.Dic[SaveInAddress].indexOf(vSrc2) * 4;
            Instruction now = new AddBinInstruction("lw",Rsrc2,s_p,pos);
            BlockStat.add(position,now);
            now.configure(func,BlockStat,position);
            rSrc2 = Rsrc2.toString();
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
        if (rDest.equals("localMemory")){
            int pos = func.localState.Dic[local].indexOf(vDest) * 4;
            Instruction now1 = new AddBinInstruction("la",Rsrc1,"VReg");
            Instruction now2 = new AddBinInstruction("sw",Rdest,Rsrc1,pos);
            BlockStat.add(position + 1,now1);
            BlockStat.add(position + 2,now2);
            now2.configure(func,BlockStat,position + 2);
            now1.configure(func,BlockStat,position + 1);
            rDest = Rdest.toString();
            position += 2;
        }
        return position;
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
