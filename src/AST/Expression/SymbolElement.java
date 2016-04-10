package AST.Expression;

import SymbolContainer.FuncSymbol;
import SymbolContainer.Symbol;
import SymbolContainer.VariableSymbol;

import java.util.ArrayList;

/**
 * Created by Bill on 2016/4/10.
 */
public class SymbolElement extends ExpressionAction{
    VariableSymbol element;
    boolean lvalue;
    public SymbolElement(){
        lvalue = false;
        element = null;
    }

    public SymbolElement(VariableSymbol nowElement){
        element = nowElement;
        properties = nowElement.getProperties().clone();
        lvalue = !(nowElement instanceof FuncSymbol);
    }

    public void setElement(VariableSymbol nowElement){
        element = nowElement;
        properties = nowElement.getProperties().clone();
        lvalue = !(nowElement instanceof FuncSymbol);
    }

    public void set(){}

    public boolean check(){return element != null;}

    public boolean checkParameter(ExpressionAction now,Integer i){
        if (element instanceof FuncSymbol){
            VariableSymbol nowParameter = ((FuncSymbol) element).findParameter(i);
            if (!nowParameter.accept(now)){
                System.err.println("Parameter "+ i.toString() + " type mismatch");
                return false;
            }
            return true;
        }
        else return false;
    }

    public boolean checkParameter(int maxIndex){
        if (maxIndex < ((FuncSymbol) element).parameterSize()){
            System.err.println("too few parameters exist");
            return false;
        }
        if (maxIndex > ((FuncSymbol) element).parameterSize()){
            System.err.println("too many parameters exist");
            return false;
        }
        return true;
    }
}
