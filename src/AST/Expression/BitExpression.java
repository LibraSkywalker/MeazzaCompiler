package AST.Expression;

import MIPS.Instruction.BinaryInstruction;
import MIPS.Instruction.FastInstruction;

import static MIPS.IRcontroler.getBlock;
import static RegisterControler.VirtualRegister.newVReg;

/**
 * Created by Bill on 2016/4/4.
 */
public class BitExpression extends BinaryExpression{
    public BitExpression(){}

    @Override
    public void set() {
        setProperties("int");
    }

    @Override
    public boolean check(){
        if (!leftAction.accept("int") || !rightAction.accept("int")){
            System.err.println("There should be integer expression beside the Bit operator");
            return false;
        }
        set();
        return true;
    }

    public void Translate(){
        leftAction.Translate();
        rightAction.Translate();

        int rSrc1 = leftAction.src();
        int Src2 = rightAction.src();
        boolean isReg = !rightAction.isLiteral();
        rDest = newVReg();

        if (leftAction.isLiteral())
            rSrc1 = ((Literal) leftAction).Reg();

        switch (operator){
            case "&" : getBlock().add(new FastInstruction("and", rDest, rSrc1, Src2, isReg));
                return;
            case "^" : getBlock().add(new FastInstruction("xor", rDest, rSrc1, Src2, isReg));
                return;
            case "|" : getBlock().add(new FastInstruction("or", rDest, rSrc1, Src2, isReg));
                return;
            case "<<" : getBlock().add(new FastInstruction("sll",rDest, rSrc1 , Src2, isReg));
                return;
            case ">>" : getBlock().add(new FastInstruction("srl",rDest,rSrc1, Src2, isReg));
        }
    }
}
