package cn.com.bluemoon.test;

import cn.com.bluemoon.hello.HelloLexer;
import cn.com.bluemoon.hello.HelloParser;
import org.antlr.v4.runtime.ANTLRInputStream;
import org.antlr.v4.runtime.CommonTokenStream;

import java.util.Arrays;
import java.util.List;

/**
 * @author ：zhym
 * @date ：Created in 2021/3/22 9:45
 * @description：测试窗口
 */
public class HelloClient {

    public static void main(String[] args) {
        /*String[] testStr={
                "Hello world",
                "hello world",
                "hi world"
        };
        for(String s : testStr){
            System.out.println("Input: " + s);
            run(s);
        }*/
        System.out.println('\u00ff');

    }

    private static void run(String exp) {

        //构建输入流
        ANTLRInputStream inputStream = new ANTLRInputStream(exp);
        //构建词法分析器
        HelloLexer lexer = new HelloLexer(inputStream);
        //词法分析，得到token
        CommonTokenStream tokenStream = new CommonTokenStream(lexer);
        //构建语法分析器,并对得到的token进行分析
        HelloParser parser = new HelloParser(tokenStream);
        //调用规则r，即g文法定义的r，对输入进行验证
        parser.r();
    }
}
