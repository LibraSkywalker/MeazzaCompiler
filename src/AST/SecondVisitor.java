package AST;

import AST.Expression.*;
import AST.Statment.BranchStatment;
import AST.Statment.JumpStatment;
import AST.Statment.LoopStatment;
import SymbolContainer.*;
import antlr.MeazzaBaseVisitor;
import antlr.MeazzaParser;
import java.lang.String;

import static AST.ASTControler.*;

/**
 * Created by Bill on 2016/4/5.
 */
public class SecondVisitor extends MeazzaBaseVisitor<Object>{
    @Override
    public Boolean visitClass_declaration(MeazzaParser.Class_declarationContext ctx) {
        boolean flag = true;
        TypeSymbol nowClass = getType(ctx.ID().getText());
        for(MeazzaParser.Raw_declarationContext x : ctx.raw_declaration()){
            String nowType = x.type().type_name().getText();
            VariableSymbol nowSymbol = nowClass.resolvedMember(x.ID().getText());
            if (nowSymbol == null) {
                flag = false;
                System.err.println("Variable" + x.ID().getText() + " definition failed in " + ctx.ID().getText());
                tagPos(ctx);
            }
            else if (nowSymbol.setProperties(nowType,x.type().array().size())){
                flag = false;
                System.err.println("Undefined type: "+ nowType + "exists");
                tagPos(ctx);
            }
            else if (nowSymbol.check()){
                flag = false;
                System.err.println("The type of a variable cannot be void");
                tagPos(ctx);
            }
        }
        return flag;
    }

    @Override
    public Boolean visitProg(MeazzaParser.ProgContext ctx) {
        boolean flag = true;
        for (MeazzaParser.Class_declarationContext x : ctx.class_declaration()) {
            if(!visitClass_declaration(x)){
                flag = false;
            };
        }
        for (int i = 0; i < ctx.getChildCount(); i++) {
            if (ctx.getChild(i) instanceof MeazzaParser.Class_declarationContext) continue;
            if (!(Boolean) visit(ctx.getChild(i))) flag = false;
        }

        if (getFunc("main") == null) {
            System.err.println("Warning: There's no main function in the program");
            return flag;
        }

        if (!getFunc("main").accept("int")){
            System.err.println("The type of main isn't valid");
            return false;
        }

        addAction(new SymbolElement(getFunc("main"))) ;
        return flag;
    }

    @Override
    public Boolean visitVar_declaration(MeazzaParser.Var_declarationContext ctx) {
        VariableSymbol nowVariable = putVar(ctx.ID().getText());
        String nowType = ctx.type().type_name().getText();
        boolean flag = true;
        if (nowVariable == null){
            flag = false;
            System.err.println("Variable" + ctx.ID().getText() + " definition failed");
            tagPos(ctx);
        }
        else if (!nowVariable.setProperties(nowType,ctx.type().array().size())){
            flag = false;
            System.err.println("Undefined Type: " + nowType + " exists");
            tagPos(ctx);
        }
        else if (!nowVariable.check()){
            flag = false;
            tagPos(ctx);
        }

        if (ctx.expression() == null) return flag;

        AssignExpression nowAction = new AssignExpression();
        nowAction.setLeft(nowVariable);
        nowAction.setRight(visitExpression(ctx.expression()));

        if (!nowAction.check()){
            tagPos(ctx);
            return false;
        }

        addAction(nowAction);

        return flag;
    }

    private ExpressionAction BinaryDefault(MeazzaParser.ExpressionContext ctx,BinaryExpression nowAction){
        if (!nowAction.setLeft(visitExpression(ctx.expression(0)))) return null;
        if (!nowAction.setRight(visitExpression(ctx.expression(1)))) return null;
        return nowAction;
    }

