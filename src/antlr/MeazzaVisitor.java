// Generated from C:/Users/Bill/OneDrive/Ideaprojects/Meazzacompiler\Meazza.g4 by ANTLR 4.5.1
package antlr;
import org.antlr.v4.runtime.tree.ParseTreeVisitor;

/**
 * This interface defines a complete generic visitor for a parse tree produced
 * by {@link MeazzaParser}.
 *
 * @param <T> The return type of the visit operation. Use {@link Void} for
 * operations with no return type.
 */
public interface MeazzaVisitor<T> extends ParseTreeVisitor<T> {
	/**
	 * Visit a parse tree produced by {@link MeazzaParser#r}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitR(MeazzaParser.RContext ctx);
	/**
	 * Visit a parse tree produced by {@link MeazzaParser#prog}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitProg(MeazzaParser.ProgContext ctx);
	/**
	 * Visit a parse tree produced by {@link MeazzaParser#comment}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitComment(MeazzaParser.CommentContext ctx);
	/**
	 * Visit a parse tree produced by {@link MeazzaParser#var_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitVar_declaration(MeazzaParser.Var_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link MeazzaParser#raw_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitRaw_declaration(MeazzaParser.Raw_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link MeazzaParser#type}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitType(MeazzaParser.TypeContext ctx);
	/**
	 * Visit a parse tree produced by {@link MeazzaParser#array}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitArray(MeazzaParser.ArrayContext ctx);
	/**
	 * Visit a parse tree produced by {@link MeazzaParser#type_name}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitType_name(MeazzaParser.Type_nameContext ctx);
	/**
	 * Visit a parse tree produced by {@link MeazzaParser#const_expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitConst_expression(MeazzaParser.Const_expressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link MeazzaParser#func_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitFunc_declaration(MeazzaParser.Func_declarationContext ctx);
	/**
	 * Visit a parse tree produced by {@link MeazzaParser#parameters}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitParameters(MeazzaParser.ParametersContext ctx);
	/**
	 * Visit a parse tree produced by {@link MeazzaParser#parameter}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitParameter(MeazzaParser.ParameterContext ctx);
	/**
	 * Visit a parse tree produced by {@link MeazzaParser#compound_statement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCompound_statement(MeazzaParser.Compound_statementContext ctx);
	/**
	 * Visit a parse tree produced by {@link MeazzaParser#statement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitStatement(MeazzaParser.StatementContext ctx);
	/**
	 * Visit a parse tree produced by {@link MeazzaParser#if_statement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitIf_statement(MeazzaParser.If_statementContext ctx);
	/**
	 * Visit a parse tree produced by {@link MeazzaParser#for_statement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitFor_statement(MeazzaParser.For_statementContext ctx);
	/**
	 * Visit a parse tree produced by {@link MeazzaParser#while_statement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitWhile_statement(MeazzaParser.While_statementContext ctx);
	/**
	 * Visit a parse tree produced by {@link MeazzaParser#jump_statement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitJump_statement(MeazzaParser.Jump_statementContext ctx);
	/**
	 * Visit a parse tree produced by {@link MeazzaParser#normal_statement}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitNormal_statement(MeazzaParser.Normal_statementContext ctx);
	/**
	 * Visit a parse tree produced by {@link MeazzaParser#expression}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitExpression(MeazzaParser.ExpressionContext ctx);
	/**
	 * Visit a parse tree produced by {@link MeazzaParser#class_declaration}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitClass_declaration(MeazzaParser.Class_declarationContext ctx);
}