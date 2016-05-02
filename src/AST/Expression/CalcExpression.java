package AST.Expression;

import MIPS.Instruction.AddBinInstruction;
import MIPS.Instruction.RegTerInstruction;

import static MIPS.IRControler.addInstruction;
import static MIPS.IRControler.getBlock;
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
            case "+": getBlock().add(new RegTerInstruction("add", rDest, rSrc1, Src2, isReg));
                return;
            case "-": getBlock().add(new RegTerInstruction("sub", rDest, rSrc1, Src2, isReg));
                return;
            case "*": getBlock().add(new RegTerInstruction("mul", rDest, rSrc1, Src2, isReg));
                return;
            case "/": getBlock().add(new RegTerInstruction("div", rDest, rSrc1, Src2, isReg));
                return;
            case "%": getBlock().add(new RegTerInstruction("rem", rDest, rSrc1, Src2, isReg));
        }
    }

    public void StringTranslate(){
        int rSrc1 = leftAction.src();
        if (leftAction.isLiteral()){
            rSrc1 = newVReg();
            addInstruction(new AddBinInstruction("la",rSrc1,((Literal) leftAction).memName()));
        }

        int rSrc2 = rightAction.src();
        if (rightAction.isLiteral()){
            rSrc1 = newVReg();
            addInstruction(new AddBinInstruction("la",rSrc1,((Literal) rightAction).memName()));
        }


    }
}
