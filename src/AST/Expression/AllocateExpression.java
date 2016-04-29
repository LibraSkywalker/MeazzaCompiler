package AST.Expression;

import java.util.ArrayList;


/**
 * Created by Bill on 2016/4/4.
 */
public class AllocateExpression extends ExpressionAction{
    int assigned = 0;
    ArrayList<ExpressionAction> stageValue = new ArrayList<>();

    public void set(){}
    public boolean check(){return true;}

    public boolean setProperties(String now,int dim){
       return properties.setProperties(now,dim);
    }

    public boolean addStage(ExpressionAction now){
        if (now == null) return false;
        if (!now.properties.accept("int")) return false;
        stageValue.add(now);
        return true;
    }

    public String toString(){
        return "NEW:" + properties;
    }
}
