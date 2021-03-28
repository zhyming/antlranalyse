package cn.com.bluemoon.calculator;

/**
 * @author ：zhym
 * @date ：Created in 2021/3/23 8:43
 * @description：计算实现
 */
public class CalculatorVisitorImpl extends CalculatorBaseVisitor<Integer> {

    @Override
    public Integer visitAdd(CalculatorParser.AddContext ctx) {
        return visit(ctx.exp(0)) + visit(ctx.exp(1));
    }

    @Override
    public Integer visitMul(CalculatorParser.MulContext ctx) {
        return visit(ctx.exp(0)) * visit(ctx.exp(1));
    }

    @Override
    public Integer visitInt(CalculatorParser.IntContext ctx) {
        return Integer.valueOf(ctx.getText());
    }
}
