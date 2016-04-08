package SymbolTable;

import java.lang.reflect.Parameter;
import java.util.ArrayList;

import static main.main.currentScope;

/**
 * Created by Bill on 2016/4/5.
 */
public class FuncSymbol extends VariableSymbol {
    private boolean buildInFunc = false;

    public Scope FuncScope;
    private ArrayList<VariableSymbol> Parameters = new ArrayList<>();

    protected FuncSymbol(){
        value = null;
        dimension = 0;
        parameter = 0;
        type = null;
        buildInFunc = false;
        FuncScope = currentScope.beginScope();
    }

    public VariableSymbol addParameter(String now){
        if (FuncScope.putVar(now) == null) return null;
        VariableSymbol nowSymbol = FuncScope.getVar(now);
        Parameters.add(nowSymbol) ;
        nowSymbol.parameter = parameter++;
        return nowSymbol;
    }

    public VariableSymbol findParameter(int index){
        return Parameters.get(index);
    }

    public Scope returnTo(Object now){
        value = now;
        return FuncScope.prevScope;
    }
}
