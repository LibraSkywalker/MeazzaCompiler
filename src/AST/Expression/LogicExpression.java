package AST.Expression;

import MIPS.BasicBlock;
import MIPS.Instruction.*;

import static MIPS.IRControler.*;
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

        String op = operator.equals("||") ? "bne" : "beq";
        String op2 = operator.equals("||") ? "beq" : "bne";
        int res1 = operator.equals("||") ? 1 : 0;
        int res2 = operator.equals("&&") ? 1 : 0;


        int rSrc1 = leftAction.src();
        if (leftAction.isLiteral())
            rSrc1 = ((Literal) leftAction).Reg();

        rDest = newVReg();

        BasicBlock block1 = getBlock();
        String Name = block1.getLabel();
       // System.err.println(Name.substring(Name.length() - 6));
        if (Name.substring(Name.length() - 6).equals("normal")){
            while (Name.substring(Name.length() - 6).equals("normal"))
                Name = Name.substring(0, Name.length() - 7);
            addInstruction(new BranchInstruction(op,rSrc1,0,Name + "_shortcut",false));
            addBlock(block1,"normal");
            rightAction.Translate();


            int rSrc2 = rightAction.src();
            if (rightAction.isLiteral())
                rSrc2 = ((Literal) rightAction).Reg();

            if (!(rightAction instanceof LogicExpression))
                addInstruction(new BranchInstruction(op2, rSrc2, 0, Name + "_normalEnd", false));
        } else {
            addInstruction(new BranchInstruction(op, rSrc1, 0, Name + "_shortcut", false));
            addBlock(block1, "normal");
            rightAction.Translate();

            int rSrc2 = rightAction.src();
            if (rightAction.isLiteral())
                rSrc2 = ((Literal) rightAction).Reg();

            if (!(rightAction instanceof LogicExpression))
                addInstruction(new BranchInstruction(op2, rSrc2, 0, Name + "_normalEnd", false));

            addBlock(block1, "shortcut");

            addInstruction(new RegBinInstruction("li", rDest, res1, false));
            addInstruction(new JumpInstruction("b", Name + "_next"));

            addBlock(block1, "normalEnd");

            addInstruction(new RegBinInstruction("li", rDest, res2, false));

            addBlock(block1, "next");

        }
    }
}
