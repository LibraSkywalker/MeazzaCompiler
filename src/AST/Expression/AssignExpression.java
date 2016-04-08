package AST.Expression;

import SymbolTable.VariableSymbol;

import static main.main.globalScope;

/**
 * Created by Bill on 2016/4/4.
 */
public class AssignExpression extends BinaryExpression{

    @Override
    public boolean set(){
        type = leftExpression.type;
        dimension = leftExpression.dimension - leftExpression.stage;
        stage = 0;
        if ((dimension > 0 || !type().buildIn()) &&
                rightExpression.type == globalScope.getType(" "))
            return true;
        return  (type == rightExpression.type) &&
                (dimension == rightExpression.dimension - rightExpression.stage);
    }

    public void getLeft(VariableSymbol now){
        lvalue nowAction = new lvalue();
        nowAction.getElement(now);
        leftExpression = nowAction;
    }

    public void getValue(Object value){
        leftExpression.getValue(value);
    }

    public String check(){
        if (!(leftExpression instanceof lvalue)) return "Assigned expression need lvalue on the left of the operator";
        if (!set()) return "Type mismatch "+ leftExpression.type().name() + " " + rightExpression.type().name();
        else  return "";
    }
}
