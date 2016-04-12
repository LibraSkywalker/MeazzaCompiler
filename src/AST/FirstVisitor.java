package AST;

import SymbolContainer.*;
import antlr.MeazzaBaseVisitor;
import antlr.MeazzaParser;

import static AST.ASTControler.*;


/**
 * Created by Bill on 2016/4/5.
 */
public class FirstVisitor extends MeazzaBaseVisitor<Boolean> {
    @Override
    public Boolean visitClass_declaration(MeazzaParser.Class_declarationContext ctx) {
        TypeSymbol now = putType(ctx.ID().getText());
        if (now == null) {
            tagPos(ctx);
            return false;
        }
        return true;
    }

    @Override
    public Boolean visitFunc_declaration(MeazzaParser.Func_declarationContext ctx) {
        FuncSymbol nowSymbol = putFunc(ctx.ID().getText());
        if (nowSymbol == null) return tagPos(ctx);
        String nowType = ctx.type().type_name().getText();

        if (!nowSymbol.setProperties(nowType,ctx.type().array().size())) return tagPos(ctx);

        if (ctx.parameters() == null) return true;
        Boolean flag = true;
        for (MeazzaParser.ParameterContext x: ctx.parameters().parameter()) {
            VariableSymbol nowParameter = nowSymbol.addParameter(x.ID().getText());
            if (nowParameter == null){
                tagPos(ctx);
                flag = false;
            }
            else {
                nowType = x.type().type_name().getText();
                if (!nowParameter.setProperties(nowType, x.type().array().size())) {
                    tagPos(ctx);
                    flag = false;
                }
            }
        }

        return tagPos(ctx,flag);
    }

    public Boolean visitProg(MeazzaParser.ProgContext ctx) {
        boolean flag = true;
        for (MeazzaParser.Class_declarationContext x : ctx.class_declaration())
            if (!visitClass_declaration(x)) flag = false;

        for (MeazzaParser.Func_declarationContext x : ctx.func_declaration())
            if (!visitFunc_declaration(x)) flag =false;

        return tagPos(ctx,flag);
    }
}
