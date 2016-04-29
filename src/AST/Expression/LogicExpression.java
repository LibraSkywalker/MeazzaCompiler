package AST.Expression;

import MIPS.Instruction.FastInstruction;

import static MIPS.IRcontroler.getBlock;
import static RegisterControler.VirtualRegister.newVReg;

/**
 * Created by Bill on 2016/4/6.
 */
public class LogicExpression extends BinaryExpression{
    public LogicExpression(){}

    @Override
    public void set(){
        properties.setProperties("bool");
    }

    public boolean check(){
        if (!leftAction.accept("bool") || !rightAction.accept("bool")){
            System.err.println("There should be boolean expression beside the Logic operator: ");
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
            case "&&": getBlock().add(new FastInstruction("and", rDest, rSrc1, Src2, isReg));
                return;
            case "||": getBlock().add(new FastInstruction("or", rDest, rSrc1, Src2, isReg));
        }
    }
}
