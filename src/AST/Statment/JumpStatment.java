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
    String type;

    public void setReturnValue(ExpressionAction now){
        returnValue = now;
        type = "return";
    }

    public boolean isReturn(){
        return (returnValue != null);
    }

    public void set(String now){
        type = now;
        if (now.equals("return")){
            getCurrentScope().findBranch().putReservedKey("+");
        }
    }
    public Scope excecute(){
        if (returnValue != null) return getCurrentScope().returnTo();
        if (type.equals("break")) return getCurrentScope().breakTo();
        else return getCurrentScope().nextLoop();
    };
    public boolean accepted() {
        if (excecute() == null){
            System.err.println("Jump statment '"+ type + "' should be in Loop");
        }
        if (getVar("@return") == null) {
            if (returnValue != null) {
                System.err.println("A void function Should not have return value");
                return false;
            }
            return true;
        } else {
            if (returnValue == null) {
                System.err.println("There should be a return value for this function");
            }
            return (!getVar("@return").accept(returnValue.getProperties()));
        }
    }

    public ExpressionAction returnValue(){
        return returnValue;
    }
}
