package AST.Expression;

import static main.main.globalScope;

/**
 * Created by Bill on 2016/4/6.
 */
public class LogicExpression extends BinaryExpression{
    public LogicExpression(){
        type = globalScope.getType("bool");
        dimension = 0;
    }

    public boolean set(){
        return true;
    }

    public String check(){
        if (leftExpression.type == type &&
            rightExpression.type == type &&
            (leftExpression.dimension - leftExpression.stage) == 0 &&
                (rightExpression.dimension - rightExpression.stage) == 0)
            return "";
        //System.out.println(type);
        //System.out.println(rightExpression.type);
        return "There should be boolean expression beside the Logic operator: " + leftExpression.type.name() + " "+ rightExpression.type.name();
    }
}
