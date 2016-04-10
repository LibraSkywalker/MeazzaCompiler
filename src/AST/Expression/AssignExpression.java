package AST.Expression;

import SymbolContainer.VariableSymbol;


/**
 * Created by Bill on 2016/4/4.
 */
public class AssignExpression extends BinaryExpression{

    public void set(){
        properties.setProperties(leftExpression.properties);
    }

    public void setLeft(VariableSymbol now){
        SymbolElement nowAction = new SymbolElement();
        nowAction.setElement(now);
        leftExpression = nowAction;
        nowAction.parentAction = this;
    }

    public boolean check(){
        if (leftExpression == null || rightExpression == null) return false;
        if (leftExpression instanceof SymbolElement &&
            ((SymbolElement)leftExpression).lvalue ||
            leftExpression instanceof DotElement &&
            ((DotElement)leftExpression).lvalue ||
            leftExpression instanceof StageExpression &&
            ((StageExpression) leftExpression).lvalue) {
                set();
                return  leftExpression.accept(rightExpression);
        }
        System.err.println("Assigned expression need lvalueExpression on the left of the operator");
        return false;
    }
}
