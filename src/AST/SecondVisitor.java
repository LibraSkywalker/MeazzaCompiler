package AST;

import AST.Expression.*;
import AST.Statment.ForStatment;
import AST.Statment.IfStatment;
import AST.Statment.JumpStatment;
import AST.Statment.WhileStatment;
import SymbolTable.*;
import antlr.MeazzaBaseVisitor;
import antlr.MeazzaParser;
import java.lang.String;

import static main.main.*;

/**
 * Created by Bill on 2016/4/5.
 */
public class SecondVisitor extends MeazzaBaseVisitor<String>{
    @Override
    public String visitClass_declaration(MeazzaParser.Class_declarationContext ctx) {
        TypeSymbol nowClass =globalScope.getType(ctx.ID().getText());
        assert (nowClass != null) ;
        for(MeazzaParser.Raw_declarationContext x : ctx.raw_declaration()){
            String now ;
            if (x.type().type_name().ID() == null){
                now = x.type().type_name().VAR_TYPE().getText();
            }
            else {
                now = x.type().type_name().ID().getText();
            }
            TypeSymbol nowType = globalScope.getType(now) ;
            VariableSymbol nowSymbol = nowClass.resolvedMember(x.ID().getText());
            if (nowSymbol == null) return "Variable creation failed in " + ctx.ID().getText();
            nowSymbol.setType(nowType);
            nowSymbol.setDimension(x.type().array().size());
        }
        return "";
    }

    @Override
    public String visitProg(MeazzaParser.ProgContext ctx) {
        for (MeazzaParser.Class_declarationContext x : ctx.class_declaration()) {
            String Error = visitClass_declaration(x);
            if (!(Error.equals(""))) return Error;
        }
        for (int i = 0; i < ctx.getChildCount(); i++) {
            if (ctx.getChild(i) instanceof MeazzaParser.Class_declarationContext) continue;
            String Error = visit(ctx.getChild(i));
            if(!Error.equals("")) return Error;
        }
        return "";
    }

    @Override
    public String visitVar_declaration(MeazzaParser.Var_declarationContext ctx) {
        String now = ctx.type().type_name().getText();
        TypeSymbol nowType = globalScope.getType(now);
        if (nowType == null) return "Undefined Type:" + now + "exist";
        if (nowType == globalScope.getType("void")) return "A Variable cannot have the void type";
        now = ctx.ID().getText();
        VariableSymbol nowVariable = currentScope.putVar(now);
        if (nowVariable == null) return "Unable to define variable:" + now;
        nowVariable.setDimension(ctx.type().array().size());
        nowVariable.setType(nowType);
        AssignExpression nowAction = new AssignExpression();
        nowAction.getLeft(nowVariable);
        if (ctx.expression() != null) {
            currentScope.actionList.add(currentAction);
            String Error = visitExpression(ctx.expression());
            if (!Error.equals("")) return Error;
            nowAction.getRight(currentAction);
            currentAction = nowAction;
            return nowAction.check();
        }
        return "";
    }

    private String BinaryDefault(MeazzaParser.ExpressionContext ctx,BinaryExpression nowAction){
        String Error = visitExpression(ctx.expression(0));
        if (!Error.equals("")) return Error;
        nowAction.getLeft(currentAction);
        currentAction = currentAction.parentAction = nowAction;

        Error = visitExpression(ctx.expression(1));
        if (!Error.equals("")) return Error;
        nowAction.getRight(currentAction);
        currentAction = currentAction.parentAction = nowAction;

        return "";
    }

