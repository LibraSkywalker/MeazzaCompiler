package AST.Expression;

/**
 * Created by Bill on 2016/4/6.
 */
public abstract class UnaryExpression extends ExpressionAction{
    String uop;
    ExpressionAction childAction;
    public void getOP(String now){ uop = now;}
    public String op(){return uop;}

    public void set(UnaryExpression now) {
        super.set(now);
    }
    public void getChild(ExpressionAction now){
        childAction = now;
    }
}
