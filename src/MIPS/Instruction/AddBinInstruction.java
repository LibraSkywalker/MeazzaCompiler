package MIPS.Instruction;

import MIPS.Function;
import RegisterControler.VirtualReadWrite;

import static MIPS.IRControler.state;

/**
 * Created by Bill on 2016/4/30.
 */
public class AddBinInstruction extends BinaryInstruction {
    Integer vSrc,rSrc,immediate = 0;
    String address = "";
    public AddBinInstruction(String OP, int dest, int _address){
        operator = OP;
        vDest = dest;
        vSrc = _address;
    }

    public AddBinInstruction(String OP, int dest, int _address, int imm){
        operator = OP;
        vDest = dest;
        vSrc = _address;
        immediate = imm;
    }

    public AddBinInstruction(String OP, int dest, String _address){
        operator = OP;
        vDest = dest;
        address = _address;
    }
    public String toString(){
        if (address.equals(""))
            return operator + " " + "$" + rDest + " " + immediate + "($" + rSrc +")\n";
        return operator + " " + "$" + rDest + " " + address + "\n";
    }

    public String virtualPrint(){
        if (address.equals(""))
            return operator + " " + "$" + vDest + " " + immediate + "($" + vSrc +")\n";
        return operator + " " + "$" + vDest + " " + address + "\n";
    }

    public void update(VirtualReadWrite usage){
        if (vSrc != null)
            usage.addReader(vSrc);
        if (operator.equals("sw")){
            usage.addReader(vDest);
        }
        else usage.addWriter(vDest);
    }

    @Override
    public void globalize(Function Func) {
        if (vSrc != null)
            Func.state.update(vSrc);
        if (operator.equals("sw")){
            Func.state.update(vSrc);
        }
        else
            Func.state.set(vSrc);
    }
}
