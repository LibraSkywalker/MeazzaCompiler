package AST.Expression;

/**
 * Created by Bill on 2016/4/6.
 */
public class CalcExpression extends BinaryExpression {

    @Override
    public void set(){
        setProperties(leftExpression.properties);
    }

    @Override
    public boolean check(){
        if (!leftExpression.accept(rightExpression)){
            return false;
        }
        set();
        if (!properties.type().isPrimitive()) {
            System.err.println("calc operation should be done on build in types");
            return false;
        }
        if (properties.getDimension() > 0){
            System.err.println("cannot do calc operation on array now");
            return false;
        }
        else  return true;
    }
}
