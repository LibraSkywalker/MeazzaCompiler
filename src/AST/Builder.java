package AST;

import SymbolContainer.*;

import static AST.ASTControler.putFunc;
import static AST.ASTControler.putReserved;
import static AST.ASTControler.putType;


/**
 * Created by Bill on 2016/4/3.
 */
public class Builder {
    public Builder(){
        putReserved("class");
        putReserved("new");
        putReserved("break");
        putReserved("continue");
        putReserved("return");
        putReserved("if");
        putReserved("for");
        putReserved("while");
        putReserved("true");
        putReserved("false");
        putReserved("null");
        putType("int","noMember").setPrimitive();
        putType("double","noMember").setPrimitive();
        putType("char","noMember").setPrimitive();
        putType("void","noMember").setPrimitive();
        putType("bool","noMember").setPrimitive();
        putType("@null","noMember").setPrimitive();

        TypeSymbol string = putType("string").setPrimitive();


        FuncSymbol print = putFunc("print").setPrimitive();

        print.setProperties("void");
        print.addParameter("str").setProperties("string");

        FuncSymbol println = putFunc("println").setPrimitive();
        println.setProperties("void");
        println.addParameter("str").setProperties("string");

        putFunc("getString").setPrimitive().setProperties("string");

        putFunc("size").setPrimitive().setProperties("string");

        putFunc("getInt").setPrimitive().setProperties("int");

        FuncSymbol toString = putFunc("toString").setPrimitive();
        toString.setProperties("string");;
        toString.addParameter("x").setProperties("int");

        string.resolvedFunc("length").setProperties("int");

        FuncSymbol ord = string.resolvedFunc("ord");
        ord.setProperties("int");
        ord.addParameter("x").setProperties("int");

        FuncSymbol subString = string.resolvedFunc("substring");

        string.resolvedFunc("parseInt").setProperties("int");

        subString.setProperties("string");
        subString.addParameter("x").setProperties("int");
        subString.addParameter("y").setProperties("int");

    }
}
