package AST.Expression;

import MIPS.Instruction.*;
import SymbolContainer.FuncSymbol;
import SymbolContainer.Properties;
import SymbolContainer.VariableSymbol;

import java.util.ArrayList;

import static AST.ASTControler.getCurrentScope;
import static AST.ASTControler.getGlobeScope;
import static MIPS.IRControler.addInstruction;
import static MIPS.IRControler.getBlock;
import static RegisterControler.RegisterName.*;

/**
 * Created by Bill on 2016/4/10.
 */
public class SymbolElement extends ExpressionAction{
    VariableSymbol element;
    ArrayList<ExpressionAction> actionList = new ArrayList<>();
    boolean lvalue;
    String label;
    public SymbolElement(){
        lvalue = false;
        element = null;
    }

    public SymbolElement(VariableSymbol nowElement){
        element = nowElement;
        if (element == null) return;;
        properties = new Properties();
        properties.setProperties(nowElement.getProperties());
        lvalue = !(nowElement instanceof FuncSymbol);
    }

    public void setElement(VariableSymbol nowElement){
        element = nowElement;
        if (element == null) return;;
        properties.setProperties(nowElement.getProperties());
        lvalue = !(nowElement instanceof FuncSymbol);
    }

    public void set(){}

    public boolean check(){return element != null;}

    public boolean checkParameter(ExpressionAction now,Integer i){
        if (element instanceof FuncSymbol){
            VariableSymbol nowParameter = ((FuncSymbol) element).findParameter(i);
            if (!nowParameter.accept(now)){
                //System.err.println(nowParameter.toString() + " " + now.toString());
                System.err.println("Parameter "+ i.toString() + " type mismatch");
                return false;
            }
            actionList.add(now);
            return true;
        }
        else return false;
    }

    public boolean checkParameter(int maxIndex){
        if (maxIndex < ((FuncSymbol) element).parameterSize()){
            System.err.println("too few parameters exist");
            return false;
        }
        if (maxIndex > ((FuncSymbol) element).parameterSize()){
            System.err.println("too many parameters exist");
            return false;
        }
        return true;
    }

    public String toString(){
        return "Symbol: " + element.toString();
    }

    public void Translate(){
        if (element instanceof FuncSymbol) {
            callTranslate();
            return;
        }

        rDest = element.getVirtualRegister();
        if (element.getScope().equals(getGlobeScope()) && getGlobeScope().dict3.size() > 7)
            addInstruction(new AddBinInstruction("lw",rDest ,globalVariable, 4 * getGlobeScope().indexOfMember(element)));
    }

    void callTranslate(){
        int paraSize = ((FuncSymbol) element).parameterSize();

        for (int i = 0; i < 5; i++){
            int rDest = getCurrentScope().returnTo().update(i);
            if (rDest > 0)
                addInstruction(new RegBinInstruction("move",rDest,a_0 + i,true));
        }

        if (paraSize > 5){
            addInstruction(new RegBinInstruction("li",a_0,paraSize * 4,false));
            addInstruction(new RegBinInstruction("li",v_0,9,false));
            addInstruction(new SystemCall()); // allocate an array for parameters
            addInstruction(new RegBinInstruction("move",a_0,v_0,true));
        }

        for (int i = 0; i < paraSize; i++){
            ExpressionAction now = actionList.get(i);
            now.Translate();
            if (paraSize > 5){
                int rSrc = now.isLiteral() ? ((Literal) now).Reg() : now.src() ;
                addInstruction(new AddBinInstruction("sw",rSrc,a_0,i * 4));
            }
            else {
                // can check
                if (now.isLiteral())
                    if (now.properties.accept("string")) {
                        addInstruction(new AddBinInstruction("la", a_0 + i, ((Literal) now).memName()));
                    } else {
                        addInstruction(new RegBinInstruction("li", a_0 + i, now.src(), false));
                    }
                else
                    addInstruction(new RegBinInstruction("move",a_0 + i,now.src(),true));
            }

        } // solving parameters

        getCurrentScope().print();
        if (getGlobeScope().getVar(element.name()) == null)
            return;
        //System.out.println(getCurrentScope().returnTo().print() +": " + getCurrentScope().returnTo().memberSize());
        addInstruction(new JumpInstruction("jal", "func__" + element.name())); //// jump in
        rDest = v_0;
    }
    void update(){
        if (element.getScope().equals(getGlobeScope()) && getGlobeScope().dict3.size() > 7){
            element.update();
            getBlock().add(new AddBinInstruction("la",globalAddress, globalVariable, 4 * getGlobeScope().indexOfMember(element)));
        }
        else {
            if (!element.getScope().equals(getCurrentScope())) return;
            element.update();
            rDest = element.getVirtualRegister();
        }
    }
}
