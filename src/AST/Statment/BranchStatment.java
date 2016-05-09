package AST.Statment;

import AST.Expression.Literal;
import MIPS.BasicBlock;
import MIPS.Instruction.BranchInstruction;
import MIPS.Instruction.JumpInstruction;
import SymbolContainer.Scope;

import static AST.ASTControler.getCurrentScope;
import static MIPS.IRControler.*;

/**
 * Created by Bill on 2016/4/7.
 */
public class BranchStatment extends SpecialStatment {
    Scope field2;
    boolean useless = false;

    public void setField(Scope now){
        field = now;
        field.setBranch();
    }
    public void setField2(Scope now) {
        field2 = now;
        field2.setBranch();
    }
    public Scope field2(){
        return field2;
    }
    public void checkReturn(){
        if (!field.contains("+")) return;
        if (field2 != null && field2.contains("+")) ;
        getCurrentScope().findBranch().putReservedKey("+");
    }

    public void Translate(){
        int imm = 0;
        if (field == null){
            imm = 1;
            field = field2;
            field2 = null;
        }
        if (field == null){
            useless = true;
            return;
        }

        control.Translate();
        int rSrc = control.src();
        if (control.isLiteral()) rSrc = ((Literal) control).Reg();

        // block1->entry block2->else block3->then block4->exit

        BasicBlock block1 = getBlock();

        addBlock(block1,"branch_else");
        BasicBlock block2 = getBlock();

        addBlock(block1,"branch_then");
        BasicBlock block3 = getBlock();

        addBlock(block1,"afterBranch");
        BasicBlock block4 = getBlock();

        visitBlock(block1);
        addInstruction(new BranchInstruction("bne",rSrc,imm,block3.getLabel(),false)); // else or then

        visitBlock(block2);
        if (field2 != null) field2.Translate();
        addInstruction(new JumpInstruction("b",block4.getLabel())); //block1_else to block3

        visitBlock(block3);
        field.Translate();

        visitBlock(block4);
    }
}
