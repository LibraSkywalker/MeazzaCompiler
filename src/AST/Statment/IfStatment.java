package AST.Statment;

import SymbolTable.Scope;

/**
 * Created by Bill on 2016/4/7.
 */
public class IfStatment extends StatmentAction {
    Scope field2;
    public void getField2(Scope now){
        field = now;
    }
    public Scope field2(){
        return field;
    }
}
