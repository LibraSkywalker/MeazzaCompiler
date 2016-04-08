package AST.Expression;

import static main.main.globalScope;

/**
 * Created by Bill on 2016/4/4.
 */
public class BitExpression extends BinaryExpression{
    public BitExpression(){
        dimension = 0;
        type = globalScope.getType("int");
    }

    @Override
    boolean set() {
        return true;
    }

    public String check(){
        if (leftExpression.type == type &&
                rightExpression.type == type &&
                leftExpression.dimension - leftExpression.stage == 0 &&
                rightExpression.dimension - rightExpression.stage == 0)
            return "";
        return "There should be integer expression beside the Bit operator";
    }
}
