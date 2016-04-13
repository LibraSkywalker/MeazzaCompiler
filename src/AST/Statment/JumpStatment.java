package AST.Statment;

import AST.ActionNodeBase;
import AST.Expression.ExpressionAction;
import SymbolContainer.Properties;
import SymbolContainer.Scope;

import static AST.ASTControler.getCurrentScope;
import static AST.ASTControler.getType;
import static AST.ASTControler.getVar;

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

    public ExpressionAction returnValue(){
        return returnValue;
    }
}
