package AST.Statment;

import AST.ActionNodeBase;
import AST.Expression.ExpressionAction;
import SymbolTable.Scope;

/**
 * Created by Bill on 2016/4/4.
 */
public abstract class StatmentAction extends ActionNodeBase {
    Scope field;
    ExpressionAction control;
    public void getField(Scope now){
        field = now;
    }
    public Scope field(){
        return field;
    }

    public void setControl(ExpressionAction now){
        control = now;
    }

    public ExpressionAction control(){
        return control;
    }
}
