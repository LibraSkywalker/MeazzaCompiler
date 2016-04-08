package SymbolTable;

import AST.Expression.ExpressionAction;

import static main.main.globalScope;

/**
 * Created by Bill on 2016/4/5.
 */
public class VariableSymbol extends Symbol{
    Object value;
    int dimension;
    int parameter;
    int stage;
    TypeSymbol type;

    protected VariableSymbol(){
        value = null;
        dimension = 0;
        stage = 0;
        parameter = -1;
        type = null;
    }

    public TypeSymbol type(){
        return type;
    }

    public void setType(TypeSymbol nowType){
        type = nowType;
    }

    public void getValue(Object now){
        value = now;
    }

    public int dimension(){
        return dimension;
    }

    public int parameter(){
        return parameter;
    }

    public void copy(VariableSymbol now){
        type = now.type;
        dimension = now.dimension;
        stage = now.stage;
        parameter = now.parameter;
        value = now.value;
    }

    public boolean check(VariableSymbol now){
        if (dimension - stage > 0 &&
            now.type == globalScope.getType(" "))
                return true;
        return now.type == type &&
               now.dimension - now.stage ==
               dimension - stage ;
    }

    public boolean check(ExpressionAction now){
        if (dimension - stage > 0 &&
                now.type() == globalScope.getType(" "))
            return true;
        return now.type() == type &&
                now.dimension() - now.stage() ==
                        dimension - stage ;
    }

    public boolean typeEndure(TypeSymbol nowType){
        return  (type == nowType || dimension > 0 && nowType == globalScope.getType(" "));
    }
    public void setDimension(int now){
        dimension = now;
    }

    public void setStage(int now){ stage = now;}
    public Object value(){
        return value;
    }
}
