package cn.com.bluemoon.test;

import cn.com.bluemoon.assign.AssignLexer;
import cn.com.bluemoon.assign.AssignParser;
import org.antlr.v4.runtime.ANTLRInputStream;
import org.antlr.v4.runtime.CommonTokenStream;

/**
 * @author ：zhym
 * @date ：Created in 2021/3/22 10:54
 * @description：Assign语法测试
 */
public class AssignClient {

    public static void main(String[] args) {
        run("a = 232.4444");
    }

    private static void run(String exp) {

        //读取输入文本
        ANTLRInputStream stream = new ANTLRInputStream(exp);
        //构建词法分析器
        AssignLexer lexer = new AssignLexer(stream);
        //分析生成tokens
        CommonTokenStream tokens= new CommonTokenStream(lexer);
        //构建语法分析器，并解析tokens
        AssignParser parser = new AssignParser(tokens);

        //调用要解析的语法单元
        AssignParser.AssignContext context = parser.assign();
        System.out.println(context.toStringTree(parser));

    }
}
