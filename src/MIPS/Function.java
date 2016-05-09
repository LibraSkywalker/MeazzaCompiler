package MIPS;

import MIPS.Instruction.ArithmeticInstruction;
import RegisterControler.RegisterStatic;

import java.util.LinkedList;

import static RegisterControler.RegisterName.s_p;
import static RegisterControler.VirtualRegister.BuildAllocater;

/**
 * Created by Bill on 2016/4/28.
 */
public class Function {
    LinkedList<BasicBlock> basicBlocks = new LinkedList<>();
    static BasicBlock currentBasicBlock;
    Integer number = 0;
    public String FuncName;
    public RegisterStatic localState = new RegisterStatic();
    BasicBlock getCurrentBasicBlock() {
        return currentBasicBlock;
    }

    Function(String name) {
        FuncName = name;
        if (!FuncName.equals("main"))
            FuncName = "func__" + FuncName;
        addBasicBlock("");
    }

    BasicBlock nextBlock(){
        return basicBlocks.get(basicBlocks.indexOf(currentBasicBlock));
    }


    BasicBlock visitBlock(BasicBlock now){
        currentBasicBlock = now;
        return now;
    }

    BasicBlock addBasicBlock(){
        BasicBlock now = new BasicBlock(FuncName + "_"+ number++);
        basicBlocks.add(basicBlocks.indexOf(getCurrentBasicBlock()) + 1,now);
        currentBasicBlock = now;
        return now;
    }

    BasicBlock addBasicBlock(String name){
        BasicBlock now;
        now = new BasicBlock(FuncName + name);
        basicBlocks.add(now);
        currentBasicBlock = now;
        return now;
    }

    BasicBlock addBasicBlock(BasicBlock preBlock,String name){
        BasicBlock now = new BasicBlock(preBlock.getLabel() + "_" + name);
        basicBlocks.add(basicBlocks.indexOf(getCurrentBasicBlock()) + 1,now);
        currentBasicBlock = now;
        return now;
    }

    public String toString(){
        String str = "";
        for (BasicBlock now : basicBlocks){
            str += now.toString();
            str += "\n";
        }
        return str;
    }

    public void eliminate(){
        for (BasicBlock now : basicBlocks){
            now.eliminate();
        }
    }

    void allocateStack(){
        if (localState.numToSave() == 0)
            return;
        int fsize = localState.numToSave() * 4;
        basicBlocks.getFirst().addFirst(new ArithmeticInstruction("sub",s_p,s_p,fsize,false));
        for (BasicBlock now : basicBlocks){
            now.cleanUp(fsize);
        }
    }

    public void classify(){
        eliminate();
        for (BasicBlock now : basicBlocks){
            currentBasicBlock = now;
            now.update();
            localState.load(now.usage);
            now.globalize(this);
        }
    }

    public void save(){
        localState.save();
    }

    public void configure(){
        BuildAllocater(this);
        for (BasicBlock now : basicBlocks){
            currentBasicBlock = now;
            now.configure();
        }
    }

    public String virtualPrint(){
        String str = "";
        for (BasicBlock now : basicBlocks){
            str += now.printUsage();
            str += now.virtualPrint();
            str += "\n";
        }
        str += localState.toString();
        return str;
    }

}
