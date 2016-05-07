package AST.Expression;

import MIPS.Instruction.AddBinInstruction;
import MIPS.Instruction.ArithmeticInstruction;
import MIPS.Instruction.JumpInstruction;
import MIPS.Instruction.RegBinInstruction;

import static MIPS.IRControler.addInstruction;
import static MIPS.IRControler.getBlock;
import static RegisterControler.RegisterName.a_0;
import static RegisterControler.RegisterName.v_0;
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

        System.out.println(rSrc1 + "\n" +Src2 + "\n"+ isReg + "\n" + leftAction + "\n" + rightAction);
        switch (operator){
            case "+": addInstruction(new ArithmeticInstruction("add", rDest, rSrc1, Src2, isReg));
                return;
            case "-": getBlock().add(new ArithmeticInstruction("sub", rDest, rSrc1, Src2, isReg));
                return;
            case "*": getBlock().add(new ArithmeticInstruction("mul", rDest, rSrc1, Src2, isReg));
                return;
            case "/": getBlock().add(new ArithmeticInstruction("div", rDest, rSrc1, Src2, isReg));
                return;
            case "%": getBlock().add(new ArithmeticInstruction("rem", rDest, rSrc1, Src2, isReg));
        }
    }

    public void StringTranslate(){
        if (leftAction.isLiteral()){
            addInstruction(new AddBinInstruction("la",a_0,((Literal) leftAction).memName()));
        }
        else addInstruction(new RegBinInstruction("move",a_0,leftAction.src(),true));
        if (rightAction.isLiteral()){
            addInstruction(new AddBinInstruction("la",a_0 + 1,((Literal) rightAction).memName()));
        }
        else addInstruction(new RegBinInstruction("move",a_0 + 1,leftAction.src(),true));
        addInstruction(new JumpInstruction("jal","func_stringConcatenate"));
        rDest = newVReg();
        addInstruction(new RegBinInstruction("move",rDest,v_0,true));
    }
}
