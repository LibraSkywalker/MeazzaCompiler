package AST.Statment;

import SymbolContainer.Scope;

import static AST.ASTControler.getCurrentScope;

/**
 * Created by Bill on 2016/4/7.
 */
public class BranchStatment extends SpecialStatment {
    Scope field2;
    @Override
    public void getField(Scope now){
        field = now;
        field.setBranch();
    }
    public void getField2(Scope now) {
        field2 = now;
        field2.setBranch();
    }
    public Scope field2(){
        return field2;
    }
    public void checkReturn(){
        if (!field.contains("+")) return;
        if (field2 != null && field2.contains("+")) ;
        getCurrentScope().findBranch().putReservedKey("+");
    }
}
