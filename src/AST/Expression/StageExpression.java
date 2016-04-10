package AST.Expression;

import java.util.ArrayList;

/**
 * Created by Bill on 2016/4/10.
 */
public class StageExpression extends ExpressionAction{
    private ArrayList<ExpressionAction> stageValue = new ArrayList<>();
    private ExpressionAction previousAction;
    boolean lvalue;

    public void set(){}
    public boolean check(){return previousAction == null;}
    public void setPreviousAction(ExpressionAction now){
        previousAction = now;
        now.parentAction = this;
    }

    public boolean addStage(ExpressionAction now){
        if (now == null) return false;
        if (!properties.findDownStair()) {
            System.err.println("Too many stages are required");
            return false;
        }
        if (!now.properties.accept("int")){
            System.err.println("There should be an int Expression inside the stage ");
            return false;
        }
        stageValue.add(now);
        return true;
    }
}