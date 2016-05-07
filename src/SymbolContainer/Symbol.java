package SymbolContainer;

import MIPS.Instruction.AddBinInstruction;

import static AST.ASTControler.getVar;
import static MIPS.IRControler.addInstruction;
import static RegisterControler.RegisterName.a_0;
import static RegisterControler.VirtualRegister.newVReg;

/**
 * Created by Bill on 2016/4/2.
 */
public abstract class Symbol {
    protected String name;
    protected boolean primitive;
    int virtualRegister = 0;
    Scope scope;

    public Scope getScope(){
        return scope;
    }

    public abstract Symbol setPrimitive();

    public int update(){
        return virtualRegister = newVReg();
    }

    public int getVirtualRegister(){
        if (virtualRegister == 0) {
            if (this == getVar("_arg_before_it")) {
                virtualRegister = a_0;
                return virtualRegister;
            }
            if (scope.dict2.indexOf(this) < scope.dict2.indexOf(getVar("_arg_before_it"))) {
                if (scope.dict2.indexOf(getVar("_arg_before_it")) > 5) {
                    update();
                    int delta = scope.dict2.indexOf(this) * 4;
                    int rSrc = getVar("_arg_before_it").getVirtualRegister();
                    addInstruction(new AddBinInstruction("lw", virtualRegister, rSrc, delta));
                    return virtualRegister;
                }
                else {
                    virtualRegister = a_0 + scope.dict2.indexOf(this);
                    return virtualRegister;
                }
            } else update();
        }
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
