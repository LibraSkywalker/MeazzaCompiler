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
public class BranchInstruction extends TernaryInstruction {
    String label;
    BranchInstruction(){}

    public int configure(Function func, LinkedList<Instruction> BlockStat, int position){
        rSrc1 = Translate(func,vSrc1);
        rSrc2 = Translate(func,vSrc2);
        if (rSrc1.equals("Memory")){
            int pos = func.localState.Dic[SaveInAddress].indexOf(vSrc1) * 4;
            Instruction now = new AddBinInstruction("lw",Rsrc1,s_p,pos);
            BlockStat.add(position,now);
            now.configure(func,BlockStat,position);
            rSrc1 = Rsrc1.toString();
            position++;
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

        if (rSrc2.equals("Memory")){
            int pos = func.localState.Dic[SaveInAddress].indexOf(vSrc2) * 4;
            Instruction now = new AddBinInstruction("lw",Rsrc2,s_p,pos);
            BlockStat.add(position,now);
            now.configure(func,BlockStat,position);
            rSrc2 = Rsrc2.toString();
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
        return position;
    }

    public BranchInstruction(String OP,int src1,int src2, String lbl,boolean isRegister){
        operator = OP;
        isReg = isRegister;
        vSrc1 = src1;
        if (isReg) vSrc2 = src2;
        else immediate = src2;
        label = lbl;
    }

    public BranchInstruction(CompareInstruction pre, BranchInstruction now){
        isReg = pre.isReg;
        vSrc1 = pre.vSrc1;
        vSrc2 = pre.vSrc2;
        immediate = pre.immediate;
        label = now.label;
        if (now.operator.equals("bne")){
            operator = "b" + pre.operator.substring(1);
        }
        else {
            switch (pre.operator){
                case "seq" : operator = "bne";
                    return;
                case "sne" : operator = "beq";
                    return;
                case "sge" : operator = "blt";
                    return;
                case "sle" : operator = "bgt";
                    return;
                case "sgt" : operator = "ble";
                    return;
                case "slt" : operator = "bge";
            }
        }
    }

    public String toString(){
        return operator + " " + "$" + rSrc1 + " " + (isReg ? "$" + rSrc2 : immediate) + " " + label + "\n";
    }

    public String virtualPrint(){
        return operator + " " + "$" + vSrc1 + " " + (isReg ? "$" + vSrc2 : immediate) + " " + label + "\n";
    }

    public void update(VirtualReadWrite usage){
        if (vSrc1 != null) usage.addReader(vSrc1);
        if (vSrc2 != null) usage.addReader(vSrc2);
    }

    @Override
    public void globalize(Function Func) {
        if (vSrc1 != null) Func.localState.update(vSrc1);
        if (vSrc2 != null) Func.localState.update(vSrc2);
    }
}
