package MIPS.Instruction;

/**
 * Created by Bill on 2016/4/30.
 */
public class AddBinInstruction extends BinaryInstruction {
    int vSrc,rSrc,immediate = 0;
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
}
