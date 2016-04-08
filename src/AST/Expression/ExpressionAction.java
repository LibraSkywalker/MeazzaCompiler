package AST.Expression;

import AST.ActionNodeBase;
import SymbolTable.TypeSymbol;

import static main.main.globalScope;

/**
 * Created by Bill on 2016/4/6.
 */
public abstract class ExpressionAction extends ActionNodeBase {
    protected Object value;
    protected TypeSymbol type;
    protected int dimension;
    protected int stage;
    void getValue(Object value){}
    public TypeSymbol type(){
        return  type;
    }
    public int dimension(){return dimension;}
    public void setType(TypeSymbol now){
        type = now;
    }
    public void setStage(int now){
        stage = now;
    }
    public void setDimension(int now){
        dimension = now;
    }
    public void set(ExpressionAction now){
        type = now.type;
        dimension = now.dimension;
        stage = now.stage;
    }
    public int stage(){
        return stage;
    }
    public boolean isNot(String now){
        TypeSymbol nowType = globalScope.getType(now);
        return type != nowType;
    }
}
