package AST.Expression;

import MIPS.Instruction.AddBinInstruction;
import MIPS.Instruction.RegBinInstruction;
import MIPS.Instruction.RegTerInstruction;

import java.util.ArrayList;

import static MIPS.IRControler.getBlock;
import static RegisterControler.ReservedRegister.globalAllocator;
import static RegisterControler.VirtualRegister.newVReg;


/**
 * Created by Bill on 2016/4/4.
 */
public class AllocateExpression extends ExpressionAction{
    int assigned = 0;
    ArrayList<ExpressionAction> stageValue = new ArrayList<>();

    public void set(){}
    public boolean check(){
        return (!(properties.getDimension() == 0) || (!properties.type().isPrimitive()));
    }

    public boolean setProperties(String now,int dim){
       return properties.setProperties(now,dim);
    }

    public boolean addStage(ExpressionAction now){
        if (now == null) return false;
        if (!now.properties.accept("int")) return false;
        stageValue.add(now);
        //if (stageValue.size() > 1) return false;
        return true;
    }

    public void Translate(){
        rDest = newVReg();
        int rSrc1 = globalAllocator;
        getBlock().add(new RegTerInstruction("add", rDest, rSrc1 ,4 , false));
        int rSrc2;

        if (properties.getDimension() == 0) {
            rSrc2 = newVReg();
            int Src2 = properties.type().size();
            getBlock().add(new RegBinInstruction("li",rSrc2,Src2,false));

        } else {
            stageValue.get(0).Translate();
            ExpressionAction preAction = stageValue.get(0);
            rSrc2 = preAction.src();
            if (preAction.isLiteral()) rSrc2 = ((Literal) preAction).Reg();
        }
        getBlock().add(new AddBinInstruction("sw", rSrc2, rSrc1));
        getBlock().add(new RegTerInstruction("sll", rSrc2, rSrc2, 2, false));
        getBlock().add(new RegTerInstruction("add", rSrc1, rDest, rSrc2, true));
    }
    public String toString(){
        return "NEW:" + properties;
    }
}
