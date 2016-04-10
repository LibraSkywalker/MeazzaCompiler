package AST.Statment;

import SymbolContainer.Scope;

/**
 * Created by Bill on 2016/4/4.
 */
public class LoopStatment extends SpecialStatment {
    public void getField(Scope now){
        field = now;
        field.setLoop();
    }
}
