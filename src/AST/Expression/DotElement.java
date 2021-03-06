package AST.Expression;

import MIPS.Instruction.AddBinInstruction;
import MIPS.Instruction.JumpInstruction;
import MIPS.Instruction.RegBinInstruction;
import SymbolContainer.FuncSymbol;

import static AST.ASTControler.*;
import static MIPS.IRControler.addInstruction;
import static MIPS.IRControler.getBlock;
import static RegisterControler.RegisterName.*;
import static RegisterControler.VirtualRegister.newVReg;

/**
 * Created by Bill on 2016/4/6.
 */
public class DotElement extends BinaryExpression{
    boolean lvalue;
    public DotElement(){
        lvalue = false;
    }

    @Override
    public void set() {
        lvalue = ((SymbolElement) rightAction).lvalue;
        properties.setProperties(rightAction.properties);
    }

    public boolean setEnvironment(){
        if (leftAction.properties.getDimension() == 0){
            visitScope(leftAction.getProperties().type().classMembers);
        }
        return true;
    }

    public void clearEnvironment(){
        endScope();
    }

    @Override
    public boolean setLeft(ExpressionAction nowAction){
        leftAction = nowAction;
        if (nowAction == null) return false;
        nowAction.parentAction = this;
        setEnvironment();
        return true;
    }

    public boolean check(){
        //System.err.println(leftAction + " " + leftAction.getProperties().type().classMembers);
        if (!getCurrentScope().equals(leftAction.getProperties().type().classMembers) &&
                leftAction.properties.getDimension() == 0)
            visitScope(leftAction.getProperties().type().classMembers);
        if (leftAction == null ||
            rightAction == null ||
           !(rightAction instanceof SymbolElement))
            return false;
        if (leftAction.properties.getDimension() > 0){
            if (!((SymbolElement) rightAction).element.equals(getFunc("size"))) {
                System.err.println("Cannot access the suffix of a pointer");
                return false;
            }
        }
        else {
            clearEnvironment();
            if (((SymbolElement) rightAction).element.equals(getFunc("size"))) {
                System.err.println("size cannot be done on non array expression");
                return false;
            }
        }
        set();
        return true;
    }

    public void Translate(){
        leftAction.Translate(); //delta
        if (((SymbolElement) rightAction).element instanceof FuncSymbol){
            String FuncName = ((SymbolElement) rightAction).element.name();
            if (FuncName.equals("size")){
                addInstruction(new RegBinInstruction("move",v_0,leftAction.rDest,true));
                addInstruction(new JumpInstruction("jal","func__array.size"));
            }
            if (leftAction.accept("string")){
                rightAction.Translate();
                if (leftAction.isLiteral())
                    addInstruction(new AddBinInstruction("la",v_0,((Literal)leftAction).memName()));
                else
                    addInstruction(new RegBinInstruction("move",v_0,leftAction.rDest,true));
                addInstruction(new JumpInstruction("jal","func__string." + FuncName));
            }
            rDest = newVReg();
            addInstruction(new RegBinInstruction("move",rDest,v_0,true));
            //System.err.println("Inside function doen't support now");
        }
        else {
            rDest = newVReg();
            int Src = leftAction.getProperties().type().indexOfMember(((SymbolElement) rightAction).element);
            getBlock().add(new AddBinInstruction("lw", rDest, leftAction.rDest, Src * 4));
            getBlock().add(new AddBinInstruction("la", globalAddress , leftAction.rDest, Src * 4)); //lvalue
        }
    }
}
