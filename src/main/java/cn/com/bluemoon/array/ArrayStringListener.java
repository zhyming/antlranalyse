package cn.com.bluemoon.array;

/**
 * @author ：zhym
 * @date ：Created in 2021/3/24 16:24
 * @description：toString
 */
//转换 {1， 2， 3} -》 "\u0001\u0002\u0003"
public class ArrayStringListener extends ArrayIntBaseListener {

    @Override
    public void enterInit(ArrayIntParser.InitContext ctx) {
        System.out.print("\"");
    }

    @Override
    public void exitInit(ArrayIntParser.InitContext ctx) {
        System.out.print("\"");
    }

    @Override
    public void exitValue(ArrayIntParser.ValueContext ctx) {
        //将值转换为16进制后+\\u
        Integer val = Integer.valueOf(ctx.INT().getText());
        System.out.printf("\\u%04x", val);
    }
}
