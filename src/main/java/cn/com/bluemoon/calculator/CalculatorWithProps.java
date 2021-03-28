package cn.com.bluemoon.calculator;

import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.ParseTreeProperty;

/**
 * @author ：zhym
 * @date ：Created in 2021/3/23 9:35
 * @description：annotate
 */
public class CalculatorWithProps extends CalculatorBaseListener{

    //使用IdentityMap<parseTree, Integer> 映射节点结果
    private ParseTreeProperty<Integer> result = new ParseTreeProperty<>();

    public void setVal(ParseTree node, int val) {
        result.put(node, val);
    }

    public int getVal(ParseTree node) {
        return result.get(node);
    }

    @Override
    public void exitCal(CalculatorParser.CalContext ctx) {
        setVal(ctx, getVal(ctx.exp()));
    }

    @Override
    public void exitAdd(CalculatorParser.AddContext ctx) {
        //子树有3个节点，两个操作数、一个操作符  1+2
        int left = getVal(ctx.getChild(0));
        int right = getVal(ctx.getChild(2));
        setVal(ctx, left + right);
    }

    @Override
    public void exitMul(CalculatorParser.MulContext ctx) {
        //子树有3个节点，两个操作数、一个操作符  1+2
        int left = getVal(ctx.getChild(0));
        int right = getVal(ctx.getChild(2));
        setVal(ctx, left * right);
    }

    @Override
    public void exitInt(CalculatorParser.IntContext ctx) {
        setVal(ctx, Integer.valueOf(ctx.getText()));
    }
}
