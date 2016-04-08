package AST.Expression;

import static main.main.globalScope;

/**
 * Created by Bill on 2016/4/4.
 */
public class EqualExpression extends BinaryExpression{
    public EqualExpression(){
        type = globalScope.getType("bool");
        dimension = 0;
    }

    public boolean set(){
        dimension = leftExpression.dimension - leftExpression.stage;
        if (dimension != rightExpression.dimension - rightExpression.stage) return false;
        return true;
    }

    public String check(){
        if (!set()) return "Dimension mismatch";
        if ((!leftExpression.type.buildIn() || dimension > 0) && !rightExpression.isNot(" ")) return "";
        if (leftExpression.type != rightExpression.type)
            return "Type mismatch " + leftExpression.type().name() + " " + rightExpression.type().name();
        if (operator.equals("!=")  || operator.equals("==")) return "";
        if (leftExpression.type == globalScope.getType("int") && dimension == 0)
            return "";
        return "There should be integer expression beside the partial operator";
    }
}
