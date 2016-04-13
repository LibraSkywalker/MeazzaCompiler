package SymbolContainer;

import static AST.ASTControler.beginScope;
import static AST.ASTControler.endScope;
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

    public VariableSymbol resolvedMember(String member){
        return classMembers.putVar(member);
    }


    public FuncSymbol resolvedFunc(String member){
        return classMembers.putFunc(member);
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
