package SymbolContainer;

import AST.Expression.ExpressionAction;


/**
 * Created by Bill on 2016/4/5.
 */
public class VariableSymbol extends Symbol{
    Properties properties = new Properties();

    protected VariableSymbol(){}

    public VariableSymbol setPrimitive(){
        primitive = true;
        return this;
    }

    public boolean setProperties(String type,int dim){
        if (!properties.setProperties(type ,dim)) return false;
        return true;
    }

    public boolean setProperties(String type){
        if (!properties.setProperties(type)) return false;
        return true;
    }

    public void setProperties(VariableSymbol now){
        properties.setProperties(now.properties);
    }

    public Properties getProperties(){
        return properties;
    }

    public boolean accept(Properties now){
        return properties.accept(now);
    }

    public boolean accept(TypeSymbol now){
        return properties.accept(now);
    }

    public boolean check(){
        if (properties.type.equals("void")){
            System.err.println("The type of a variable cannot be void");
            return false;
        }
        return true;
    }

    public boolean accept(String now){
        return properties.accept(now);
    }
    public boolean accept(VariableSymbol now){
        return properties.accept(now.properties);
    }
    public boolean accept(ExpressionAction now){
        return properties.accept(now.getProperties());
    }
}
