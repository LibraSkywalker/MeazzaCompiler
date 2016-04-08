package AST.Expression;

import AST.ActionNodeBase;

/**
 * Created by Bill on 2016/4/6.
 */
public abstract class BinaryExpression extends ExpressionAction {
    protected ExpressionAction leftExpression,rightExpression;
    String operator;

    public void getOperator(String now){
        operator = now;
    }
    abstract boolean set();
    abstract String check();
    public void getLeft(ActionNodeBase nowAction){
        leftExpression = (ExpressionAction) nowAction;
    }

    public void getRight(ActionNodeBase nowAction){
        rightExpression = (ExpressionAction) nowAction;
    }

}
