package AST.Expression;
/**
 * Created by Bill on 2016/4/4.
 */
public class BitExpression extends BinaryExpression{
    public BitExpression(){}

    public void set() {
        setProperties("int");
    }

    public boolean check(){
        if (!leftExpression.accept("int") || !rightExpression.accept("int")){
            System.err.println("There should be integer expression beside the Bit operator");
            return false;
        }
        set();
        return true;
    }
}