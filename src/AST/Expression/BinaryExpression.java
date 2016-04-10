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
    public boolean setLeft(ExpressionAction nowAction){
        leftExpression = nowAction;
        if (nowAction == null) return false;
        nowAction.parentAction = this;
        return true;
    }

    public boolean setRight(ExpressionAction nowAction){
        rightExpression = nowAction;
        if (nowAction == null) return false;
        nowAction.parentAction = this;
        return true;
    }

}
