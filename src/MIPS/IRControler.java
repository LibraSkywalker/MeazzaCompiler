package MIPS;

import AST.ASTControler;
import AST.ActionNodeBase;
import MIPS.Instruction.Instruction;
import MIPS.Instruction.RegBinInstruction;
import SymbolContainer.TypeSymbol;

import static AST.ASTControler.getGlobeScope;
import static AST.ASTControler.popAction;
import static RegisterControler.ReservedRegister.globalAddress;

/**
 * Created by Bill on 2016/4/28.
 */
public class IRControler {
    static DataControler data = new DataControler();
    static TextControler text = new TextControler();

    public void visit(){
        text.visit();
    }

    public static BasicBlock getBlock(){
        return getCurrentFunction().getCurrentBasicBlock();
    }

    public static Function getFunction(){
        return getCurrentFunction();
    }

    public static Function getCurrentFunction() {
        return text.currentFunction;
    }

    public static DataControler getDataBlock(){
        return data;
    }

    public static String addData(String value){
        return data.add(value);
    }

    public static String addData(int name){
        return data.add(name);
    }

    public static void addFunction(String name){
        text.currentFunction = new Function(name);
        text.functionList.add(text.currentFunction);
    }

    public static void addBlock(String name){
        text.currentFunction.addBasicBlock(name);
    }

    public static void addBlock(BasicBlock preBlock,String name){
        text.currentFunction.addBasicBlock(preBlock,name);
    }
    public static void addBlock(){
        text.currentFunction.addBasicBlock();
    }

    public static void addInstruction(Instruction now){
        text.currentFunction.getCurrentBasicBlock().add(now);
    }
    public String toString(){
        return data.toString() + "\n\n" + text.toString();
    }

    public String virtualPrint(){
        return data.toString() + "\n\n" + text.virtualPrint();
    }

}
