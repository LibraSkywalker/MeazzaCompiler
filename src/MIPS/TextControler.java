package MIPS;

import AST.ASTControler;
import AST.ActionNodeBase;
import MIPS.Instruction.*;
import SymbolContainer.FuncSymbol;
import SymbolContainer.Scope;
import SymbolContainer.Symbol;
import SymbolContainer.TypeSymbol;

import java.util.ArrayList;

import static AST.ASTControler.*;
import static MIPS.Function.currentBasicBlock;
import static MIPS.IRControler.*;
import static RegisterControler.ReservedRegister.*;

/**
 * Created by Bill on 2016/5/2.
 */
public class TextControler {
    Function currentFunction;
    ArrayList<Function> functionList = new ArrayList<>();


    public String toString(){
        String str = ".text\n\n";
        for (Function now : functionList)
            str += now.toString();
        return str;
    }

    public String virtualPrint(){
        String str = ".text\n";
        for (Function now : functionList)
            str += now.virtualPrint();
        return str;
    }

    void visit(){
        addFunction("main");
        addInstruction(new RegTerInstruction("add",globalAllocator, globalPointer,getGlobeScope().memberSize() + 1,false));

        for (ActionNodeBase now = popAction(); now != null; now = popAction()){
            System.err.println(now + "***");
            now.Translate();
        }

        Scope curScope = getGlobeScope();
        for (FuncSymbol now : curScope.dict3){
            if (!now.isPrimitive()){
                if (now.name().equals("main"))
                    addBlock();
                else addFunction(now.name());
                visitFunc(now);
            }
        }
    }

    void visitFunc(FuncSymbol nowFunc){
        //introduce
        nowFunc.FuncScope.Translate();
        //cleanup
    }
}