    @Override
    public ExpressionAction visitExpression(MeazzaParser.ExpressionContext ctx) {
        if (ctx.op != null){
            String now = ctx.op.getText();
            if (now.equals("=")) {
                AssignExpression nowAction = new AssignExpression();
                if (BinaryDefault(ctx,nowAction) == null) return null;
                return nowAction.check() ? nowAction : null;
            }
            if (now.equals("||") || now.equals("&&")){
                LogicExpression nowAction = new LogicExpression();
                nowAction.getOperator(now);
                if (BinaryDefault(ctx,nowAction) == null) return null;
                return nowAction.check() ? nowAction : null;
            }
            if (now.equals("|") || now.equals("&") || now.equals("^") || now.equals("<<") || now.equals(">>")){
                BitExpression nowAction = new BitExpression();
                nowAction.getOperator(now);
                if (BinaryDefault(ctx,nowAction) == null) return null;
                return nowAction.check() ? nowAction : null;
            }
            if (now.equals("==")|| now.equals("!=") || now.equals(">") ||
                now.equals(">=")|| now.equals("<=") || now.equals("<") ){
                EqualExpression nowAction = new EqualExpression();
                nowAction.getOperator(now);
                if (BinaryDefault(ctx,nowAction) == null) return null;
                return nowAction.check() ? nowAction : null;
            }
            if (now.equals("[")){
                StageExpression nowAction = new StageExpression();
                nowAction.setPreviousAction(visitExpression(ctx.expression(0)));
                if (!nowAction.check()) return null;
                for (int i = 1; i < ctx.expression().size(); i++) {
                    if (!nowAction.addStage(visitExpression(ctx.expression(i)))) return null;
                }
                return nowAction;
            }
            if (now.equals(".")) {
                DotElement nowAction = new DotElement();
                if (BinaryDefault(ctx,nowAction) == null) return null;
                if (!nowAction.check()) return null;
                return nowAction.check() ? nowAction : null;
            }
            if (now.equals("+") || now.equals("-") || now.equals("*") || now.equals("/") || now.equals("%"))
            {
                CalcExpression nowAction = new CalcExpression();
                nowAction.getOperator(now);
                if (BinaryDefault(ctx,nowAction) == null) return null;
                return nowAction.check() ? nowAction : null;
            }
        }
        else if (ctx.uop != null){
            String now = ctx.uop.getText();
            if (now.equals("new")){
                MemoryApplyExpression nowAction = new MemoryApplyExpression();
                if (!nowAction.setProperties(ctx.type_name().getText(),ctx.expression().size() + ctx.array().size())) return null;

                for (MeazzaParser.ExpressionContext x : ctx.expression()){
                    if (!nowAction.addStage(visitExpression(x))) return null;
                }
                return nowAction;
            }
            else if(now.equals("++") || now.equals("--")){
                AutoAdjustExpression nowAction = new AutoAdjustExpression();
                nowAction.setChild(visitExpression(ctx.expression(0)));
                nowAction.setOpertaor(now);
                return nowAction.check() ? nowAction : null;
            }
            else if(now.equals("!") || now.equals("-") || now.equals("~")){
                AlterExpression nowAction = new AlterExpression();
                nowAction.setChild(visitExpression(ctx.expression(0)));
                nowAction.setOpertaor(now);
                return nowAction.check() ? nowAction : null;
            }
        }
        else if (ctx.ID() != null){
            if (ctx.fop == null) {
                SymbolElement nowAction = new SymbolElement(getVar(ctx.ID().getText()));
                return nowAction.check() ? nowAction : null;
            }
            else{
                SymbolElement nowAction = new SymbolElement(getFunc(ctx.ID().getText()));
                if (!nowAction.checkParameter(ctx.expression().size())) return null;
                for (int i = 0; i < ctx.expression().size(); i++)
                    if (!nowAction.checkParameter(visitExpression(ctx.expression(i)),i))
                        return null;
                return nowAction.check() ? nowAction : null;
            }
        }
        else if (ctx.const_expression() != null){
            Literal nowAction = new Literal();
            MeazzaParser.Const_expressionContext x = ctx.const_expression();
            if (x.INT_DATA() != null) nowAction.setProperties("int");
            if (x.STRING_DATA() != null) nowAction.setProperties("string");
            if (x.CHAR_DATA() != null) nowAction.setProperties("char");
            if (x.boolData != null) nowAction.setProperties("bool");
            if (x.nullData != null) nowAction.setProperties("@null");
            return nowAction;
        }
        else if (ctx.oop != null){
            return visitExpression(ctx.expression(0));
        }
        return null;
    }

    @Override
    public Boolean visitFunc_declaration(MeazzaParser.Func_declarationContext ctx) {
        String now = ctx.ID().getText();
        FuncSymbol nowFunc = getFunc(now);
        visitScope(nowFunc.FuncScope);

        if (!nowFunc.accept("void")) putVar("@return").setProperties(nowFunc);
        Boolean flag = visitCompound_statement(ctx.compound_statement());
        endScope();

        if (!nowFunc.accept("void"))
            if (getReserved("+")){
                System.err.println("Warning: Function "+ now + " do not have return value");
            }
        return flag;
    }

