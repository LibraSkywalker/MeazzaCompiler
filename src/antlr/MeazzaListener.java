// Generated from C:/Users/Bill/OneDrive/Ideaprojects/Meazzacompiler\Meazza.g4 by ANTLR 4.5.1
package antlr;
import org.antlr.v4.runtime.tree.ParseTreeListener;

/**
 * This interface defines a complete listener for a parse tree produced by
 * {@link MeazzaParser}.
 */
public interface MeazzaListener extends ParseTreeListener {
	/**
	 * Enter a parse tree produced by {@link MeazzaParser#r}.
	 * @param ctx the parse tree
	 */
	void enterR(MeazzaParser.RContext ctx);
	/**
	 * Exit a parse tree produced by {@link MeazzaParser#r}.
	 * @param ctx the parse tree
	 */
	void exitR(MeazzaParser.RContext ctx);
	/**
	 * Enter a parse tree produced by {@link MeazzaParser#prog}.
	 * @param ctx the parse tree
	 */
	void enterProg(MeazzaParser.ProgContext ctx);
	/**
	 * Exit a parse tree produced by {@link MeazzaParser#prog}.
	 * @param ctx the parse tree
	 */
	void exitProg(MeazzaParser.ProgContext ctx);
	/**
	 * Enter a parse tree produced by {@link MeazzaParser#comment}.
	 * @param ctx the parse tree
	 */
	void enterComment(MeazzaParser.CommentContext ctx);
	/**
	 * Exit a parse tree produced by {@link MeazzaParser#comment}.
	 * @param ctx the parse tree
	 */
	void exitComment(MeazzaParser.CommentContext ctx);
	/**
	 * Enter a parse tree produced by {@link MeazzaParser#var_declaration}.
	 * @param ctx the parse tree
	 */
	void enterVar_declaration(MeazzaParser.Var_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link MeazzaParser#var_declaration}.
	 * @param ctx the parse tree
	 */
	void exitVar_declaration(MeazzaParser.Var_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link MeazzaParser#raw_declaration}.
	 * @param ctx the parse tree
	 */
	void enterRaw_declaration(MeazzaParser.Raw_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link MeazzaParser#raw_declaration}.
	 * @param ctx the parse tree
	 */
	void exitRaw_declaration(MeazzaParser.Raw_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link MeazzaParser#type}.
	 * @param ctx the parse tree
	 */
	void enterType(MeazzaParser.TypeContext ctx);
	/**
	 * Exit a parse tree produced by {@link MeazzaParser#type}.
	 * @param ctx the parse tree
	 */
	void exitType(MeazzaParser.TypeContext ctx);
	/**
	 * Enter a parse tree produced by {@link MeazzaParser#array}.
	 * @param ctx the parse tree
	 */
	void enterArray(MeazzaParser.ArrayContext ctx);
	/**
	 * Exit a parse tree produced by {@link MeazzaParser#array}.
	 * @param ctx the parse tree
	 */
	void exitArray(MeazzaParser.ArrayContext ctx);
	/**
	 * Enter a parse tree produced by {@link MeazzaParser#type_name}.
	 * @param ctx the parse tree
	 */
	void enterType_name(MeazzaParser.Type_nameContext ctx);
	/**
	 * Exit a parse tree produced by {@link MeazzaParser#type_name}.
	 * @param ctx the parse tree
	 */
	void exitType_name(MeazzaParser.Type_nameContext ctx);
	/**
	 * Enter a parse tree produced by {@link MeazzaParser#const_expression}.
	 * @param ctx the parse tree
	 */
	void enterConst_expression(MeazzaParser.Const_expressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link MeazzaParser#const_expression}.
	 * @param ctx the parse tree
	 */
	void exitConst_expression(MeazzaParser.Const_expressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link MeazzaParser#func_declaration}.
	 * @param ctx the parse tree
	 */
	void enterFunc_declaration(MeazzaParser.Func_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link MeazzaParser#func_declaration}.
	 * @param ctx the parse tree
	 */
	void exitFunc_declaration(MeazzaParser.Func_declarationContext ctx);
	/**
	 * Enter a parse tree produced by {@link MeazzaParser#parameters}.
	 * @param ctx the parse tree
	 */
	void enterParameters(MeazzaParser.ParametersContext ctx);
	/**
	 * Exit a parse tree produced by {@link MeazzaParser#parameters}.
	 * @param ctx the parse tree
	 */
	void exitParameters(MeazzaParser.ParametersContext ctx);
	/**
	 * Enter a parse tree produced by {@link MeazzaParser#parameter}.
	 * @param ctx the parse tree
	 */
	void enterParameter(MeazzaParser.ParameterContext ctx);
	/**
	 * Exit a parse tree produced by {@link MeazzaParser#parameter}.
	 * @param ctx the parse tree
	 */
	void exitParameter(MeazzaParser.ParameterContext ctx);
	/**
	 * Enter a parse tree produced by {@link MeazzaParser#compound_statement}.
	 * @param ctx the parse tree
	 */
	void enterCompound_statement(MeazzaParser.Compound_statementContext ctx);
	/**
	 * Exit a parse tree produced by {@link MeazzaParser#compound_statement}.
	 * @param ctx the parse tree
	 */
	void exitCompound_statement(MeazzaParser.Compound_statementContext ctx);
	/**
	 * Enter a parse tree produced by {@link MeazzaParser#statement}.
	 * @param ctx the parse tree
	 */
	void enterStatement(MeazzaParser.StatementContext ctx);
	/**
	 * Exit a parse tree produced by {@link MeazzaParser#statement}.
	 * @param ctx the parse tree
	 */
	void exitStatement(MeazzaParser.StatementContext ctx);
	/**
	 * Enter a parse tree produced by {@link MeazzaParser#if_statement}.
	 * @param ctx the parse tree
	 */
	void enterIf_statement(MeazzaParser.If_statementContext ctx);
	/**
	 * Exit a parse tree produced by {@link MeazzaParser#if_statement}.
	 * @param ctx the parse tree
	 */
	void exitIf_statement(MeazzaParser.If_statementContext ctx);
	/**
	 * Enter a parse tree produced by {@link MeazzaParser#for_statement}.
	 * @param ctx the parse tree
	 */
	void enterFor_statement(MeazzaParser.For_statementContext ctx);
	/**
	 * Exit a parse tree produced by {@link MeazzaParser#for_statement}.
	 * @param ctx the parse tree
	 */
	void exitFor_statement(MeazzaParser.For_statementContext ctx);
	/**
	 * Enter a parse tree produced by {@link MeazzaParser#while_statement}.
	 * @param ctx the parse tree
	 */
	void enterWhile_statement(MeazzaParser.While_statementContext ctx);
	/**
	 * Exit a parse tree produced by {@link MeazzaParser#while_statement}.
	 * @param ctx the parse tree
	 */
	void exitWhile_statement(MeazzaParser.While_statementContext ctx);
	/**
	 * Enter a parse tree produced by {@link MeazzaParser#jump_statement}.
	 * @param ctx the parse tree
	 */
	void enterJump_statement(MeazzaParser.Jump_statementContext ctx);
	/**
	 * Exit a parse tree produced by {@link MeazzaParser#jump_statement}.
	 * @param ctx the parse tree
	 */
	void exitJump_statement(MeazzaParser.Jump_statementContext ctx);
	/**
	 * Enter a parse tree produced by {@link MeazzaParser#normal_statement}.
	 * @param ctx the parse tree
	 */
	void enterNormal_statement(MeazzaParser.Normal_statementContext ctx);
	/**
	 * Exit a parse tree produced by {@link MeazzaParser#normal_statement}.
	 * @param ctx the parse tree
	 */
	void exitNormal_statement(MeazzaParser.Normal_statementContext ctx);
	/**
	 * Enter a parse tree produced by {@link MeazzaParser#expression}.
	 * @param ctx the parse tree
	 */
	void enterExpression(MeazzaParser.ExpressionContext ctx);
	/**
	 * Exit a parse tree produced by {@link MeazzaParser#expression}.
	 * @param ctx the parse tree
	 */
	void exitExpression(MeazzaParser.ExpressionContext ctx);
	/**
	 * Enter a parse tree produced by {@link MeazzaParser#class_declaration}.
	 * @param ctx the parse tree
	 */
	void enterClass_declaration(MeazzaParser.Class_declarationContext ctx);
	/**
	 * Exit a parse tree produced by {@link MeazzaParser#class_declaration}.
	 * @param ctx the parse tree
	 */
	void exitClass_declaration(MeazzaParser.Class_declarationContext ctx);
}