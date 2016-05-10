package SymbolContainer;

import AST.ActionNodeBase;
import MIPS.BasicBlock;

import java.util.*;

import static AST.ASTControler.getCurrentScope;
import static AST.ASTControler.visitScope;
import static RegisterControler.RegisterName.a_0;


/**
 * Created by Bill on 2016/4/5.
 */
public class Scope extends ActionNodeBase{
    Scope prevScope,lastScope;
    int type;
    Dictionary<String, Symbol> dict;
    public ArrayList<VariableSymbol> dict2;
    public ArrayList<FuncSymbol> dict3;
    ArrayList<ActionNodeBase> actionList;
    int nowActionIndex;
    int NORMAL = 0, FUNC = 1, LOOP = 2, BRANCH = 3;


    public String print(){
        if (prevScope == null)
            return this.toString() + " ";
        return prevScope.print() + this.toString() + " ";
    }

    public Scope getLastScope() {
        return lastScope;
    }

    public Scope(){
        nowActionIndex = 0;
        prevScope = lastScope = null;
        dict = new Hashtable<>();
        dict2 = new ArrayList<>();
        dict3 = new ArrayList<>();
        actionList = new ArrayList<>();
        type = NORMAL;
    }

    public void Translate(){
        visitScope(this);
        //System.out.println("!" + type + ": " + actionList.size());
        for(ActionNodeBase now : actionList){
            now.Translate();
        }
        endScope();
    }

    public boolean isParameter(VariableSymbol now){
        if (dict2.indexOf(now) >= dict2.indexOf(getVar("_arg_before_it","NoOutPut"))) return false;
        if (dict2.indexOf(now) != 0 && dict2.indexOf(getVar("_arg_before_it","NoOutPut")) > 5) return false;
        return true;
    }

    public int update(int now){
        if (getVar("_arg_before_it","NoOutPut") == null) return 0;
        if (dict2.indexOf(getVar("_arg_before_it","NoOutPut")) <= now) return 0;
        if (dict2.indexOf(getVar("_arg_before_it","NoOutPut")) > 5){
            if (now == 0) return getVar("_arg_before_it","NoOutPut").update();
            else return 0;
        }
        if (dict2.get(now).getVirtualRegister() != a_0 + now) return 0;
        return dict2.get(now).update();
    }

    public boolean contains(FuncSymbol now){
        return (dict.get(now.name) != null) && dict.get(now.name) instanceof FuncSymbol;
    }

    public boolean contains(TypeSymbol now){
        return (dict.get(now.name) != null) && dict.get(now.name) instanceof TypeSymbol;
    }

    public boolean contains(VariableSymbol now){
        return (dict.get(now.name) != null) && dict.get(now.name) instanceof VariableSymbol;
    }

    public boolean contains(String now){
        return dict.get(now) != null;
    }

    public Symbol get(String now){
        if (now.equals("rt0")){
            now = now;
        }
        Scope nowScope = this;
        while (nowScope != null && nowScope.dict.get(now) == null) {
            nowScope = nowScope.prevScope;
        }

        return (nowScope == null) ? null : nowScope.dict.get(now);
    }

    public TypeSymbol getType(String now){
        Symbol ret = get(now);
        if (ret != null && ret instanceof TypeSymbol) return (TypeSymbol) ret;
        System.err.println("Undefined Type: " + now + " exists");
        return null;
    }

    public VariableSymbol getVar(String now){
        Symbol ret = get(now);
        if (ret != null && ret instanceof VariableSymbol) return (VariableSymbol)ret;
        System.err.println("Undefined Variable: " + now + " exists");
        return null;
    }

    public VariableSymbol getVar(String now,Object x){
        Symbol ret = get(now);
        if (ret != null && ret instanceof VariableSymbol) return (VariableSymbol)ret;
        return null;
    }

    public  FuncSymbol getFunc(String now){
        Symbol ret = get(now);
        if (ret != null && ret instanceof FuncSymbol) return (FuncSymbol)ret;
        System.err.println("Undefined Function: " + now + " exists");
        return null;
    }

