package AST.Statment;

import AST.ActionNodeBase;
import AST.Expression.BinaryExpression;
import AST.Expression.ExpressionAction;
import MIPS.Instruction.JumpInstruction;
import MIPS.Instruction.RegBinInstruction;
import SymbolContainer.Properties;
import SymbolContainer.Scope;

import static AST.ASTControler.getCurrentScope;
import static AST.ASTControler.getType;
import static AST.ASTControler.getVar;
import static MIPS.IRControler.addInstruction;
import static RegisterControler.ReservedRegister.returnRegister;

/**
 * Created by Bill on 2016/4/4.
 */
public class JumpStatment extends ActionNodeBase{
    ExpressionAction returnValue;
    String operator;

    public void setReturnValue(ExpressionAction now){
        returnValue = now;
        operator = "return";
    }

    public boolean isReturn(){
        return (returnValue != null);
    }

    public void set(String now){
        operator = now;
        if (now.equals("return")){
            getCurrentScope().findBranch().putReservedKey("+");
        }
    }
    public Scope excecute(){
        if (returnValue != null) return getCurrentScope().returnTo();
        if (operator.equals("break")) return getCurrentScope().breakTo();
        else return getCurrentScope().nextLoop();
    }

    public boolean accepted() {
        if (!operator.equals("return")) {
            if (excecute() == null) {
                System.err.println("Jump statment '" + operator + "' should be in Loop");
                return false;
            }
            return true;
        } else
        if (getVar("@return","") == null) {
            if (returnValue != null) {
                System.err.println("A void function Should not have return value");
                return false;
            }
            return true;
        } else {
            if (returnValue == null) {
                System.err.println("There should be a return value for this function");
                return false;
            }
            if (!getVar("@return").accept(returnValue)){
                System.err.println("Required " + getVar("@return").getProperties() + " instead of "+ returnValue);
                return false;
            }
            return true;
        }
    }

    public void Translate(){
        if (operator.equals("return")){
            if (returnValue != null){
                if (returnValue.isLiteral())
                    addInstruction(new RegBinInstruction("li" , returnRegister, returnValue.src(), false));
                else
                    addInstruction(new RegBinInstruction("move", returnRegister, returnValue.src(), true));
            }
            addInstruction(new JumpInstruction());
        }
    }

    public ExpressionAction returnValue(){
        return returnValue;
    }
}
