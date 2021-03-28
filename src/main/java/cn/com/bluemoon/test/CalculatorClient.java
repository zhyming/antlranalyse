package cn.com.bluemoon.test;

import cn.com.bluemoon.calculator.*;
import org.antlr.v4.runtime.ANTLRInputStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.tree.ParseTreeWalker;
import org.omg.PortableInterceptor.INACTIVE;

/**
 * @author ：zhym
 * @date ：Created in 2021/3/23 8:51
 * @description：测试窗口
 */
public class CalculatorClient {

    public static void main(String[] args) {
        ANTLRInputStream inputStream = new ANTLRInputStream("23 + 4 * 23");
        //构建词法分析器
        CalculatorLexer lexer = new CalculatorLexer(inputStream);
        //分析得到tokens
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        //构建语法分析器，并对tokens进行分析
        CalculatorParser parser = new CalculatorParser(tokens);

        //调用语法,方法，得到方法树
        CalculatorParser.CalContext context = parser.cal();
        System.out.println(context.toStringTree(parser));

        //监听器会被ParseTreeWalker 调用
        ParseTreeWalker walker = new ParseTreeWalker();
        //创建监听器
        CalculatorWithProps calculatorWithProps = new CalculatorWithProps();
        //把监听器添加到Walker中，解析时walker会自动调用里头相应的方法
        walker.walk(calculatorWithProps, context);

        Integer result = calculatorWithProps.getVal(context);

        System.out.println("计算结果为： " + result);
    }

    public static void main2(String[] args) {

        ANTLRInputStream inputStream = new ANTLRInputStream("23 + 4 * 23");
        //构建词法分析器
        CalculatorLexer lexer = new CalculatorLexer(inputStream);
        //分析得到tokens
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        //构建语法分析器，并对tokens进行分析
        CalculatorParser parser = new CalculatorParser(tokens);

        //调用语法,方法，得到方法树
        CalculatorParser.CalContext context = parser.cal();
        System.out.println(context.toStringTree(parser));

        //监听器会被ParseTreeWalker 调用
        ParseTreeWalker walker = new ParseTreeWalker();
        //创建监听器
        CalculatorlistenerImpl listener = new CalculatorlistenerImpl();
        //把监听器添加到Walker中，解析时walker会自动调用里头相应的方法
        walker.walk(listener, context);

        Integer result = listener.getResult();

        System.out.println("计算结果为： " + result);

    }

    public static void main1(String[] args) {

        ANTLRInputStream inputStream = new ANTLRInputStream("23 + 4 * 23");
        //构建词法分析器
        CalculatorLexer lexer = new CalculatorLexer(inputStream);
        //分析得到tokens
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        //构建语法分析器，并对tokens进行分析
        CalculatorParser parser = new CalculatorParser(tokens);

        //调用语法,方法，得到方法树
        CalculatorParser.CalContext context = parser.cal();
        System.out.println(context.toStringTree(parser));

        CalculatorVisitorImpl visitor = new CalculatorVisitorImpl();
        Integer result = visitor.visit(context);
        System.out.println("计算结果为： " + result);

    }
}
