package main;
import MIPS.IRControler;
import AST.* ;
import antlr.MeazzaLexer;
import antlr.MeazzaParser;
import org.antlr.v4.runtime.* ;

import java.io.*;

/**
 * Created by Bill on 2016/4/3.
 */
public class main {
    public static void main(String[] args) throws IOException{
        MeazzaLexer lexer = new MeazzaLexer(new ANTLRInputStream(System.in)) ;
        CommonTokenStream tokens = new CommonTokenStream(lexer) ;

        MeazzaParser parser = new MeazzaParser(tokens) ;
        MeazzaParser.ProgContext ctx = parser.prog();

        ASTControler visitor = new ASTControler();
        if (!visitor.Visit(ctx)) System.exit(1);

        IRControler transformer = new IRControler();
        transformer.visit();
        transformer.RegisterAllocate();

        System.out.println(transformer.toString());
    }
}
