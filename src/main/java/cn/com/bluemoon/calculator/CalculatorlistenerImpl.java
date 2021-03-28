package cn.com.bluemoon.calculator;

import java.util.Stack;

/**
 * @author ：zhym
 * @date ：Created in 2021/3/23 9:00
 * @description：监听实现
 */
public class CalculatorlistenerImpl extends CalculatorBaseListener {

    //定义一个栈存放中间结果
    private Stack<Integer> stack = new Stack<>();

    public Integer getResult() {
        return stack.pop();
    }

    @Override
    public void exitCal(CalculatorParser.CalContext ctx) {
        super.exitCal(ctx);
    }

    @Override
    public void exitAdd(CalculatorParser.AddContext ctx) {
        ctx.value = ctx.exp(0).value + ctx.exp(1).value;
        //入栈从往右，出栈从右到左
        Integer right = stack.pop();
        Integer left = stack.pop();
        stack.push(right + left);
    }

    @Override
    public void exitMul(CalculatorParser.MulContext ctx) {
        //入栈从往右，出栈从右到左
        Integer right = stack.pop();
        Integer left = stack.pop();
        stack.push(right * left);
    }

    @Override
    public void exitInt(CalculatorParser.IntContext ctx) {
        //将单个int值入栈
        stack.push(Integer.valueOf(ctx.getText()));
    }
}
