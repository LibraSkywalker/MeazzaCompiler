package AST.Statment;

import AST.ActionNodeBase;
import AST.Expression.ExpressionAction;
import MIPS.BasicBlock;
import MIPS.Instruction.JumpInstruction;
import MIPS.Instruction.RegBinInstruction;
import SymbolContainer.Scope;

import static AST.ASTControler.getCurrentScope;
import static AST.ASTControler.getFunc;
import static AST.ASTControler.getVar;
import static MIPS.IRControler.addInstruction;
import static MIPS.IRControler.getFunction;
import static RegisterControler.RegisterName.*;

/**
 * Created by Bill on 2016/4/4.
 */
public class JumpStatment extends ActionNodeBase{
    ExpressionAction returnValue;
    String operator;

    public void setReturnValue(ExpressionAction now){
        returnValue = now;
        operator = "return";
    }

    public boolean isReturn(){
        return (returnValue != null);
    }

    public void set(String now){
        operator = now;
        if (now.equals("return")){
            getCurrentScope().findBranch().putReservedKey("+");
        }
    }
    public Scope excecute(){
        if (returnValue != null) return getCurrentScope().returnTo();
        if (operator.equals("break")) return getCurrentScope().breakTo();
        else return getCurrentScope().nextLoop();
    }

    public boolean accepted() {
        if (!operator.equals("return")) {
            if (excecute() == null) {
                System.err.println("Jump statment '" + operator + "' should be in Loop");
                return false;
            }
            return true;
        } else
        if (getVar("@return","") == null) {
            if (returnValue != null) {
                System.err.println("A void function Should not have return value");
                return false;
            }
            return true;
        } else {
            if (returnValue == null) {
                System.err.println("There should be a return value for this function");
                return false;
            }
            if (!getVar("@return").accept(returnValue)){
                System.err.println("Required " + getVar("@return").getProperties() + " instead of "+ returnValue);
                return false;
            }
            return true;
        }
    }

    public void Translate(){
        if (operator.equals("return")){
            if (returnValue != null){
                returnValue.Translate();
                if (returnValue.isLiteral())
                    addInstruction(new RegBinInstruction("li" , v_0, returnValue.src(), false));
                else{
                    if (returnValue.src() != v_0)
                        addInstruction(new RegBinInstruction("move", v_0, returnValue.src(), true));
                }
            }
            if (r_a != 31)
                addInstruction(new RegBinInstruction("move",31,r_a,true));
            //int fsize = getCurrentScope().returnTo().memberSize() * 4 + 12;
            //addInstruction(new ArithmeticInstruction("add",s_p,s_p,fsize,false));
            addInstruction(new JumpInstruction());
        }

        if (operator.equals("continue")){
            addInstruction(new JumpInstruction("b",getFunction().nextLoop()));
        }

        if (operator.equals("break")){
            addInstruction(new JumpInstruction("b",getFunction().breakTo()));
        }
    }

    public ExpressionAction returnValue(){
        return returnValue;
    }
}
