package AST.Expression;

import SymbolContainer.VariableSymbol;

import java.util.ArrayList;

import static AST.ASTControler.endScope;
import static AST.ASTControler.getFunc;
import static AST.ASTControler.visitScope;

/**
 * Created by Bill on 2016/4/6.
 */
public class DotElement extends BinaryExpression{
    boolean lvalue;
    public DotElement(){
        lvalue = false;
    }

    public void set() {
        lvalue = ((SymbolElement) rightExpression).lvalue;
        properties = rightExpression.properties;
    }

    public boolean setEnvironment(){
        if (leftExpression == null) return false;
        if (leftExpression.properties.getDimension() == 0)
            visitScope(leftExpression.getProperties().type().classMembers);
        return true;
    }

    public void clearEnvironment(){
        endScope();
    }

    @Override
    public boolean setLeft(ExpressionAction nowAction){
        leftExpression = nowAction;
        if (nowAction == null) return false;
        nowAction.parentAction = this;
        setEnvironment();
        return true;
    }

    public boolean check(){
        if (leftExpression == null ||
            rightExpression == null ||   // dot expression
           !(rightExpression instanceof SymbolElement))
            return false;
        if (leftExpression.properties.getDimension() > 0){
            if (!((SymbolElement) rightExpression).element.equals(getFunc("size")))
                System.err.println("Cannot access the suffix of a pointer");
            return false;
        }
        else {
            clearEnvironment();
            if (((SymbolElement) rightExpression).element.equals(getFunc("size")))
                System.err.println("size cannot be done on non array expression");
        }
        set();
        return true;
    }
}