    @Override
    public Boolean visitCompound_statement(MeazzaParser.Compound_statementContext ctx) {
        boolean flag = true;
        for (int i = 0; i < ctx.getChildCount(); i++) {
            if (!(ctx.getChild(i) instanceof MeazzaParser.Var_declarationContext ||
                  ctx.getChild(i) instanceof MeazzaParser.StatementContext)) continue;
            flag = flag && (Boolean)visit(ctx.getChild(i));
        }
        return flag;
    }

    @Override
    public Boolean visitStatement(MeazzaParser.StatementContext ctx) {
        if (ctx.compound_statement() != null &&
           (getCurrentScope().size() > 0 ||
            getCurrentScope().getType() < 2)) { //Not (Loop or Branch)
            beginScope();
            boolean flag = visitCompound_statement(ctx.compound_statement());
            endScope();
            return flag;
        }
        else return (Boolean) visitChildren(ctx);
    }

    @Override
    public Boolean visitIf_statement(MeazzaParser.If_statementContext ctx) {
        ExpressionAction controlAction = visitExpression(ctx.expression());
        boolean flag = controlAction == null;
        BranchStatment nowAction = new BranchStatment();

        nowAction.setControl(controlAction);
        nowAction.getField(beginScope());
        visitScope(nowAction.field());;
        flag = flag && visitStatement(ctx.statement(0));
        endScope();
        if (ctx.statement(1) != null) {
            nowAction.getField2(beginScope());
            visitScope(nowAction.field2());
            flag = flag && visitStatement(ctx.statement(1));
            endScope();
        }
        nowAction.checkReturn();
        addAction(nowAction);
        return flag;
    }

    @Override
    public Boolean visitNormal_statement(MeazzaParser.Normal_statementContext ctx) {
        ExpressionAction nowAction = visitExpression(ctx.expression());
        if (nowAction != null){
            addAction(nowAction);
            return true;
        }
        return false;
    }

    @Override
    public Boolean visitWhile_statement(MeazzaParser.While_statementContext ctx) {
        ExpressionAction controlAction = visitExpression(ctx.expression());

        if (controlAction != null) {
            boolean flag = true;
            if (!controlAction.accept("bool")) {
                System.err.println("There should be boolean expression to control while statment");
                tagPos(ctx);
                flag = false;
            }


            LoopStatment nowAction = new LoopStatment();
            nowAction.setControl(controlAction);

            nowAction.getField(beginScope());
            visitScope(nowAction.field());
            flag = flag && visitStatement(ctx.statement());

            endScope();
            if (flag) addAction(nowAction);
            return flag;
        }
        return false;
    }

    @Override
    public Boolean visitJump_statement(MeazzaParser.Jump_statementContext ctx) {
        boolean flag;
        JumpStatment nowAction = new JumpStatment();
        if (ctx.expression() != null){
            ExpressionAction returnValue = visitExpression(ctx.expression());
            flag = returnValue != null;
            if (flag){
                nowAction.setReturnValue(returnValue);
                flag = nowAction.accepted();
            }
        } else {
            nowAction.set(ctx.op.getText());
            flag = nowAction.accepted();
        }
        if (flag) addAction(nowAction);
        return flag;
    }

    @Override
    public Boolean visitFor_statement(MeazzaParser.For_statementContext ctx) {
        LoopStatment nowAction = new LoopStatment();
        boolean flag = true;
        if (ctx.exp1 != null){
            ExpressionAction initializer = visitExpression(ctx.exp1);
            flag = initializer != null ;
            if (flag) addAction(initializer);
        }

        if (ctx.exp2 != null){
            ExpressionAction controlAction = visitExpression(ctx.exp2);
            if (!controlAction.accept("bool")) {
                System.err.println("There should be boolean expression to control for statment");
                tagPos(ctx);
            }
            else nowAction.setControl(controlAction);
        }

        ExpressionAction looper = null;
        if (ctx.exp3 != null) looper = visitExpression(ctx.exp3);

        nowAction.getField(beginScope());

        visitScope(nowAction.field());
        if (!visitStatement(ctx.statement())) flag = false;

        endScope();

        if (flag) {
            nowAction.field().addAction(looper);
            addAction(nowAction);
        }
        return flag;
    }
}