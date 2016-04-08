package main;
import SymbolTable.Scope;
import antlr.*;
import AST.* ;
import org.antlr.v4.runtime.* ;
import org.omg.CORBA.portable.InputStream;

import java.io.*;

/**
 * Created by Bill on 2016/4/3.
 */
public class main {
    public static Scope currentScope;
    public static Scope globalScope;
    public static ActionNodeBase currentAction;
    public static Integer counter = 0;

    public static void main(String[] args) throws IOException{
        // test = System.in.toString();
        //System.out.print(test);
        //if (test.length() > 235) System.exit(0);
        MeazzaLexer lexer = new MeazzaLexer(new ANTLRInputStream(System.in)) ;
        CommonTokenStream tokens = new CommonTokenStream(lexer) ;

        MeazzaParser parser = new MeazzaParser(tokens) ;
        MeazzaParser.ProgContext ctx = parser.prog();

        currentScope = globalScope = new Scope();
        new Builder();
        //System.out.println("First Round Started.");
        String Error;

        FirstVisitor visitor = new FirstVisitor();
        Error = visitor.visitProg(ctx);
        if (Error != "") {
            System.out.println(Error);
            if (!Error.equals("")) System.exit(1);
        }
        else {
            //System.out.println("Second Round Started.");
            SecondVisitor visitor1 = new SecondVisitor();
            Error = visitor1.visitProg(ctx);
            if (Error != "") {
                System.out.println(Error);
                if (!Error.equals("")) System.exit(1);
            }
            else {
               // System.out.println("The program has no compile error");
            }
        }
    }
}
