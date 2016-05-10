import AST.ASTControler;
import MIPS.IRControler;
import antlr.MeazzaLexer;
import antlr.MeazzaParser;
import org.antlr.v4.runtime.ANTLRInputStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;

import java.io.*;
import java.util.ArrayList;
import java.util.Collection;

import static org.junit.Assert.fail;

@RunWith(Parameterized.class)
public class test  {
    @Parameterized.Parameters
    public static Collection<Object[]> data(){
        Collection<Object[]> params = new ArrayList<>();
        for (File f : new File("testcase/passed/").listFiles()) {
            if (f.isFile() && f.getName().endsWith(".mx")) {
                params.add(new Object[] { "testcase/passed/" + f.getName(), true });
            }
        }
        return params;
    }

    private String filename;
    private boolean shouldPass;

    public test(String filename, boolean shouldPass) {
        this.filename = filename;
        this.shouldPass = shouldPass;
    }

    @Test
    public void testPass() throws IOException {
        System.out.println(filename);

        try {
            InputStream is = new FileInputStream(filename);
            ANTLRInputStream input = new ANTLRInputStream(is);

            MeazzaLexer lexer = new MeazzaLexer(input);
            CommonTokenStream tokens = new CommonTokenStream(lexer);

            MeazzaParser parser = new MeazzaParser(tokens);
            MeazzaParser.ProgContext ctx = parser.prog();

            ASTControler visitor = new ASTControler();
            if (!visitor.Visit(ctx)) throw new IOException();

            IRControler transformer = new IRControler();
            transformer.visit();


            FileWriter file = new FileWriter("hello.s");
            BufferedWriter output = new BufferedWriter(file);
            output.flush();
            output.write(transformer.virtualPrint());
            output.close();
            file.close();

            transformer.RegisterAllocate();

            file = new FileWriter("hello2.s");
            output = new BufferedWriter(file);
            output.flush();
            output.write(transformer.virtualPrint());
            output.close();
            file.close();


            file = new FileWriter("data.s");
            output = new BufferedWriter(file);
            output.flush();
            output.write(transformer.toString());
            output.close();
            file.close();

            //System.out.println(transformer.virtualPrint());

            if (!shouldPass) fail("Should not pass.");
        } catch (Exception e) {
            if (shouldPass) throw e;
            else e.printStackTrace();
        }
    }
}