package AST.Expression;

import SymbolTable.VariableSymbol;

import java.util.ArrayList;

import static main.main.globalScope;

/**
 * Created by Bill on 2016/4/6.
 */
public abstract class SymbolElement extends UnaryExpression{
    VariableSymbol element;

    ArrayList<ExpressionAction> stageValue;
    ArrayList<ExpressionAction> dimensionValue;

    public SymbolElement(){
        dimension = stage = 0;
        stageValue = new ArrayList<>();
        dimensionValue = new ArrayList<>();
    }

    public void getElement(VariableSymbol now){
        element = now;
        if (now == null) return;
        dimension = now.dimension();
        type = now.type();
    }

    public void set(SymbolElement now){
        type = now.type;
        dimension = now.dimension;
        element = now.element;
    }

    public int stage(){return stage;}

    public boolean addStage(ExpressionAction now){
        stage++;
        if (now.type() != globalScope.getType("int")) return false;
        stageValue.add(now);
        return true;
    }



    public VariableSymbol element(){
        return element;
    }
}
