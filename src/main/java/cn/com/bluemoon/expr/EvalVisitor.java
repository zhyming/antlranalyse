package cn.com.bluemoon.expr;

import java.util.HashMap;
import java.util.Map;

/**
 * @author ：zhym
 * @date ：Created in 2021/3/25 9:36
 * @description：visitor
 */
public class EvalVisitor extends ExprBaseVisitor<Integer> {

    //存储变量与值关系
    Map<String, Integer> memory = new HashMap<>();

    /**
     * expr NEWLINE
     * @param ctx
     * @return
     */
    @Override
    public Integer visitPrintExpr(ExprParser.PrintExprContext ctx) {
        Integer val = visit(ctx.expr());
        System.out.println(val);
        return 0;
    }

    /**
     * ID '=' expr NEWLINE
     * @param ctx
     * @return
     */
    @Override
    public Integer visitAssign(ExprParser.AssignContext ctx) {
        String id = ctx.ID().getText();
        Integer val = visit(ctx.expr());
        memory.put(id, val);
        return val;
    }

    /**
     * clear
     * @param ctx
     * @return
     */
    @Override
    public Integer visitClear(ExprParser.ClearContext ctx) {
        memory.clear();
        return 0;
    }

    /**
     * '(' expr ')'
     * @param ctx
     * @return
     */
    @Override
    public Integer visitParens(ExprParser.ParensContext ctx) {
        return visit(ctx.expr());
    }

    /**
     * expr ('*'|'/') expr
     * @param ctx
     * @return
     */
    @Override
    public Integer visitMulDiv(ExprParser.MulDivContext ctx) {
        Integer left = visit(ctx.expr(0));
        Integer right = visit(ctx.expr(1));
        if (ctx.op.getType() == ExprParser.MUL) return left * right;
        return left / right;
    }

    /**
     * expr ('+'|'-') expr
     * @param ctx
     * @return
     */
    @Override
    public Integer visitAddSub(ExprParser.AddSubContext ctx) {
        //左侧子表达式值
        Integer left = visit(ctx.expr(0));
        //右侧子表达式值
        Integer right = visit(ctx.expr(1));

        if (ctx.op.getType() == ExprParser.ADD) return left + right;

        return left - right;
    }

    /**
     * ID
     * @param ctx
     * @return
     */
    @Override
    public Integer visitId(ExprParser.IdContext ctx) {
        String id = ctx.ID().getText();
        if (memory.containsKey(id)) return memory.get(id);
        return 0;
    }

    /**
     * INT
     * @param ctx
     * @return
     */
    @Override
    public Integer visitInt(ExprParser.IntContext ctx) {
        return Integer.valueOf(ctx.INT().getText());
    }
}
