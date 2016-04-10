package AST.Expression;

import AST.ActionNodeBase;
import SymbolContainer.Properties;

import java.util.ArrayList;

/**
 * Created by Bill on 2016/4/6.
 */
public abstract class ExpressionAction extends ActionNodeBase {
    Properties properties;

    public abstract void set();
    public abstract boolean check();

    public void setProperties(String now){
        properties.setProperties(now);
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
