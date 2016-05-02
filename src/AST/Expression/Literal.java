package AST.Expression;

import MIPS.Instruction.AddBinInstruction;
import MIPS.Instruction.RegBinInstruction;
import MIPS.Instruction.RegTerInstruction;

import static MIPS.IRControler.addData;
import static MIPS.IRControler.getBlock;
import static MIPS.IRControler.getDataBlock;
import static RegisterControler.ReservedRegister.globalAllocator;
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
        if (now.charAt(0) == '\"'){
            _value = now.substring(1,now.length() - 1);
        }
    }
    public String toString(){
        return "CONST: " + properties.toString() + " " + _value;
    }
    public int length(){
        return _value.length();
    }

    int value(){
        if (properties.accept("string"))
            return 0;
        switch (_value){
            case "true" : return 1;
            case "false": return 0;
            case "null" : return 0;
            default: return Integer.parseInt(_value);
        }
    }

    String memName(){
        return _value;
    }
    public void Translate(){
        if (properties.accept("string")) {
            addData(_value.length());
            _value = addData(_value);
        }
    }

    public int Reg(){
        rDest = newVReg();
        getBlock().add(new RegBinInstruction("li",rDest,value(),false));
        return rDest;
    }
}
