package MIPS;

import AST.ASTControler;
import AST.ActionNodeBase;
import SymbolContainer.TypeSymbol;

import static AST.ASTControler.popAction;

/**
 * Created by Bill on 2016/4/28.
 */
public class IRcontroler {
    static BasicBlock currentBasicBlock = new BasicBlock("main");
    Function currentFunction;
    public static BasicBlock getBlock(){
        return currentBasicBlock;
    }
    void visit(ASTControler ast){
        for (ActionNodeBase now = popAction(); now != null; now = popAction()){
            now.Translate();
        }
    }

    void visitClass(TypeSymbol type){
    }

}
