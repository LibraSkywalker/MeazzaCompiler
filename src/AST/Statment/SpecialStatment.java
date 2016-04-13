package AST.Statment;

import AST.ActionNodeBase;
import AST.Expression.ExpressionAction;
import SymbolContainer.Scope;

/**
 * Created by Bill on 2016/4/4.
 */
public abstract class SpecialStatment extends ActionNodeBase {
    Scope field;
    ExpressionAction control;

    public SpecialStatment(){
        control = null;
        field = null;
    }


    public abstract void getField(Scope now);
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
