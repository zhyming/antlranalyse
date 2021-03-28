package cn.com.bluemoon.test;

import cn.com.bluemoon.csv.CSVLexer;
import cn.com.bluemoon.csv.CSVParser;
import cn.com.bluemoon.csv.CSVToMapListener;
import org.antlr.v4.runtime.ANTLRInputStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.antlr.v4.runtime.tree.ParseTreeWalker;

import java.io.*;
import java.util.List;
import java.util.Map;

/**
 * @author ：zhym
 * @date ：Created in 2021/3/23 11:23
 * @description：CSV
 */
public class CSVClient {


    public static void main(String[] args) {

        File file = new File("D:\\demo\\1.csv");
        try (FileInputStream fileInputStream =  new FileInputStream(file);
             InputStreamReader bInputStream = new InputStreamReader(fileInputStream, "utf-8");
             BufferedReader bufferedReader = new BufferedReader(bInputStream)
        ){
            ANTLRInputStream stream = new ANTLRInputStream(bufferedReader);
            CSVLexer lexer = new CSVLexer(stream);
            CommonTokenStream tokens = new CommonTokenStream(lexer);
            CSVParser parser = new CSVParser(tokens);
            CSVParser.FileContext fileContext = parser.file();

            CSVToMapListener listener = new CSVToMapListener();
            ParseTreeWalker walker = new ParseTreeWalker();
            walker.walk(listener, fileContext);
            List<Map<String, String>> rows = listener.getRows();
            System.out.println(rows.toString());

        }catch (Exception e) {

        }
    }

}
