package main;
import antlr.*;
import AST.* ;
import org.antlr.v4.runtime.* ;

import java.io.*;

/**
 * Created by Bill on 2016/4/3.
 */
public class main {
    public static void main(String[] args) throws IOException{
        // test = System.in.toString();
        //System.out.print(test);
        //if (test.length() > 235) System.exit(0);
        MeazzaLexer lexer = new MeazzaLexer(new ANTLRInputStream(System.in)) ;
        CommonTokenStream tokens = new CommonTokenStream(lexer) ;

        MeazzaParser parser = new MeazzaParser(tokens) ;
        MeazzaParser.ProgContext ctx = parser.prog();

        ASTControler visitor = new ASTControler();
        if (!visitor.Visit(ctx)) System.exit(1);

    }
}