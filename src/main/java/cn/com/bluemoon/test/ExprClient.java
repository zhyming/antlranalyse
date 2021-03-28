package cn.com.bluemoon.test;

import cn.com.bluemoon.expr.EvalVisitor;
import cn.com.bluemoon.expr.ExprLexer;
import cn.com.bluemoon.expr.ExprParser;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CommonTokenStream;

import java.io.FileInputStream;
import java.io.InputStream;
import java.nio.charset.Charset;

/**
 * @author ：zhym
 * @date ：Created in 2021/3/24 17:38
 * @description：expr
 */
public class ExprClient {

    public static void main(String[] args) throws Exception{

        /*String inputFile = null;
        if (args.length > 0) inputFile = args[0];
        InputStream is = System.in;
        if (inputFile != null) is = new FileInputStream(inputFile);*/
        CharStream charStream = CharStreams.fromFileName("D:\\demo\\1.txt", Charset.forName("utf-8"));
        //CharStream charStream = CharStreams.fromStream(is);
        ExprLexer lexer = new ExprLexer((charStream));
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        ExprParser parser = new ExprParser(tokens);
        ExprParser.ProgContext prog = parser.prog();
        EvalVisitor visitor = new EvalVisitor();
        visitor.visit(prog);
        //System.out.println(prog.toStringTree(parser));
    }
}
