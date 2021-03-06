package AST.Expression;

import MIPS.Instruction.AddBinInstruction;
import MIPS.Instruction.RegBinInstruction;
import SymbolContainer.VariableSymbol;

import static AST.ASTControler.getGlobeScope;
import static MIPS.IRControler.addInstruction;
import static MIPS.IRControler.getBlock;
import static RegisterControler.RegisterName.globalAddress;
import static RegisterControler.RegisterName.globalVariable;


/**
 * Created by Bill on 2016/4/4.
 */
public class AssignExpression extends BinaryExpression{

    public void set(){
        properties.setProperties(leftAction.properties);
    }

    public void Translate(){
        rightAction.Translate();
        leftAction.Translate();
        if (leftAction instanceof SymbolElement)
            ((SymbolElement) leftAction).update();// renaming

        rDest = leftAction.rDest;
        int Src =  rightAction.src();

        if (rightAction.isLiteral()){
            if (rightAction.accept("string")) {
                addInstruction(new AddBinInstruction("la", rDest, ((Literal) rightAction).memName()));
            }else{
                    getBlock().add(new RegBinInstruction("li", rDest, Src, false));
                }
        }
        else
            getBlock().add(new RegBinInstruction("move", rDest, Src, true));

        if ((leftAction instanceof SymbolElement) && ((SymbolElement) leftAction).element.getScope().equals(getGlobeScope()) && getGlobeScope().dict3.size() > 7){
            addInstruction(new AddBinInstruction("sw",rDest ,globalVariable, 4 * getGlobeScope().indexOfMember(((SymbolElement) leftAction).element)));
        } //global

        if (leftAction instanceof StageExpression)
            addInstruction(new AddBinInstruction("sw", rDest, globalAddress));
          //array

        if (leftAction instanceof DotElement)
            addInstruction(new AddBinInstruction("sw", rDest, globalAddress));
            //class

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
