package AST.Expression;

/**
 * Created by Bill on 2016/4/6.
 */
public abstract class BinaryExpression extends ExpressionAction {
    protected ExpressionAction leftAction, rightAction;
    String operator;

    public void getOperator(String now){
        operator = now;
    }
    public boolean setLeft(ExpressionAction nowAction){
        leftAction = nowAction;
        if (nowAction == null) return false;
        nowAction.parentAction = this;
        return true;
    }

    public boolean setRight(ExpressionAction nowAction){
        rightAction = nowAction;
        if (nowAction == null) return false;
        nowAction.parentAction = this;
        return true;
    }

    public String toString(){
        return properties.toString()
                + "\t" + leftAction.toString()
                + " "+ rightAction.toString();
    }
}
