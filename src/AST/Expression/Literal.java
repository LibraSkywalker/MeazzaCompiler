package AST.Expression;

/**
 * Created by Bill on 2016/4/6.
 */
public class Literal extends ExpressionAction{
    Object value;
    String _value;
    public void set(){}
    public boolean check(){return true;}
    public void getValue(String now){
        _value = now;
    }
}
