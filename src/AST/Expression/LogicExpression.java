package AST.Expression;

/**
 * Created by Bill on 2016/4/6.
 */
public class LogicExpression extends BinaryExpression{
    public LogicExpression(){}

    @Override
    public void set(){
        properties.setProperties("bool");
    }

    public boolean check(){
        if (!leftExpression.accept("bool") || !rightExpression.accept("bool")){
            System.err.println("There should be boolean expression beside the Logic operator: ");
            return false;
        }
        set();
        return true;
    }
}
