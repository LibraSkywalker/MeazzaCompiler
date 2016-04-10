package AST;

import SymbolContainer.*;
import antlr.MeazzaParser;
import org.antlr.v4.runtime.ParserRuleContext;
import org.antlr.v4.runtime.tree.ParseTree;

/**
 * Created by Bill on 2016/4/8.
 */
public class ASTControler {
    private static Scope currentScope;

    public ASTControler(){
        currentScope = new Scope();
        new Builder();
    }

    public static void addAction(ActionNodeBase now){
        currentScope.addAction(now);
    }
    public static Scope getCurrentScope(){
        return currentScope;
    }

    public static void visitScope(Scope nowScope){
        currentScope = nowScope.visitScope();
    }
    public static void tagPos(ParserRuleContext ctx){
        System.err.print("Error exists in Line ") ;
        System.err.println(ctx.getStart().getLine());
    }

    public static boolean getReserved(String now) {
        return currentScope.getReserved(now);
    }
    public static TypeSymbol getType(String now){
        return currentScope.getType(now);
    }

    public static VariableSymbol getVar(String now){
        return currentScope.getVar(now);
    }

    public static FuncSymbol getFunc(String now){
        return currentScope.getFunc(now);
    }

    public static TypeSymbol putType(String now){
        return currentScope.putType(now);
    }

    public static TypeSymbol putType(String now,Object x){
        return currentScope.putType(now,x);
    }

    public static Reserved putReserved(String now){
        return (Reserved) currentScope.putReservedKey(now).setPrimitive();
    }

    public static FuncSymbol putFunc(String now){
        return currentScope.putFunc(now);
    }

    public static VariableSymbol putVar(String now){
        return currentScope.putVar(now);
    }

    public static Scope beginScope(){
        return currentScope.beginScope();
    }

    public static Scope endScope(){return currentScope.endScope();}

    public static ActionNodeBase popAction() {
        return currentScope.popAction();
    }
    public boolean Visit(MeazzaParser.ProgContext ctx){
        boolean flag = true;
        FirstVisitor visitor = new FirstVisitor();
        if (!visitor.visitProg(ctx)) flag = false;

        SecondVisitor visitor1 = new SecondVisitor();
        if (!visitor1.visitProg(ctx)) flag = false;
        // System.out.println("The program has no compile error");
        return flag;
    }
}