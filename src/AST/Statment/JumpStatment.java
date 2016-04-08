package AST.Statment;

import AST.ActionNodeBase;
import AST.Expression.ExpressionAction;

/**
 * Created by Bill on 2016/4/4.
 */
public class JumpStatment extends ActionNodeBase{
    ExpressionAction returnValue;
    String type;
    public void setReturnValue(ExpressionAction now){
        returnValue = now;
        type = "return";
    }

    public void setType(String now){
        type = now;
    }

    public boolean Inloop(){
        ActionNodeBase now = parentAction;
        while (now != null && !(now instanceof ForStatment) && !(now instanceof  WhileStatment))
            now = now.parentAction;
        return now != null;
    }
    public ExpressionAction returnValue(){
        return returnValue;
    }
}
