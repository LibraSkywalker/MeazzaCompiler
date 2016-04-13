package AST.Expression;

/**
 * Created by Bill on 2016/4/7.
 */
public class AlterExpression extends UnaryExpression {
    public void set(){
        properties.setProperties(childAction.getProperties());
    }
    public boolean check(){
        if (childAction == null) return false;
        set();
        if (opertaor.equals("!")){
            if (!properties.accept("bool")) return false;
        } else {
            if (!properties.accept("int")) return false;
        }
        return true;
    }
}
