package AST;

import antlr.MeazzaBaseVisitor;
import SymbolTable.*;
import org.antlr.v4.runtime.tree.ErrorNode;

import static main.main.globalScope;

/**
 * Created by Bill on 2016/4/3.
 */
public class Builder extends MeazzaBaseVisitor<String> {
    public Builder(){
        globalScope.putType("int").admin();
        globalScope.putType("double").admin();
        globalScope.putType("char").admin();
        globalScope.putType("string").admin();
        globalScope.putType("void").admin();
        globalScope.putType("bool").admin();
        globalScope.putType("class").admin();
        globalScope.putType(" ").admin();

        TypeSymbol string = globalScope.getType("string");
        TypeSymbol Int = globalScope.getType("int") ;

        globalScope.putFunc("print").admin();

        FuncSymbol print = globalScope.getFunc("print");
        print.setType(globalScope.getType("void"));
        print.addParameter("str").setType(string);

        globalScope.putFunc("println").admin();

        FuncSymbol println = globalScope.getFunc("println");
        println.setType(globalScope.getType("void"));
        println.addParameter("str").setType(string);

        globalScope.putFunc("getString").admin();
        globalScope.getFunc("getString").setType(string);

        globalScope.putFunc("size").admin();
        globalScope.getFunc("size").setType(Int);

        globalScope.putFunc("getInt").admin();
        globalScope.getFunc("getInt").setType(Int);

        globalScope.putFunc("toString").admin();

        FuncSymbol toString = globalScope.getFunc("toString");
        toString.setType(string);
        toString.addParameter("x").setType(Int);

        string.resolvedFunc("length");

        string.resolvedFunc("ord");

        string.resolvedFunc("substring");
        string.resolvedFunc("parseInt");

        string.classMembers.getFunc("length").setType(Int);
        FuncSymbol ord = string.classMembers.getFunc("ord");
        ord.setType(Int);
        ord.addParameter("x").setType(Int);

        string.classMembers.getFunc("parseInt").setType(Int);

        FuncSymbol subString = string.classMembers.getFunc("substring");

        subString.setType(string);
        subString.addParameter("x").setType(Int);
        subString.addParameter("y").setType(Int);


    }

    @Override
    public String visitErrorNode(ErrorNode node) {
        return "Gramma error exists!";
    }
}
