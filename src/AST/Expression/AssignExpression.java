package AST.Expression;

import MIPS.Instruction.BinaryInstruction;
import SymbolContainer.VariableSymbol;

import static MIPS.IRcontroler.getBlock;


/**
 * Created by Bill on 2016/4/4.
 */
public class AssignExpression extends BinaryExpression{

    public void set(){
        properties.setProperties(leftAction.properties);
    }

    public void Translate(){
        ((SymbolElement) leftAction).update(); // renaming
        rightAction.Translate();

        rDest = leftAction.rDest;
        int rSrc =  rightAction.src();
        boolean isReg = !rightAction.isLiteral();
        if (!isReg) rSrc = ((Literal) rightAction).Reg();

        getBlock().add(new BinaryInstruction("move", rDest, rSrc, isReg));

    }

    public void setLeft(VariableSymbol now){
        SymbolElement nowAction = new SymbolElement();
        nowAction.setElement(now);
        leftAction = nowAction;
        nowAction.parentAction = this;
    }

    public boolean check(){
        if (leftAction == null || rightAction == null) return false;
        if (leftAction instanceof SymbolElement &&
            ((SymbolElement) leftAction).lvalue ||
            leftAction instanceof DotElement &&
            ((DotElement) leftAction).lvalue ||
            leftAction instanceof StageExpression &&
            ((StageExpression) leftAction).lvalue) {
                set();
                return  leftAction.accept(rightAction);
        }
        System.err.println("Assigned expression need lvalueExpression on the left of the operator");
        return false;
    }

    public String toString(){
        return "ASSIGN:" + leftAction.toString() + "\t"+ rightAction.toString();
    }
}
