package AST.Expression;

import MIPS.Instruction.AddBinInstruction;
import MIPS.Instruction.ArithmeticInstruction;
import MIPS.Instruction.RegBinInstruction;

import java.util.ArrayList;

import static MIPS.IRControler.addInstruction;
import static MIPS.IRControler.getBlock;
import static RegisterControler.RegisterName.globalAddress;
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
            now.Translate();
            int Src2 = now.src();
            int rSrc1 = rDest;
            rDest = newVReg();
            if (now.isLiteral()) {
                Src2 *= 4;
                addInstruction(new AddBinInstruction("lw",rDest, rSrc1,Src2));
                if (stageValue.indexOf(now) == stageValue.size() - 1)
                    addInstruction(new AddBinInstruction("la",globalAddress,rSrc1,Src2));
            }
            else {
                addInstruction(new ArithmeticInstruction("mul", Src2, Src2, 4, false));
                addInstruction(new ArithmeticInstruction("add",rSrc1,rSrc1,Src2,true));
                addInstruction(new AddBinInstruction("lw",rDest, rSrc1));
                if (stageValue.indexOf(now) == stageValue.size() - 1)
                    addInstruction(new AddBinInstruction("la",globalAddress,rSrc1));
            }
        }
    }
}
