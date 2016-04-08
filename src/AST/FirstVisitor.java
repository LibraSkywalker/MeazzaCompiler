package AST;

import SymbolTable.*;
import antlr.MeazzaBaseVisitor;
import antlr.MeazzaParser;

import static main.main.currentScope;
import static main.main.globalScope;

/**
 * Created by Bill on 2016/4/5.
 */
public class FirstVisitor extends MeazzaBaseVisitor<String> {
    @Override
    public String visitClass_declaration(MeazzaParser.Class_declarationContext ctx) {
        TypeSymbol now = currentScope.putType(ctx.ID().getText());
        if (now == null) return "Unable to Define the class:" +
                            ctx.ID().getText() +
                            ",since we already have such class/type";
        return "";
    }

    @Override
    public String visitFunc_declaration(MeazzaParser.Func_declarationContext ctx) {

        TypeSymbol nowType = globalScope.getType(ctx.type().type_name().getText());
        if (nowType == null) return "Undefined type exist: " + ctx.type().type_name().getText();
        FuncSymbol nowSymbol =  globalScope.putFunc(ctx.ID().getText());
        if (nowSymbol == null) return "Function: " +ctx.ID().getText() + " creation failed in the globe";

        nowSymbol.setDimension(ctx.type().array().size());
        nowSymbol.setType(nowType);

        if (ctx.parameters() == null) return "";

        for (MeazzaParser.ParameterContext x: ctx.parameters().parameter()) {
            nowType = globalScope.getType(x.type().type_name().getText());
            if (nowType == null) return "Undefined type exist: " + x.type().type_name().getText();
            VariableSymbol now = nowSymbol.addParameter(x.ID().getText());
            if (now == null) return "Parameter redefined";
            now.setType(nowType);
            now.setDimension(x.type().array().size());
        }

        return "";
    }

    public String visitProg(MeazzaParser.ProgContext ctx) {
        String Error = "";
        for (MeazzaParser.Class_declarationContext x : ctx.class_declaration()) {
            Error = visitClass_declaration(x);
            if (!(Error.equals(""))) return Error;
        }
        for (MeazzaParser.Func_declarationContext x : ctx.func_declaration()) {
            Error = visitFunc_declaration(x);
            if (!(Error.equals(""))) return Error;
        }
        if (globalScope.getFunc("main") == null) return "";//"Warning: There's no main in the program";
        if (globalScope.getFunc("main").type() != globalScope.getType("int")) return "The type of main isn't valid";
        return Error;
    }
}
