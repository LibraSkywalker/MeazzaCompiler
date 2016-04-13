package SymbolContainer;

import static AST.ASTControler.getCurrentScope;

/**
 * Created by Bill on 2016/4/2.
 */
public abstract class Symbol {
    protected String name;
    protected boolean primitive;

    public abstract Symbol setPrimitive();

    public boolean isPrimitive(){
        return primitive;
    }
    protected Symbol(){}

    public String name(){
        return name;
    }

    @Override
    public String toString(){
        return name;
    }

    @Override
    public boolean equals(Object now){
        return this == now ;
    }
}
