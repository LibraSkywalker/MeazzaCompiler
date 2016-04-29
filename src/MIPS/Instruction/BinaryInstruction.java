package MIPS.Instruction;

/**
 * Created by Bill on 2016/4/26.
 */
public class BinaryInstruction extends Instruciton{
    Integer rDest,vDest,rSrc,vSrc,address;
    BinaryInstruction(){}

    public BinaryInstruction(String OP,int dest,int src,boolean isRegister){
        operator = OP;
        vDest = dest;
        isReg = isRegister;
        vSrc = 0;
        if (isReg) vSrc = src;
        else address = src;
    }

    public String toString(){
        return operator + " " + "$" + rDest + " " + ( isReg ? "$" + rSrc : address) +"\n";
    }

    public String virtualPrint(){
        return operator + " " + "$" + vDest + " " + ( isReg ? "$" + vSrc : address) +"\n";
    }
}
