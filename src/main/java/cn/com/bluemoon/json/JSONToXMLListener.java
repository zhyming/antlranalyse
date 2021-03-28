package cn.com.bluemoon.json;

import org.antlr.v4.runtime.tree.ParseTree;
import org.antlr.v4.runtime.tree.ParseTreeProperty;

/**
 * @author ：zhym
 * @date ：Created in 2021/3/23 14:19
 * @description：Listener
 */
public class JSONToXMLListener extends JSONBaseListener{

    //存储输出数据
    private ParseTreeProperty<String> xml = new ParseTreeProperty<>();

    public String getXml(ParseTree node) {
        return xml.get(node);
    }

    public void setXml(ParseTree node, String value) {
        xml.put(node, value);
    }

    //去掉字符串前后双引号
    public String stripQuotes(String s) {
        if (s == null || s.charAt(0) != '\"') return s;

        return s.substring(1, s.length() -1);

    }

    @Override
    public void exitJson(JSONParser.JsonContext ctx) {
        setXml(ctx, getXml(ctx.getChild(0)));
    }

    @Override
    public void exitAnObject(JSONParser.AnObjectContext ctx) {
        StringBuilder builder = new StringBuilder();
        builder.append("\n");
        ctx.pair().forEach(p -> builder.append(getXml(p)));
        setXml(ctx, builder.toString());
    }

    @Override
    public void exitEmptyObject(JSONParser.EmptyObjectContext ctx) {
        setXml(ctx, "");
    }

    @Override
    public void exitPair(JSONParser.PairContext ctx) {
        String tag = stripQuotes(ctx.STRING().getText());
        String value = String.format("<%s>\r\n\t%s\r\n</%s>\r\n", tag, getXml(ctx.value()), tag);
        setXml(ctx, value);
    }

    @Override
    public void exitArrayOfValues(JSONParser.ArrayOfValuesContext ctx) {
        StringBuilder builder = new StringBuilder();
        ctx.value().forEach(v -> {
            builder.append("<element>");
            builder.append(getXml(v));
            builder.append("</element>");
            builder.append("\n");
        });
        setXml(ctx, builder.toString());
    }

    @Override
    public void exitEmptyArray(JSONParser.EmptyArrayContext ctx) {
        setXml(ctx, "");
    }

    @Override
    public void exitString(JSONParser.StringContext ctx) {
        setXml(ctx, stripQuotes(ctx.getText()));
    }

    @Override
    public void exitAtom(JSONParser.AtomContext ctx) {
        setXml(ctx, ctx.getText());
    }

    @Override
    public void exitObjectValue(JSONParser.ObjectValueContext ctx) {
        setXml(ctx, getXml(ctx.object()));
    }

    @Override
    public void exitArrayValue(JSONParser.ArrayValueContext ctx) {
        setXml(ctx, getXml(ctx.array()));
    }


}
