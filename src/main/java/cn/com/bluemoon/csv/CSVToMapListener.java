package cn.com.bluemoon.csv;

import java.util.*;

/**
 * @author ：zhym
 * @date ：Created in 2021/3/23 11:06
 * @description：listener
 */
public class CSVToMapListener extends CSVBaseListener {

    private static final String EMPTY = "";
    private List<Map<String, String>> rows = new ArrayList<>();
    private List<String> headers = new ArrayList<>();
    private List<String> currentRows = new ArrayList<>();

    public List<Map<String, String>>  getRows() {
        return rows;
    }

    @Override
    public void exitFile(CSVParser.FileContext ctx) {
        super.exitFile(ctx);
    }

    @Override
    public void exitHeader(CSVParser.HeaderContext ctx) {
        headers.addAll(currentRows);
    }

    @Override
    public void enterRow(CSVParser.RowContext ctx) {
        currentRows.clear();
    }

    @Override
    public void exitRow(CSVParser.RowContext ctx) {

        //判读当前节点父节点是否为HeaderContext，如果是，则为标题行 以下两种方式都可以
        //if (ctx.getParent().getRuleIndex() == CSVParser.RULE_header) return;
        if (ctx.getParent() instanceof CSVParser.HeaderContext) {
            return;
        }
        Map<String, String> line = new LinkedHashMap<>();
        for (int i =0 ;i < headers.size(); i++) {
            line.put(headers.get(i), currentRows.get(i));
        }
        rows.add(line);
    }

    @Override
    public void exitText(CSVParser.TextContext ctx) {
        currentRows.add(ctx.getText());
    }

    @Override
    public void exitString(CSVParser.StringContext ctx) {
        currentRows.add(ctx.getText());
    }

    @Override
    public void exitEmpty(CSVParser.EmptyContext ctx) {
        currentRows.add(EMPTY);
    }
}
