package AST.Expression;


/**
 * Created by Bill on 2016/4/4.
 */
public class EqualExpression extends BinaryExpression{
    public EqualExpression(){
    }

    @Override
    public void set(){
        setProperties("bool");
    }

    public boolean check(){
        if (!leftExpression.accept(rightExpression)) return false;
        if (operator.equals("!=")  || operator.equals("==")) {
            set();
            return true;
        }
        if (!leftExpression.accept("int")) {
            System.err.println("There should be integer expression beside the partial operator");
            return false;
        }
        set();
        return true;
    }
}
