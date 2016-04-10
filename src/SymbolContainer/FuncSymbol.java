package SymbolContainer;

import java.util.ArrayList;

import static AST.ASTControler.beginScope;

/**
 * Created by Bill on 2016/4/5.
 */
public class FuncSymbol extends VariableSymbol {
    int parameter;
    public Scope FuncScope;
    private ArrayList<VariableSymbol> Parameters = new ArrayList<>();

    protected FuncSymbol(){
        primitive = false;
        FuncScope = beginScope();
        FuncScope.setFunc();
    }

    public FuncSymbol setPrimitive(){
        primitive = true;
        return this;
    }

    public int parameterSize(){
        return Parameters.size();
    }
    public VariableSymbol findParameter(int index){
        return Parameters.get(index);
    }

    public VariableSymbol addParameter(String now){
        VariableSymbol nowSymbol = FuncScope.putVar(now);
        if (nowSymbol == null) return null;
        Parameters.add(nowSymbol) ;
        parameter++;
        return nowSymbol;
    }

}
