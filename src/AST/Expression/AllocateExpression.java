package AST.Expression;

import MIPS.Instruction.AddBinInstruction;
import MIPS.Instruction.RegBinInstruction;
import MIPS.Instruction.ArithmeticInstruction;
import MIPS.Instruction.SystemCall;

import java.util.ArrayList;

import static AST.ASTControler.getCurrentScope;
import static AST.ASTControler.getGlobeScope;
import static MIPS.IRControler.addInstruction;
import static MIPS.IRControler.getBlock;
import static RegisterControler.RegisterName.a_0;
import static RegisterControler.RegisterName.v_0;
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

    public void Translate() {
        int Src2;
        boolean isReg = false;

        if (properties.getDimension() == 0) {
            Src2 = properties.type().size(); //class
        } else {
            stageValue.get(0).Translate();
            ExpressionAction preAction = stageValue.get(0);
            Src2 = preAction.src();
            isReg = !preAction.isLiteral();
        } //array

        addInstruction(new RegBinInstruction("li",a_0,4,false));
        addInstruction(new RegBinInstruction("li",v_0,9,false));
        addInstruction(new SystemCall());

        int rSrc2;
        if (!isReg){
            rSrc2 = newVReg();
            addInstruction(new RegBinInstruction("li",rSrc2,Src2,false));
        }
        else rSrc2 = Src2;

        getBlock().add(new AddBinInstruction("sw", rSrc2, v_0)); //save length

        addInstruction(new ArithmeticInstruction("sll",a_0,rSrc2,2,false));
        addInstruction(new RegBinInstruction("li",v_0,9,false));
        addInstruction(new SystemCall()); // allocate

        rDest = newVReg();
        addInstruction(new RegBinInstruction("move",rDest,v_0,true));
    }
    public String toString(){
        return "NEW:" + properties;
    }
}
