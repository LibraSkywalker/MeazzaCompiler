package AST.Expression;

import MIPS.Instruction.BinaryInstruction;

import static MIPS.IRcontroler.getBlock;
import static RegisterControler.VirtualRegister.newVReg;

/**
 * Created by Bill on 2016/4/6.
 */
public class Literal extends ExpressionAction{
    String _value;
    public void set(){}
    public boolean check(){return true;}
    public void getValue(String now){
        _value = now;
    }
    public String toString(){
        return "CONST: " + properties.toString() + " " + _value;
    }
    public int length(){
        return _value.length();
    }

    int value(){
        switch (_value){
            case "true" : return 1;
            case "false": return 0;
            case "null" : return 0;
            default: return Integer.parseInt(_value);
        }
    }

    public void Translate(){}

    public int Reg(){
        rDest = newVReg();
        getBlock().add(new BinaryInstruction("li",rDest,value(),false));
        return rDest;
    }
}
