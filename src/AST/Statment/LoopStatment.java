package AST.Statment;

import AST.Expression.ExpressionAction;
import AST.Expression.Literal;
import MIPS.BasicBlock;
import MIPS.Instruction.BranchInstruction;
import MIPS.Instruction.JumpInstruction;
import SymbolContainer.Scope;

import static AST.ASTControler.endScope;
import static AST.ASTControler.getCurrentScope;
import static AST.ASTControler.visitScope;
import static MIPS.IRControler.*;

/**
 * Created by Bill on 2016/4/4.
 */
public class LoopStatment extends SpecialStatment {
    ExpressionAction looper;
    public void setField(Scope now){
        field = now;
        field.setLoop();
    }

    public void setLooper(ExpressionAction _looper){
        looper = _looper;
    }

    public void Translate(){
        BasicBlock block1 = getBlock(),block2,block3,block4;
        addBlock(block1,"loop");
        block2 = getBlock();
        addBlock(block1,"loopTail");
        block3 = getBlock();
        addBlock(block1,"next");
        block4 = getBlock();

        visitBlock(block1);
        if (control != null) {
            control.Translate();
            int rSrc1 = control.src();
            if (control.isLiteral()) rSrc1 = ((Literal) control).Reg();
            addInstruction(new BranchInstruction("beq",rSrc1,0,block4.getLabel(),false)); //block 1 -> block2 or block4

        }

        visitBlock(block2);
        field.Translate();  // block2 -> block3

        visitBlock(block3);
        if (looper != null) looper.Translate();
        if (control != null){
            int rSrc2;
            control.Translate();
            rSrc2 = control.src();
            if (control.isLiteral()) rSrc2 = ((Literal) control).Reg();
            addInstruction(new BranchInstruction("bne",rSrc2,0,block2.getLabel(),false)); // block3 -> block2 or block4
        }

        visitBlock(block4);
    }
}
