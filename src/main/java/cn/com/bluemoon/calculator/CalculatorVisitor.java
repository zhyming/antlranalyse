// Generated from E:/idea-workspace/antlranalyse/g\Calculator.g4 by ANTLR 4.9.1
package cn.com.bluemoon.calculator;
import org.antlr.v4.runtime.tree.ParseTreeVisitor;

/**
 * This interface defines a complete generic visitor for a parse tree produced
 * by {@link CalculatorParser}.
 *
 * @param <T> The return type of the visit operation. Use {@link Void} for
 * operations with no return type.
 */
public interface CalculatorVisitor<T> extends ParseTreeVisitor<T> {
	/**
	 * Visit a parse tree produced by {@link CalculatorParser#cal}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitCal(CalculatorParser.CalContext ctx);
	/**
	 * Visit a parse tree produced by the {@code DIV}
	 * labeled alternative in {@link CalculatorParser#exp}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitDIV(CalculatorParser.DIVContext ctx);
	/**
	 * Visit a parse tree produced by the {@code Add}
	 * labeled alternative in {@link CalculatorParser#exp}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitAdd(CalculatorParser.AddContext ctx);
	/**
	 * Visit a parse tree produced by the {@code Sub}
	 * labeled alternative in {@link CalculatorParser#exp}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitSub(CalculatorParser.SubContext ctx);
	/**
	 * Visit a parse tree produced by the {@code Mul}
	 * labeled alternative in {@link CalculatorParser#exp}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitMul(CalculatorParser.MulContext ctx);
	/**
	 * Visit a parse tree produced by the {@code Int}
	 * labeled alternative in {@link CalculatorParser#exp}.
	 * @param ctx the parse tree
	 * @return the visitor result
	 */
	T visitInt(CalculatorParser.IntContext ctx);
}