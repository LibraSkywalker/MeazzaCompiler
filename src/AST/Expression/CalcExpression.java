package AST.Expression;

/**
 * Created by Bill on 2016/4/6.
 */
public class CalcExpression extends BinaryExpression {

    @Override
    public boolean set(){
        type = leftExpression.type;
        dimension = leftExpression.dimension - leftExpression.stage;
        return  (type == rightExpression.type) &&
                (dimension == rightExpression.dimension - rightExpression.stage);
    }

    public String check(){
        if (!set()) return "Type mismatch " + leftExpression.type().name() + " " + rightExpression.type().name();
        if (!type.buildIn()) return "calc operation should be done on build in types";
        if (dimension > 0) return "cannot do calc operation on array now";
        else  return "";
    }
}
