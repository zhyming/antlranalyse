// Generated from E:/code/antlranalyse/g\Calculator.g4 by ANTLR 4.9.1
package cn.com.bluemoon.calculator;
import org.antlr.v4.runtime.tree.ParseTreeListener;

/**
 * This interface defines a complete listener for a parse tree produced by
 * {@link CalculatorParser}.
 */
public interface CalculatorListener extends ParseTreeListener {
	/**
	 * Enter a parse tree produced by {@link CalculatorParser#cal}.
	 * @param ctx the parse tree
	 */
	void enterCal(CalculatorParser.CalContext ctx);
	/**
	 * Exit a parse tree produced by {@link CalculatorParser#cal}.
	 * @param ctx the parse tree
	 */
	void exitCal(CalculatorParser.CalContext ctx);
	/**
	 * Enter a parse tree produced by the {@code Add}
	 * labeled alternative in {@link CalculatorParser#exp}.
	 * @param ctx the parse tree
	 */
	void enterAdd(CalculatorParser.AddContext ctx);
	/**
	 * Exit a parse tree produced by the {@code Add}
	 * labeled alternative in {@link CalculatorParser#exp}.
	 * @param ctx the parse tree
	 */
	void exitAdd(CalculatorParser.AddContext ctx);
	/**
	 * Enter a parse tree produced by the {@code Mul}
	 * labeled alternative in {@link CalculatorParser#exp}.
	 * @param ctx the parse tree
	 */
	void enterMul(CalculatorParser.MulContext ctx);
	/**
	 * Exit a parse tree produced by the {@code Mul}
	 * labeled alternative in {@link CalculatorParser#exp}.
	 * @param ctx the parse tree
	 */
	void exitMul(CalculatorParser.MulContext ctx);
	/**
	 * Enter a parse tree produced by the {@code Int}
	 * labeled alternative in {@link CalculatorParser#exp}.
	 * @param ctx the parse tree
	 */
	void enterInt(CalculatorParser.IntContext ctx);
	/**
	 * Exit a parse tree produced by the {@code Int}
	 * labeled alternative in {@link CalculatorParser#exp}.
	 * @param ctx the parse tree
	 */
	void exitInt(CalculatorParser.IntContext ctx);
}