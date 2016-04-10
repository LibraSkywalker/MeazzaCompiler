package AST.Expression;

/**
 * Created by Bill on 2016/4/7.
 */
public class AutoAdjustExpression extends UnaryExpression {
    public void set(){
        properties.setProperties("int");
    }
    public boolean check(){
        if (childAction == null) return false;
        if (childAction.accept("int")) return false;
        if (childAction instanceof SymbolElement &&
           ((SymbolElement)childAction).lvalue ||
           childAction instanceof DotElement &&
           ((DotElement)childAction).lvalue ||
           childAction instanceof StageExpression &&
           ((StageExpression) childAction).lvalue) {
                set();
                return true;
            }

        System.err.println("required lvalue on the operator");
        return false;
    }
}
