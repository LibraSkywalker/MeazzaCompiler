package AST.Expression;

import MIPS.Instruction.AddBinInstruction;
import MIPS.Instruction.RegBinInstruction;
import SymbolContainer.VariableSymbol;

import static AST.ASTControler.getGlobeScope;
import static MIPS.IRControler.addInstruction;
import static MIPS.IRControler.getBlock;
import static RegisterControler.ReservedRegister.globalAddress;


/**
 * Created by Bill on 2016/4/4.
 */
public class AssignExpression extends BinaryExpression{

    public void set(){
        properties.setProperties(leftAction.properties);
    }

    public void Translate(){
        leftAction.Translate();
        if (leftAction instanceof SymbolElement)
            ((SymbolElement) leftAction).update();// renaming
        rightAction.Translate();
        System.err.println(leftAction);
        System.err.println(rightAction);
        rDest = leftAction.rDest;
        int Src =  rightAction.src();

        if (rightAction.isLiteral()){
            if (rightAction.accept("string")) {
                addInstruction(new AddBinInstruction("la", rDest, ((Literal) rightAction).memName()));
            }else{
                    Src = ((Literal) rightAction).Reg();
                    getBlock().add(new RegBinInstruction("li", rDest, Src, false));
                }
        }
        else
            getBlock().add(new RegBinInstruction("move", rDest, Src, false));

        if (!(leftAction instanceof SymbolElement) || ((SymbolElement) leftAction).element.getScope().equals(getGlobeScope())){
            getBlock().add(new AddBinInstruction("sw", rDest, globalAddress));
        }
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
