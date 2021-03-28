// Generated from E:/code/antlranalyse/g\ArrayInt.g4 by ANTLR 4.9.1
package cn.com.bluemoon.array;
import org.antlr.v4.runtime.tree.ParseTreeListener;

/**
 * This interface defines a complete listener for a parse tree produced by
 * {@link ArrayIntParser}.
 */
public interface ArrayIntListener extends ParseTreeListener {
	/**
	 * Enter a parse tree produced by {@link ArrayIntParser#init}.
	 * @param ctx the parse tree
	 */
	void enterInit(ArrayIntParser.InitContext ctx);
	/**
	 * Exit a parse tree produced by {@link ArrayIntParser#init}.
	 * @param ctx the parse tree
	 */
	void exitInit(ArrayIntParser.InitContext ctx);
	/**
	 * Enter a parse tree produced by {@link ArrayIntParser#value}.
	 * @param ctx the parse tree
	 */
	void enterValue(ArrayIntParser.ValueContext ctx);
	/**
	 * Exit a parse tree produced by {@link ArrayIntParser#value}.
	 * @param ctx the parse tree
	 */
	void exitValue(ArrayIntParser.ValueContext ctx);
}