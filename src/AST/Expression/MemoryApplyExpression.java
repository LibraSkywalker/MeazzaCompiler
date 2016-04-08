package AST.Expression;

import java.util.ArrayList;

import static main.main.globalScope;

/**
 * Created by Bill on 2016/4/4.
 */
public class MemoryApplyExpression extends ExpressionAction{
    int assigned = 0;
    ArrayList<ExpressionAction> assignStage = new ArrayList<>();

    public boolean addStage(ExpressionAction now){
        if (now.type() != globalScope.getType("int")) return false;
        assignStage.add(now);
        assigned++;
        return true;
    }
}
