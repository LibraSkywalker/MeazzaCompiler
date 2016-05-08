package SymbolContainer;

import static AST.ASTControler.getType;

/**
 * Created by Bill on 2016/4/8.
 */
public class Properties {
    int dimension;
    TypeSymbol type;

    public Properties(){
        dimension = 0;
        type = null;
    }
    public void setProperties(Properties now){
        type = now.type;
        dimension = now.dimension;
    }

    public boolean setProperties(Properties now,int stage){
        type = now.type;
        dimension = now.dimension - stage;
        return dimension >= 0 ;
    }

    public String toString(){
        return type() + " " + dimension + ":";
    }
    public int getDimension(){
        return dimension;
    }
    public TypeSymbol type(){
        return type;
    }

    public boolean findDownStair(){
        dimension-- ;
        return dimension >= 0 ;
    }

    public boolean setProperties(String nowType, int dim){
        type = getType(nowType);
        if (type == null) {
            System.err.println("Undefined Type: " + nowType + " exists");
            return false;
        }
        dimension = dim;
        return true;
    }

    public boolean setProperties(String nowType){
        type = getType(nowType);
        if (type == null){
            System.err.println("Undefined Type: " + nowType + " exists");
            return false;
        }
        dimension = 0;
        return true;
    }

    public Properties clone() {
        Properties now = new Properties();
        now.type = type;
        now.dimension = dimension;
        return now;
    }

    public boolean accept(Properties now){
        if (type.equals(now.type) && dimension == now.dimension )
            return true;
        if ((dimension != 0 || !type.primitive) && (now.type.equals("@null")))
            return true;
        String dimA = "";
        String dimB = "";
        for (int i = 0;i < dimension; i++) dimA += "[]";
        for (int i = 0;i < now.dimension; i++) dimB +="[]";
        System.err.println("Type mismatch: required" + type.toString() + dimA + " instead of " + now.type.toString() + dimB);
        return false;
    }

    public boolean accept(String now){
        return type.equals(getType(now)) && dimension == 0;
    }

    public boolean accept(TypeSymbol now){
        return type.equals(now) && dimension == 0;
    }
}
