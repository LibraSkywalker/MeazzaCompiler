package AST.Expression;

import MIPS.Instruction.AddBinInstruction;
import MIPS.Instruction.BranchInstruction;
import MIPS.Instruction.RegBinInstruction;
import MIPS.Instruction.RegTerInstruction;

import java.util.ArrayList;

import static MIPS.IRControler.getBlock;
import static RegisterControler.ReservedRegister.globalAddress;
import static RegisterControler.VirtualRegister.newVReg;

/**
 * Created by Bill on 2016/4/10.
 */
public class StageExpression extends ExpressionAction{
    private ArrayList<ExpressionAction> stageValue = new ArrayList<>();
    private ExpressionAction previousAction;
    boolean lvalue;

    public void set(){}
    public boolean check(){return previousAction != null;}
    public void setPreviousAction(ExpressionAction now){
        if (now == null) return;
        previousAction = now;
        properties.setProperties(now.properties);
        if (now instanceof DotElement)
            lvalue = ((DotElement) now).lvalue;
        if (now instanceof SymbolElement)
            lvalue = ((SymbolElement) now).lvalue;
        now.parentAction = this;
    }

    public boolean addStage(ExpressionAction now){
        if (now == null) return false;
        if (!properties.findDownStair()) {
            System.err.println("Too many stages are required");
            return false;
        }
        if (!now.properties.accept("int")){
            System.err.println("There should be an int Expression inside the stage ");
            return false;
        }
        stageValue.add(now);
        return true;
    }

    public String toString(){
        return "Stage " + previousAction.toString() + " to " + properties.toString();
    }

    public void Translate(){
        previousAction.Translate();
        rDest = previousAction.rDest;
        for (ExpressionAction now : stageValue) {
            getBlock().add(new BranchInstruction("beq",rDest,0,"TrapState",false));
            now.Translate();
            int Src2 = now.src();
            if (now.isLiteral()) {
                Src2 *= 4;
            }
            else getBlock().add(new RegTerInstruction("mul", Src2, Src2, 4, false));
            getBlock().add(new RegTerInstruction("add", rDest, rDest, Src2, now.isLiteral())); // calculate delta
            int rSrc1 = rDest;
            rDest = newVReg();
            getBlock().add(new AddBinInstruction("lw",rDest, rSrc1));
            if (stageValue.indexOf(now) == stageValue.size() - 1)
                getBlock().add(new RegBinInstruction("la",globalAddress,rSrc1,true));
        }
        getBlock().add(new BranchInstruction("beq",rDest,0,"TrapState",false));
    }
}
