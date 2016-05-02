package AST.Expression;

import MIPS.Instruction.RegBinInstruction;
import MIPS.Instruction.RegTerInstruction;

import static MIPS.IRControler.getBlock;
import static RegisterControler.VirtualRegister.newVReg;

/**
 * Created by Bill on 2016/4/7.
 */
public class AlterExpression extends UnaryExpression {
    public void set(){
        properties.setProperties(childAction.getProperties());
    }
    public boolean check(){
        if (childAction == null) return false;
        set();
        if (opertaor.equals("!")){
            if (!properties.accept("bool")) return false;
        } else {
            if (!properties.accept("int")) return false;
        }
        return true;
    }

    public void Translate(){
        //translate array,string
        childAction.Translate();

        rDest = newVReg();
        int rSrc = childAction.src();
        boolean isReg = !childAction.isLiteral();

        if (!isReg) rSrc = ((Literal)childAction).Reg();

        switch (opertaor){
            case"-": getBlock().add(new RegBinInstruction("neg", rDest, rSrc,true));
                     return;
            case"~": getBlock().add(new RegBinInstruction("not", rDest, rSrc,true));
                     return;
            case"!": getBlock().add(new RegTerInstruction("xor", rDest, rSrc, 1,false));
        }
    }
}
