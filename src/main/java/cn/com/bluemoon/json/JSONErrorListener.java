package cn.com.bluemoon.json;

import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.misc.Interval;


/**
 * @author ：zhym
 * @date ：Created in 2021/3/24 9:29
 * @description：error listener
 */
public class JSONErrorListener extends BaseErrorListener {

    @Override
    public void syntaxError(Recognizer<?, ?> recognizer, Object offendingSymbol, int line, int charPositionInLine, String msg, RecognitionException e) {

        String errorText = null;
        if (recognizer instanceof  Lexer) {
            Lexer lexer = (Lexer) recognizer;
            //获取输入文本
            String inputText = lexer._input.getText(Interval.of(lexer._tokenStartCharIndex, lexer._input.index()));
            //获取错误文本
            errorText = lexer.getErrorDisplay(inputText);
            System.err.println(String.format("行%d列%d非法符号：%s.原因：%s", line, charPositionInLine, errorText, msg));
        } else {
            CommonToken token = (CommonToken) offendingSymbol;
            errorText = token.getText();
            System.err.println(String.format("行%d列%d语法不符合规范：%s.原因：%s", line, charPositionInLine, errorText, msg));
        }




    }
}
