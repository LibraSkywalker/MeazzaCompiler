package AST.Expression;

import MIPS.Instruction.FastInstruction;

import static MIPS.IRcontroler.getBlock;
import static RegisterControler.VirtualRegister.newVReg;

/**
 * Created by Bill on 2016/4/6.
 */
public class CalcExpression extends BinaryExpression {

    @Override
    public void set(){
        setProperties(leftAction.properties);
    }

    @Override
    public boolean check(){
        if (!leftAction.accept(rightAction)){
            return false;
        }
        set();
        if (!properties.accept("int") && !properties.accept("string")) {
            System.err.println("this calc operation should be done on 'int' or 'string' ");
            return false;
        }
        if (!operator.equals("+") && properties.accept("string")){
            System.err.println("this calc operation should be done on 'int'");
            return false;
        }
        else  return true;
    }

    public void Translate(){
        //translate string
        leftAction.Translate();
        rightAction.Translate();

        rDest = newVReg();
        int rSrc1 = leftAction.src();
        if (leftAction.isLiteral())
            rSrc1 = ((Literal) leftAction).Reg();
        int Src2 = rightAction.src();
        boolean isReg = !rightAction.isLiteral();

        switch (operator){
            case "+": getBlock().add(new FastInstruction("add", rDest, rSrc1, Src2, isReg));
                return;
            case "-": getBlock().add(new FastInstruction("sub", rDest, rSrc1, Src2, isReg));
                return;
            case "*": getBlock().add(new FastInstruction("mul", rDest, rSrc1, Src2, isReg));
                return;
            case "/": getBlock().add(new FastInstruction("div", rDest, rSrc1, Src2, isReg));
                return;
            case "%": getBlock().add(new FastInstruction("rem", rDest, rSrc1, Src2, isReg));
        }
    }
}