    @Override
    public String visitExpression(MeazzaParser.ExpressionContext ctx) {
        if (ctx.op != null){
            String now = ctx.op.getText();
            if (now.equals("=")) {
                AssignExpression nowAction = new AssignExpression();
                String Error = BinaryDefault(ctx,nowAction);
                if (!Error.equals("")) return Error + " :" + ((Integer)ctx.getStart().getLine()).toString();
                return nowAction.check();
            }
            if (now.equals("||") || now.equals("&&")){
                LogicExpression nowAction = new LogicExpression();
                String Error = BinaryDefault(ctx,nowAction);
                if (!Error.equals("")) return Error + " :" + ((Integer)ctx.getStart().getLine()).toString();
                nowAction.getOperator(now);
                return nowAction.check();
            }
            if (now.equals("|") || now.equals("&") || now.equals("^") || now.equals("<<") || now.equals(">>")){
                BitExpression nowAction = new BitExpression();
                String Error = BinaryDefault(ctx,nowAction);
                if (!Error.equals("")) return  Error + " :" + ((Integer)ctx.getStart().getLine()).toString();
                nowAction.getOperator(now);
                return  nowAction.check();
            }
            if (now.equals("==")|| now.equals("!=") || now.equals(">") ||
                now.equals(">=")|| now.equals("<=") || now.equals("<") ){
                EqualExpression nowAction = new EqualExpression();
                String Error = BinaryDefault(ctx,nowAction) ;
                if (!Error.equals("")) return  Error + " :" + ((Integer)ctx.getStart().getLine()).toString();
                nowAction.getOperator(now);
                return  nowAction.check();
            }
            if (now.equals("[")){
                String Error = visitExpression(ctx.expression(0));
                if (!Error.equals("")) return Error + " :" + ((Integer)ctx.getStart().getLine()).toString();
                SymbolElement nowAction;
                if (currentAction instanceof lvalue){
                    nowAction = new lvalue();
                }
                else if (currentAction instanceof FunctionCall){
                    nowAction = new FunctionCall();
                }
                else return "stage requirement is illegal";

                nowAction.set((SymbolElement)currentAction);
                //System.out.println(nowAction.type().name());
                for (int i = 1; i < ctx.expression().size(); i++) {
                    Error = visitExpression(ctx.expression(i));
                    if (!Error.equals("")) return Error + " :" + ((Integer)ctx.getStart().getLine()).toString();
                    //System.out.println(((ExpressionAction) currentAction).type().name());
                    if (!nowAction.addStage((ExpressionAction) currentAction))
                        return "There should be an int Expression inside the stage :" + ((Integer)ctx.getStart().getLine()).toString();
                    currentAction.parentAction = nowAction;
                }

                if (nowAction.stage() > nowAction.dimension()) return "To much stage were required";
                currentAction = nowAction;
                //System.out.println(nowAction.type().name());
                return "";
            }
            if (now.equals(".")) {
                String Error = visitExpression(ctx.expression(0));
                if (!Error.equals("")) return Error + " :" + ((Integer)ctx.getStart().getLine()).toString();

                else if (ctx.sop != null){
                    if (((ExpressionAction)currentAction).dimension() == 0) return "cannot use size on non-array type";
                    FunctionCall nowAction = new FunctionCall();
                    nowAction.getElement(globalScope.getFunc("size"));
                    currentAction = nowAction;
                    return "";
                }

                Scope prevScope = currentScope;
                currentScope = ((ExpressionAction)currentAction).type().classMembers;
                Error = visitExpression(ctx.expression(1));
                if (!Error.equals("")) return Error + " :" + ((Integer)ctx.getStart().getLine()).toString();

                //System.out.println(currentAction.getClass());
                if (currentAction instanceof lvalue) {
                    if (!currentScope.contains(((lvalue) currentAction).element()))
                        return "illegal suffix exist, such variable isn't in the type";
                    lvalue nowAction = new lvalue();
                    nowAction.getElement(((lvalue) currentAction).element());
                    currentAction = currentAction.parentAction = nowAction;
                } else if (currentAction instanceof FunctionCall) {
                    if (!currentScope.contains(((FuncSymbol) ((FunctionCall) currentAction).element())))
                        return "illegal suffix exist, such function isn't in the type";
                    FunctionCall nowAction = new FunctionCall();
                    nowAction.getElement(((FunctionCall) currentAction).element());
                    currentAction = currentAction.parentAction =  nowAction;
                } else return "illegal suffix exist, suffix should be the classMember of the required type:";
                currentScope = prevScope;
                return "";
            }
            if (now.equals("+") || now.equals("-") || now.equals("*") || now.equals("/") || now.equals("%"))
            {
                CalcExpression nowAction = new CalcExpression();
                String Error = BinaryDefault(ctx,nowAction);
                if (!Error.equals("")) return Error + " :" + ((Integer)ctx.getStart().getLine()).toString();
                nowAction.getOperator(now);
                return nowAction.check();
            }
        }
        else if (ctx.uop != null){
            String now = ctx.uop.getText();
            if (now.equals("new")){
                MemoryApplyExpression nowAction = new MemoryApplyExpression();
                TypeSymbol nowType = globalScope.getType(ctx.type_name().getText());
                if (nowType == null) return "Undefined Type exist:"+ctx.type_name().getText();
                nowAction.setType(nowType);
                nowAction.setDimension(ctx.expression().size() + ctx.array().size());
                for (MeazzaParser.ExpressionContext x : ctx.expression()){
                    String Error = visitExpression(x);
                    if (!Error.equals("")) return Error + " :" + ((Integer)ctx.getStart().getLine()).toString();
                    nowAction.addStage((ExpressionAction) currentAction);
                }
                currentAction = nowAction;
                return "";
            }
            else if(now.equals("++") || now.equals("--")){
                String Error = visitExpression(ctx.expression(0));
                if (!Error.equals("")) return Error + " :" + ((Integer)ctx.getStart().getLine()).toString();
                if (!(currentAction instanceof lvalue))
                    return "++/-- should be operate on lvalue";
                if (((lvalue) currentAction).isNot("int"))
                    return "++/-- should be operate on int";
                selfAdjust nowAction = new selfAdjust();
                currentAction.parentAction = nowAction;
                nowAction.getOP(now);
                nowAction.set((ExpressionAction) currentAction);
            }
            else if(now.equals("!")){
                String Error = visitExpression(ctx.expression(0));
                if (!Error.equals("")) return Error + " :" + ((Integer)ctx.getStart().getLine()).toString();
                if (((ExpressionAction)currentAction).isNot("bool")){
                    return "There should be a bool after !";
                }
                AlterExpression nowAction = new AlterExpression();
                currentAction.parentAction = nowAction;
                nowAction.getChild((ExpressionAction) currentAction);
                nowAction.set((ExpressionAction) currentAction);
                nowAction.getOP(now);
            }
            else if (now.equals("-")){
                String Error = visitExpression(ctx.expression(0));
                if (!Error.equals("")) return Error + " :" + ((Integer)ctx.getStart().getLine()).toString();
                if (((ExpressionAction)currentAction).isNot("int")){
                    return "There should be an int after -";
                }
                AlterExpression nowAction = new AlterExpression();
                currentAction.parentAction = nowAction;
                nowAction.getChild((ExpressionAction) currentAction);
                nowAction.set((ExpressionAction) currentAction);
                nowAction.getOP(now);
            }
        }
        else if (ctx.ID() != null){
            if (ctx.fop == null) {
                lvalue nowAction = new lvalue();
                nowAction.getElement(currentScope.getVar(ctx.ID().getText()));
                //System.out.println(nowAction.type().name()+ " " + ctx.ID().getText());
                if (nowAction.element() == null) return "Undefined variable exist";
                currentAction = nowAction;
                return "";
            }
            else{
                FunctionCall nowAction = new FunctionCall();
                nowAction.getElement(currentScope.getFunc(ctx.ID().getText()));
                if (nowAction.element() == null) return "Undefined function exist";
                if (ctx.expression().size() != nowAction.element().parameter())
                    return "The number of Parameters is not correct " + ctx.ID().getText();
                for (int i = 0; i < ctx.expression().size(); i++){
                    visitExpression(ctx.expression(i));
                    VariableSymbol linked = ((FuncSymbol)nowAction.element()).findParameter(i) ;
                    if (!linked.typeEndure(((ExpressionAction)currentAction).type()))
                        return "Function call parameter Mismatch";
                    currentAction.parentAction = nowAction;
                }
                currentAction = nowAction;
                return "";
            }
        }
        else if (ctx.const_expression() != null){
            ConstExpression nowAction = new ConstExpression();
            MeazzaParser.Const_expressionContext x = ctx.const_expression();
            if (x.INT_DATA() != null) nowAction.setType(globalScope.getType("int"));
            if (x.STRING_DATA() != null) nowAction.setType(globalScope.getType("string"));
            if (x.CHAR_DATA() != null) nowAction.setType(globalScope.getType("char"));
            if (x.boolData != null) nowAction.setType(globalScope.getType("bool"));
            if (x.nullData != null) nowAction.setType(globalScope.getType(" "));
            currentAction = nowAction;
        }
        else if (ctx.oop != null){
            return visitExpression(ctx.expression(0));
        }
        return "";
    }

