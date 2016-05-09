package MIPS.Instruction;

import MIPS.Function;
import RegisterControler.VirtualReadWrite;

import java.util.LinkedList;

import static MIPS.IRControler.getBlock;
import static MIPS.IRControler.getFunction;
import static RegisterControler.RegisterName.*;

/**
 * Created by Bill on 2016/4/30.
 */
public class AddBinInstruction extends BinaryInstruction {
    Integer vSrc,immediate = 0;
    String address = "",rSrc;
    public AddBinInstruction(String OP, int dest, int _address){
        operator = OP;
        vDest = dest;
        vSrc = _address;
    }

    public void configure(){
        rSrc = Translate(vSrc);
        rDest = Translate(vDest);
        if (rDest.equals("")) { //delete
            getBlock().BlockStat.remove(this);
            return;
        }
        if (rSrc.equals("Memory")){
            int pos = getFunction().localState.Dic[SaveInAddress].indexOf(vSrc) * 4;
            Instruction now = new AddBinInstruction("lw",Rsrc1,s_p,pos);
            getBlock().BlockStat.add(getBlock().BlockStat.indexOf(this),now);
            now.configure();
            rSrc = Rsrc1.toString();
        }

        if (rDest.equals("Memory")){
            int pos = getFunction().localState.Dic[SaveInAddress].indexOf(vDest) * 4;
            if (operator.equals("sw")){
                Instruction now = new AddBinInstruction("lw",Rsrc2,s_p,pos);
                getBlock().BlockStat.add(getBlock().BlockStat.indexOf(this),now);
                now.configure();
                rDest = Rsrc2.toString();
            } else {
                Instruction now = new AddBinInstruction("sw",Rdest,s_p,pos);
                getBlock().BlockStat.add(getBlock().BlockStat.indexOf(this) + 1,now);
                rDest = Rdest.toString();
            }
        }
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
            Func.localState.update(vSrc);
        if (operator.equals("sw")){
            Func.localState.update(vDest);
        }
        else
            Func.localState.set(vDest);
    }
}
