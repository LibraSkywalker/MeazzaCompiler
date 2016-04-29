package MIPS.Instruction;

/**
 * Created by Bill on 2016/4/26.
 */
public class BranchInstruction extends TernaryInstruction {
    String label;
    BranchInstruction(){}
    public BranchInstruction(String OP,int src1,int src2, String lbl,boolean isRegister){
        operator = OP;
        isReg = isRegister;
        vSrc1 = src1;
        if (isReg) vSrc2 = src2;
        else immediate = src2;
        label = lbl;
    }

    public String toString(){
        return operator + " " + "$" + rSrc1 + " " + (isReg ? "$" + rSrc2 : immediate) + " " + label;
    }

    public String virtualPrint(){
        return operator + " " + "$" + vSrc1 + " " + (isReg ? "$" + vSrc2 : immediate) + " " + label;
    }
}
