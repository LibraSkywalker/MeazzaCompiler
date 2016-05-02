package AST.Expression;


import MIPS.Instruction.AddBinInstruction;
import MIPS.Instruction.RegTerInstruction;

import static MIPS.IRControler.addInstruction;
import static MIPS.IRControler.getBlock;
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
            case "==": getBlock().add(new RegTerInstruction("seq", rDest, rSrc1, Src2, isReg));
                return;
            case "!=": getBlock().add(new RegTerInstruction("sne", rDest, rSrc1, Src2, isReg));
                return;
            case ">=": getBlock().add(new RegTerInstruction("sge", rDest, rSrc1, Src2, isReg));
                return;
            case "<=": getBlock().add(new RegTerInstruction("sle", rDest, rSrc1, Src2, isReg));
                return;
            case ">" : getBlock().add(new RegTerInstruction("sgt", rDest, rSrc1, Src2, isReg));
                return;
            case "<" : getBlock().add(new RegTerInstruction("slt", rDest, rSrc1, Src2, isReg));
        }
    }

    public void StringTranslate(){
        rDest = newVReg();
        int rSrc1 = leftAction.src();

        int rSrc2 = rightAction.src();
        if (rightAction.isLiteral()){
            rSrc1 = newVReg();
            addInstruction(new AddBinInstruction("la",rSrc1,((Literal) rightAction).memName()));
        }
        jaja
    }
}
