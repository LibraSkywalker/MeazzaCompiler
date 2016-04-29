package AST.Expression;


import MIPS.Instruction.FastInstruction;

import static MIPS.IRcontroler.getBlock;
import static RegisterControler.VirtualRegister.newVReg;

/**
 * Created by Bill on 2016/4/4.
 */
public class EqualExpression extends BinaryExpression{
    public EqualExpression(){
    }

    @Override
    public void set(){
        setProperties("bool");
    }

    public boolean check(){
        if (!leftAction.accept(rightAction)) return false;
        if (operator.equals("!=")  || operator.equals("==")) {
            set();
            return true;
        }
        if (!leftAction.accept("int")) {
            System.err.println("There should be integer expression beside the partial operator");
            return false;
        }
        set();
        return true;
    }

    public void Translate(){
        leftAction.Translate();
        rightAction.Translate();

        rDest = newVReg();
        int rSrc1 = leftAction.src();
        if (leftAction.isLiteral())
            rSrc1 = ((Literal) leftAction).Reg();
        int Src2 = rightAction.src();
        boolean isReg = !rightAction.isLiteral();

        switch (operator){
            case "==": getBlock().add(new FastInstruction("seq", rDest, rSrc1, Src2, isReg));
                return;
            case "!=": getBlock().add(new FastInstruction("sne", rDest, rSrc1, Src2, isReg));
                return;
            case ">=": getBlock().add(new FastInstruction("sge", rDest, rSrc1, Src2, isReg));
                return;
            case "<=": getBlock().add(new FastInstruction("sle", rDest, rSrc1, Src2, isReg));
                return;
            case ">" : getBlock().add(new FastInstruction("sgt", rDest, rSrc1, Src2, isReg));
                return;
            case "<" : getBlock().add(new FastInstruction("slt", rDest, rSrc1, Src2, isReg));
        }
    }
}
