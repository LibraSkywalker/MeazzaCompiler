package AST.Expression;

/**
 * Created by Bill on 2016/4/6.
 */
public abstract class UnaryExpression extends ExpressionAction{
    String opertaor;
    ExpressionAction childAction;
    public void setOpertaor(String now){ opertaor = now;}
    public String getOpertaor(){return opertaor;}

    public void setChild(ExpressionAction now){
        childAction = now;
        now.parentAction = this;
    }
}
