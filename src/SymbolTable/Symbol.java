package SymbolTable;

import java.util.*;

/**
 * Created by Bill on 2016/4/2.
 */
public class Symbol {
    protected String name;
    protected boolean buildIn;

    protected Symbol(String newName){
        name = newName ;
    }
    public Symbol(){}

    public String name(){
        return name;
    }
    public void admin(){
        buildIn = true;
    }

    public boolean buildIn(){
        return buildIn;
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
