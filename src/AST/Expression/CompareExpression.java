package AST.Expression;


import MIPS.Instruction.*;

import static MIPS.IRControler.addInstruction;
import static RegisterControler.RegisterName.a_0;
import static RegisterControler.RegisterName.v_0;
import static RegisterControler.VirtualRegister.newVReg;

/**
 * Created by Bill on 2016/4/4.
 */
public class CompareExpression extends BinaryExpression{
    public CompareExpression(){
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
        if (leftAction.accept("string")){
            StringTranslate();
            return;
        }
        rDest = newVReg();
        int rSrc1 = leftAction.src();
        if (leftAction.isLiteral())
            rSrc1 = ((Literal) leftAction).Reg();
        int Src2 = rightAction.src();
        boolean isReg = !rightAction.isLiteral();

        switch (operator){
            case "==": addInstruction(new CompareInstruction("seq", rDest, rSrc1, Src2, isReg));
                return;
            case "!=": addInstruction(new CompareInstruction("sne", rDest, rSrc1, Src2, isReg));
                return;
            case ">=": addInstruction(new CompareInstruction("sge", rDest, rSrc1, Src2, isReg));
                return;
            case "<=": addInstruction(new CompareInstruction("sle", rDest, rSrc1, Src2, isReg));
                return;
            case ">" : addInstruction(new CompareInstruction("sgt", rDest, rSrc1, Src2, isReg));
                return;
            case "<" : addInstruction(new CompareInstruction("slt", rDest, rSrc1, Src2, isReg));
        }
    }

    public void StringTranslate(){
        int delta = 0;
        if (operator.equals(">") || operator.equals("<=")) delta = 1;
        if (leftAction.isLiteral()){
            addInstruction(new AddBinInstruction("la",a_0 + delta,((Literal) leftAction).memName()));
        }
        else addInstruction(new RegBinInstruction("move",a_0 + delta,leftAction.src(),true));
        if (rightAction.isLiteral()){
            addInstruction(new AddBinInstruction("la",a_0 + 1 - delta,((Literal) rightAction).memName()));
        }
        else addInstruction(new RegBinInstruction("move",a_0 + 1 - delta,rightAction.src(),true));

        // choose order

        if (operator.equals("!=") || operator.equals("==")){
            addInstruction(new JumpInstruction("Jal","func__stringIsEqual"));
        } else {
            addInstruction(new JumpInstruction("Jal","func__stringLess"));
        }

        // choose operation

        rDest = newVReg();
        if (operator.equals("==") || operator.equals("<") || operator.equals(">"))
            addInstruction(new RegBinInstruction("move",rDest,v_0,true));
        else
            addInstruction(new ArithmeticInstruction("xor",rDest,v_0,1,false));

        // choose result to take
    }
}
