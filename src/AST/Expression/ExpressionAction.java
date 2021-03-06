package AST.Expression;

import AST.ActionNodeBase;
import SymbolContainer.Properties;

/**
 * Created by Bill on 2016/4/6.
 */
public abstract class ExpressionAction extends ActionNodeBase {
    Properties properties = new Properties();
    int rDest = 0;
    
    public boolean isLiteral(){
        return this instanceof Literal;
    }
    
    public int src(){
        return this instanceof Literal ? ((Literal)this).value() : this.rDest;
    }
    
    
    public abstract void set();
    public abstract boolean check();

    public boolean setProperties(String now){
        return properties.setProperties(now);
    }

    public void setProperties(Properties now){
        properties.setProperties(now);
    }

    public boolean accept(ExpressionAction now){
        return properties.accept(now.properties);
    }
    public boolean accept(String now){
        return properties.accept(now);
    }

    public Properties getProperties(){
        return properties;
    }
}
