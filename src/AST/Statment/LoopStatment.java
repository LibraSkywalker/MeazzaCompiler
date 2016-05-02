package AST.Statment;

import AST.Expression.Literal;
import MIPS.BasicBlock;
import MIPS.Instruction.BranchInstruction;
import MIPS.Instruction.JumpInstruction;
import SymbolContainer.Scope;

import static MIPS.IRControler.addBlock;
import static MIPS.IRControler.addInstruction;
import static MIPS.IRControler.getBlock;

/**
 * Created by Bill on 2016/4/4.
 */
public class LoopStatment extends SpecialStatment {
    public void getField(Scope now){
        field = now;
        field.setLoop();
    }

    public void Translate(){
        BasicBlock block1 = getBlock(),block2,block3;

        control.Translate();
        int rSrc1 = control.src(),rSrc2;
        if (control.isLiteral()) rSrc1 = ((Literal) control).Reg();

        addBlock(block1,"loop");
        block2 = getBlock();

        field.Translate();
        control.Translate();
        rSrc2 = control.src();
        if (control.isLiteral()) rSrc2 = ((Literal) control).Reg();

        addBlock();
        block3 = getBlock();

        block1.add(new BranchInstruction("beq",rSrc1,0,block3.getLabel(),false));
        block2.add(new BranchInstruction("beq",rSrc2,0,block3.getLabel(),false));
        block2.add(new JumpInstruction("b",block2.getLabel()));
    }
}
