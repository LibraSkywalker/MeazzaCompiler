package AST.Statment;

import AST.Expression.ExpressionAction;

/**
 * Created by Bill on 2016/4/4.
 */
public class ForStatment extends StatmentAction{
    ExpressionAction initializer,looper;
    public void setInitializer(ExpressionAction now){
        initializer = now;
    }
    public ExpressionAction initializer(){
        return initializer;
    }

    public void setLooper(ExpressionAction now){
        looper = now;
    }

    public ExpressionAction looper(){
        return looper;
    }
}
