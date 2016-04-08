package SymbolTable;

import AST.ActionNodeBase;

import java.util.*;

import static main.main.counter;

/**
 * Created by Bill on 2016/4/5.
 */
public class Scope extends Symbol{
    Scope prevScope;
    public Dictionary<String, Symbol> dict;
    public ArrayList<ActionNodeBase> actionList;
    public Scope(){
        prevScope = null;
        dict = new Hashtable<>();
        actionList = new ArrayList<>();
        name = (counter++).toString();
    }

    public Scope beginScope(){
        Scope now = new Scope();
        now.prevScope = this;
        return now;
    }

    public Scope endScope(){
        return prevScope;
    }

    public Symbol get(String now){
        for (Scope currentScope = this;
             currentScope != null;
             currentScope = currentScope.prevScope){
            if (currentScope.dict.get(now) != null)
                return currentScope.dict.get(now);
        }
        return null;
    }

    public TypeSymbol getType(String now){
        Symbol ret = get(now);
        if (ret != null && ret instanceof TypeSymbol) return (TypeSymbol) ret;
        return null;
    }

    public VariableSymbol getVar(String now){
        Symbol ret = get(now);
        if (ret != null && ret instanceof VariableSymbol) return (VariableSymbol)ret;
        return null;
    }

    public  FuncSymbol getFunc(String now){
        Symbol ret = get(now);
        if (ret != null && ret instanceof FuncSymbol) return (FuncSymbol)ret;
        return null;
    }

    public boolean contains(FuncSymbol now){
        return (dict.get(now.name) != null) && dict.get(now.name) instanceof FuncSymbol;
    }

    public boolean contains(VariableSymbol now){
        return (dict.get(now.name) != null) && dict.get(now.name) instanceof VariableSymbol;
    }

    public Symbol put(String now,Symbol nowSymbol){
        TypeSymbol replaced = getType(now);
        Symbol curSymbol = get(now);
        if (curSymbol == null ||
           !curSymbol.buildIn &&
           dict.get(now) == null){
                dict.put(now,nowSymbol);
                nowSymbol.name = now;

            return nowSymbol;
        }
        return null;
    }

    public VariableSymbol putVar(String now){
        VariableSymbol nowSymbol = new VariableSymbol();
        return (VariableSymbol) put(now,nowSymbol);
    }

    public FuncSymbol putFunc(String now){
        FuncSymbol nowSymbol =new FuncSymbol();
        return (FuncSymbol) put(now,nowSymbol);
    }

    public TypeSymbol putType(String now){
        TypeSymbol nowSymbol = new TypeSymbol();
        return (TypeSymbol) put(now,nowSymbol);
    }

    public void addAction(ActionNodeBase now){
        actionList.add(now);
    }
    public Scope breakTo(){
        return prevScope;
    }
}
