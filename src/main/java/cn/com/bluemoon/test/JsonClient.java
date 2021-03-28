package cn.com.bluemoon.test;

import cn.com.bluemoon.csv.CSVLexer;
import cn.com.bluemoon.csv.CSVParser;
import cn.com.bluemoon.csv.CSVToMapListener;
import cn.com.bluemoon.json.JSONErrorListener;
import cn.com.bluemoon.json.JSONLexer;
import cn.com.bluemoon.json.JSONParser;
import cn.com.bluemoon.json.JSONToXMLListener;
import org.antlr.v4.runtime.ANTLRInputStream;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.tree.ParseTreeWalker;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.nio.charset.Charset;

/**
 * @author ：zhym
 * @date ：Created in 2021/3/23 16:25
 * @description：json
 */
public class JsonClient {

    public static void main(String[] args) {
        try {
            /**
             * 使用{@link CharStream} 代替{@link ANTLRInputStream}
             */
            CharStream charStream = CharStreams.fromFileName("D:\\demo\\1.txt", Charset.forName("utf-8"));
            JSONErrorListener errorListener = new JSONErrorListener();
            JSONToXMLListener listener = new JSONToXMLListener();

            JSONLexer lexer = new JSONLexer(charStream);
            //先清空默认错误监听
            lexer.removeErrorListeners();
            //添加自定义错误分析器 -- 监听词法分析
            lexer.addErrorListener(errorListener);
            //词法符号缓冲区，暂存词法分析器生成的词法符号
            CommonTokenStream tokens = new CommonTokenStream(lexer);
            JSONParser parser = new JSONParser(tokens);
            //先清空默认错误监听
            parser.removeErrorListeners();
            //添加自定义错误监听 -- 监听语法分析
            parser.addErrorListener(errorListener);
            //添加语法解析监听
            parser.addParseListener(listener);
            //针对某个规则进行语法分析，此处是针对json
            JSONParser.JsonContext jsonContext = parser.json();
            //LISP风格打印分析树 -tree
            System.out.println(jsonContext.toStringTree());
            String xml = listener.getXml(jsonContext);
            System.out.println(xml);

        }catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
}
