package SymbolContainer;

import static AST.ASTControler.beginScope;
import static AST.ASTControler.getType;

/**
 * Created by Bill on 2016/4/5.
 */
public class TypeSymbol extends Symbol{
    public Scope classMembers;

    protected TypeSymbol(boolean disableClassMembers){
        primitive = false;
        if (!disableClassMembers)
            classMembers = beginScope();
    }

    public TypeSymbol setPrimitive(){
        primitive = true;
        return this;
    }

    public Scope visitClassMember(){
        if (classMembers == null) return null;
        else return classMembers.visitScope();
    }

    public VariableSymbol resolvedMember(String member){
        VariableSymbol now = new VariableSymbol();
        return (VariableSymbol) classMembers.put(member, now);
    }


    public FuncSymbol resolvedFunc(String member){
        FuncSymbol now = new FuncSymbol();
        return (FuncSymbol) classMembers.put(member, now);
    }

    @Override
    public String toString() {
        return name;
    }

    public boolean equals(TypeSymbol now) {
        return  (now != null && name.equals (now.name));
    }

    public boolean equals(String now){
        return this == getType(now);
    }

}
