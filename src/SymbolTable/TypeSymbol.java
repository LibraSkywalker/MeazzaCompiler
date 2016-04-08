package SymbolTable;

import static main.main.currentScope;

/**
 * Created by Bill on 2016/4/5.
 */
public class TypeSymbol extends Symbol{
    public Scope classMembers;
    protected TypeSymbol(){
        classMembers = currentScope.beginScope();
        buildIn = false;
    }

    public VariableSymbol resolvedMember(String member){
        VariableSymbol now = new VariableSymbol();
        return (VariableSymbol) classMembers.put(member, now);
    }

    @Override
    public boolean equals(Object now) {
        return name.equals (((TypeSymbol) now).name);
    }

    public FuncSymbol resolvedFunc(String member){
        FuncSymbol now = new FuncSymbol();
        return (FuncSymbol) classMembers.put(member, now);
    }
}