    @Override
    public String visitFunc_declaration(MeazzaParser.Func_declarationContext ctx) {
        String now = ctx.ID().getText();
        //if ( globalScope.getFunc(now) == null) System.out.println(now);
        currentScope = globalScope.getFunc(now).FuncScope;
        (currentScope.putVar("@")).copy(globalScope.getFunc(now));
        String Error = visitCompound_statement(ctx.compound_statement());

        if (!Error.equals("")) return Error + " :" + ((Integer)ctx.getStart().getLine()).toString();
        if (currentScope.getVar("@").type() != globalScope.getType("void") &&
            currentScope.getType("+") == null)
          //  return "The Function:" + now + " don't have a return type";
        currentScope = currentScope.endScope();
        return "";
    }

    @Override
    public String visitCompound_statement(MeazzaParser.Compound_statementContext ctx) {
        for (int i = 0; i < ctx.getChildCount(); i++) {
            if (!(ctx.getChild(i) instanceof MeazzaParser.Var_declarationContext ||
                ctx.getChild(i) instanceof MeazzaParser.StatementContext)) continue;
            String Error = visit(ctx.getChild(i));
            if (!Error.equals("")) return Error + " :" + ((Integer)ctx.getStart().getLine()).toString();
        }
        return "";
    }

    @Override
    public String visitStatement(MeazzaParser.StatementContext ctx) {
        return visitChildren(ctx);
    }

