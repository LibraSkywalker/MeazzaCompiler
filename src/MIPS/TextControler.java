package MIPS;

import AST.ActionNodeBase;
import MIPS.Instruction.*;
import RegisterControler.RegisterStatic;
import SymbolContainer.FuncSymbol;
import SymbolContainer.Scope;

import java.util.ArrayList;

import static AST.ASTControler.*;
import static MIPS.IRControler.*;
import static MIPS.buildIn.buildIn_text;
import static RegisterControler.RegisterName.*;
import static RegisterControler.VirtualRegister.newVReg;

/**
 * Created by Bill on 2016/5/2.
 */
public class TextControler {
    Function currentFunction;
    ArrayList<Function> functionList = new ArrayList<>();
    public static RegisterStatic GlobalState = new RegisterStatic();

    public String toString(){
        String str = ".text\n\n";
        str += buildIn_text;
        for (Function now : functionList)
            str += now.toString();
        return str;
    }

    public String virtualPrint(){
        String str = ".text\n";
        str += buildIn_text;
        for (Function now : functionList)
            str += now.virtualPrint();
        str += GlobalState.toString();
        return str;
    }

    void visit(){
        addFunction("main");
        addInstruction(new RegBinInstruction("li",a_0,4,false));
        addInstruction(new RegBinInstruction("li",v_0,sbrk,false));
        addInstruction(new SystemCall());
        addInstruction(new RegBinInstruction("li",a_0,getGlobeScope().memberSize() * 4,false));
        addInstruction(new RegBinInstruction("li",v_0,sbrk,false));
        addInstruction(new SystemCall());
        addInstruction(new RegBinInstruction("move",globalVariable, v_0, true)); // assemble global varible area

        for (ActionNodeBase now = popAction(); now != null; now = popAction()){
            //System.err.println(now + "***");
            now.Translate();
        }

        addInstruction(new JumpInstruction("jal","main_0"));
        addInstruction(new RegBinInstruction("li",v_0,exitcode,false));
        addInstruction(new SystemCall());  //visit main and exit

        addBlock();
        visitFunc(getFunc("main"));

        Scope curScope = getGlobeScope();
        for (FuncSymbol now : curScope.dict3){
            if (!now.isPrimitive() && !now.name().equals("main")) {
                addFunction(now.name());
                visitFunc(now);
            }
        }
    }

    void visitFunc(FuncSymbol nowFunc){
        //introduce
        //int fsize = nowFunc.FuncScope.memberSize() * 4 + 12;
        //addInstruction(new ArithmeticInstruction("sub",s_p,s_p,fsize,false));

        if (r_a == 31) {
            int returnValue = newVReg();
            addInstruction(new RegBinInstruction("move", returnValue, r_a, true)); //save pre return
            r_a = returnValue;
        }
        for (int i = 0; i < 5; i++){
            visitScope(nowFunc.FuncScope);
            int rDest = nowFunc.FuncScope.update(i);
            if (rDest > 0) addInstruction(new RegBinInstruction("move",rDest,a_0 + i,true));
            //System.err.println(rDest + "!");
            endScope();
        }
        nowFunc.FuncScope.Translate();
        //addInstruction(new ArithmeticInstruction("add",s_p,s_p,fsize,false));
        if (r_a != 31)
            addInstruction(new RegBinInstruction("move",31,r_a,true));
        addInstruction(new JumpInstruction());
        r_a = 31;
        //cleanup
    }

    void RegisterAllocate(){
        for (Function now : functionList){
            now.classify();
            GlobalState.load(now.localState);
        } //classify virtual register


        GlobalState.adjust();

        for (Function now : functionList){
            now.save();
        }   //if too much

        GlobalState.save();
        for (Function now : functionList)
            now.allocateStack();
        for (Function now : functionList)
            now.configure();

    }
}