    public boolean getReserved(String now){
        return dict.get(now) != null;
    }

    public Scope beginScope(){
        Scope now = new Scope();
        now.prevScope = now.lastScope = this;
        return now;
    }

    public Scope gotoScope(){
        nowActionIndex = 0;
        lastScope = getCurrentScope();
        return this;
    }

    public Scope endScope(){
        return lastScope;
    }

    public void setFunc(){
        type = FUNC;
    }

    public void setLoop(){
        type = LOOP;
    }

    public void setBranch(){
        type = BRANCH;
    }

    public void setLastScope(Scope lastScope) {
        this.lastScope = lastScope;
    }

    public Scope returnTo(){
        this.print();
        Scope nowScope = this;
        while ( nowScope != null && nowScope.type != FUNC)
            nowScope = nowScope.prevScope;
        if (nowScope == null) return null;
        else return nowScope;
    }

    public Scope breakTo(){
        Scope nowScope = this;
        while ( nowScope != null &&
                nowScope.type != LOOP &&
                nowScope.type != FUNC){
            nowScope = nowScope.prevScope;
        }
        if (nowScope != null && nowScope.type == LOOP)
            return nowScope.prevScope;
        else return null;
    }

    public Scope findBranch(){
        Scope nowScope = this;
        while (nowScope != null &&
              (nowScope.type != BRANCH &&
               nowScope.type != FUNC)){
            nowScope = nowScope.prevScope;
        }
        return nowScope;
    }

    public Scope nextLoop(){
        Scope nowScope = this;
        while ( nowScope != null &&
                nowScope.type != LOOP &&
                nowScope.type != FUNC){
            nowScope = nowScope.prevScope;
        }
        if (nowScope != null && nowScope.type == LOOP)
            return nowScope;
        else return null;
    }


    public boolean put(String now,Symbol nowSymbol){
        if (now.equals("rt0")){
            now = now;
        }
        Symbol prevSymbol = get(now);
        if (prevSymbol == null || !prevSymbol.primitive && dict.get(now) == null){
            dict.put(now,nowSymbol);
            nowSymbol.name = now;
            nowSymbol.scope = this;
            return true;
        }
        return false;
    }

    public VariableSymbol putVar(String now){
        VariableSymbol nowSymbol = new VariableSymbol();
        if (!put(now,nowSymbol)){
            System.err.println("Variable: " + now + " definition failed");
            return null;
        }
        Scope control = returnTo();
        if (control == null) control = this;
        control.dict2.add(nowSymbol);
        return getVar(now);
    }

    public FuncSymbol putFunc(String now){
        FuncSymbol nowSymbol = new FuncSymbol();
        if (!put(now,nowSymbol)){
            System.err.println("Function: " + now + " definition failed");
            return null;
        }
        dict3.add(nowSymbol);
        return getFunc(now);
    }

    public TypeSymbol putType(String now){
        TypeSymbol nowSymbol = new TypeSymbol(false);
        if (!put(now,nowSymbol)){
            System.err.println("Class: " + now + "definition failed");
            return null;
        }
        return getType(now);
    }

    public TypeSymbol putType(String now,Object x){
        TypeSymbol nowSymbol = new TypeSymbol(true);
        if (!put(now,nowSymbol)){
            System.err.println("Class: " + now + "definition failed");
            return null;
        }
        return getType(now);
    }

    public void putReservedKey(String now){
        Symbol nowSymbol = new Reserved() ;
        put(now,nowSymbol);
        nowSymbol.setPrimitive();
    }

    public void addAction(ActionNodeBase now){
        actionList.add(now);
    }

    public ActionNodeBase popAction(){
        if (nowActionIndex >= actionList.size())
            return null;
        return actionList.get(nowActionIndex++) ;
    }

    public int getType(){
        return type;
    }
    public int size(){
        return actionList.size();
    }
    public int memberSize(){
        return dict2.size();
    }
    public int indexOfMember(Symbol now){
        return dict2.indexOf(now);
    }
}