    @Override
    public String visitIf_statement(MeazzaParser.If_statementContext ctx) {
        String Error = visitExpression(ctx.expression());
        if (!Error.equals("")) return Error + " :" + ((Integer)ctx.getStart().getLine()).toString();
        if (((ExpressionAction) currentAction).isNot("bool"))
            return "The condition of if statment should be boolean expression :" + ((Integer)ctx.getStart().getLine()).toString();

        IfStatment nowAction = new IfStatment();

        nowAction.setControl((ExpressionAction) currentAction);

        nowAction.getField(currentScope.beginScope());
        currentScope = nowAction.field();
        Error = visitStatement(ctx.statement(0));
        if (!Error.equals("")) return Error + " :" + ((Integer)ctx.getStart().getLine()).toString();
        currentScope = currentScope.endScope();

        if (ctx.statement(1) != null) {

            nowAction.getField2(currentScope.beginScope());
            currentScope = nowAction.field2();
            Error = visitStatement(ctx.statement(1));
            if (!Error.equals("")) return Error + " :" + ((Integer)ctx.getStart().getLine()).toString();
            currentScope = currentScope.endScope();
        }

        currentScope.addAction(nowAction);
        currentAction = nowAction;
        return "";
    }

    @Override
    public String visitNormal_statement(MeazzaParser.Normal_statementContext ctx) {
        String Error = visitExpression(ctx.expression());
        if (!Error.equals("")) return Error + " :" + ((Integer)ctx.getStart().getLine()).toString();
        currentScope.addAction(currentAction);
        return "";
    }

    @Override
    public String visitWhile_statement(MeazzaParser.While_statementContext ctx) {
        String Error = visitExpression(ctx.expression());
        if (!Error.equals("")) return Error;
        if (((ExpressionAction)currentAction).isNot("bool"))
            return "The condition of while statment should be boolean expression :"+ ((Integer)ctx.getStart().getLine()).toString();


        WhileStatment nowAction = new WhileStatment();
        currentScope.addAction(nowAction);

        nowAction.setControl((ExpressionAction) currentAction);

        nowAction.getField(currentScope.beginScope());
        currentScope = nowAction.field();
        Error = visitStatement(ctx.statement());
        if (!Error.equals("")) return Error;
        currentScope = currentScope.endScope();

        currentScope.addAction(nowAction);
        currentAction = nowAction;

        return "";
    }

    @Override
    public String visitJump_statement(MeazzaParser.Jump_statementContext ctx) {
        JumpStatment nowAction = new JumpStatment();
        if (ctx.expression() != null){
            String Error = visitExpression(ctx.expression());
            if (!Error.equals("")) return Error;
            if (!currentScope.getVar("@").check((ExpressionAction) currentAction))
                return "Return Type isn't valid";
            else currentScope.putType("return");
            nowAction.setReturnValue((ExpressionAction) currentAction);
            currentAction = nowAction;
        }
        else {
            nowAction.setType(ctx.op.getText());
            if (ctx.op.getText().equals("continue") && !nowAction.Inloop())
                return "shouldn't continue, for there's no loop exist.";

        }
        return "";
    }

    @Override
    public String visitFor_statement(MeazzaParser.For_statementContext ctx) {
        ForStatment nowAction = new ForStatment();
        if (ctx.exp1 != null){
            String Error = visitExpression(ctx.exp1);
            if (!Error.equals("")) return Error;
            nowAction.setInitializer((ExpressionAction) currentAction);
        }

        if (ctx.exp2 != null){
            String Error = visitExpression(ctx.exp2);
            if (!Error.equals("")) return Error;
            if (((ExpressionAction) currentAction).isNot("bool"))
                return "The condition of for statmet should be bool";
            nowAction.setControl((ExpressionAction) currentAction);
        }

        if (ctx.exp3 != null){
            String Error = visitExpression(ctx.exp3);
            if (!Error.equals("")) return Error;
            nowAction.setLooper((ExpressionAction) currentAction);
        }

        nowAction.getField(currentScope.beginScope());
        currentScope = nowAction.field();
        String Error = visitStatement(ctx.statement());
        if (!Error.equals("")) return Error;
        currentScope = currentScope.endScope();

        currentAction = nowAction;
        return "";
    }
}
