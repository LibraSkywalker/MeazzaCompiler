package SymbolContainer;

import static AST.ASTControler.getCurrentScope;
import static RegisterControler.VirtualRegister.newVReg;

/**
 * Created by Bill on 2016/4/2.
 */
public abstract class Symbol {
    protected String name;
    protected boolean primitive;
    int virtualRegister;

    public abstract Symbol setPrimitive();

    public void update(){
        virtualRegister = newVReg();
    }

    public int getVirtualRegister(){
        return virtualRegister;
    }

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
