package AST.Statment;

import AST.Expression.Literal;
import MIPS.BasicBlock;
import MIPS.Instruction.BranchInstruction;
import MIPS.Instruction.JumpInstruction;
import MIPS.Instruction.RegBinInstruction;
import MIPS.Instruction.RegTerInstruction;
import SymbolContainer.Scope;

import static AST.ASTControler.getCurrentScope;
import static MIPS.IRControler.addBlock;
import static MIPS.IRControler.addInstruction;
import static MIPS.IRControler.getBlock;

/**
 * Created by Bill on 2016/4/7.
 */
public class BranchStatment extends SpecialStatment {
    Scope field2;
    boolean useless = false;
    @Override
    public void getField(Scope now){
        field = now;
        field.setBranch();
    }
    public void getField2(Scope now) {
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


        BasicBlock block1 = getBlock();
        block1.add(new BranchInstruction("bne",rSrc,imm,block1.getLabel() + "_branch",false));
        field2.Translate();

        addBlock(block1,"branch");
        BasicBlock block2 = getBlock();
        field.Translate();

        addBlock();
        BasicBlock block3 = getBlock();

        block1.add(new JumpInstruction("b",block3.getLabel()));
        block2.add(new JumpInstruction("b",block3.getLabel()));
    }
}
