package cn.com.bluemoon.test;

import cn.com.bluemoon.array.ArrayIntLexer;
import cn.com.bluemoon.array.ArrayIntParser;
import cn.com.bluemoon.array.ArrayStringListener;
import org.antlr.v4.runtime.CharStreams;
import org.antlr.v4.runtime.CodePointCharStream;
import org.antlr.v4.runtime.CommonTokenStream;

/**
 * @author ：zhym
 * @date ：Created in 2021/3/24 16:35
 * @description：array
 */
public class ArrayClient {

    public static void main(String[] args) {
        CodePointCharStream charStream = CharStreams.fromString("{23, 443, 55}");

        ArrayIntLexer lexer = new ArrayIntLexer(charStream);
        CommonTokenStream tokens = new CommonTokenStream(lexer);
        ArrayIntParser parser = new ArrayIntParser(tokens);
        parser.addParseListener(new ArrayStringListener());

        parser.init();

    }

}
