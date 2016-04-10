import AST.ASTControler;
import AST.Builder;
import AST.FirstVisitor;
import AST.SecondVisitor;
import SymbolContainer.Scope;
import antlr.MeazzaLexer;
import antlr.MeazzaParser;
import org.antlr.v4.runtime.ANTLRInputStream;
import org.antlr.v4.runtime.CommonTokenStream;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.junit.runners.Parameterized;
import org.omg.CORBA.SystemException;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
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
        for (File f : new File("testcase/compile_error/").listFiles()) {
            if (f.isFile() && f.getName().endsWith(".mx")) {
                params.add(new Object[] { "testcase/compile_error/" + f.getName(), false });
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

            if (!shouldPass) fail("Should not pass.");
        } catch (Exception e) {
            if (shouldPass) throw e;
            else e.printStackTrace();
        }
    }
}