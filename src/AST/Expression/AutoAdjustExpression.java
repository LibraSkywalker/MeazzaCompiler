package AST.Expression;

import MIPS.Instruction.BinaryInstruction;
import MIPS.Instruction.FastInstruction;

import static MIPS.IRcontroler.getBlock;
import static RegisterControler.VirtualRegister.newVReg;

/**
 * Created by Bill on 2016/4/7.
 */
public class AutoAdjustExpression extends UnaryExpression {
    boolean isPre = false;
    public void set(){
        setProperties("int");
    }
    public void setPre(){
        isPre = true;
    }
    public boolean check(){
        if (childAction == null) return false;
        if (!childAction.accept("int")){
            System.err.println("Required int instead of " + childAction.properties);
            return false;
        }
        if (childAction instanceof SymbolElement &&
           ((SymbolElement)childAction).lvalue ||
           childAction instanceof DotElement &&
           ((DotElement)childAction).lvalue ||
           childAction instanceof StageExpression &&
           ((StageExpression) childAction).lvalue) {
                set();
                return true;
            }

        System.err.println("required lvalue on the operator");
        return false;
    }
    public void Translate(){
        childAction.Translate();

        rDest = newVReg();
        int rSrc = childAction.src();
        boolean isReg = !childAction.isLiteral();

        if (!isReg) rSrc = ((Literal)childAction).Reg();

        if (!isPre){
            getBlock().add(new BinaryInstruction("move", rDest , rSrc,true));
        }
        else rDest = rSrc;

        if (opertaor.equals("++")){
            getBlock().add(new FastInstruction("add",rDest ,rSrc ,1,false));
        } else {
            getBlock().add(new FastInstruction("sub",rDest ,rSrc ,1 ,false));
        }
    }
}
