package SymbolContainer;

import AST.ActionNodeBase;

import java.util.*;

import static AST.ASTControler.getCurrentScope;


/**
 * Created by Bill on 2016/4/5.
 */
public class Scope{
    Scope prevScope,lastScope;
    int type;
    Dictionary<String, Symbol> dict;
    ArrayList<ActionNodeBase> actionList;
    int nowActionIndex;
    int NORMAL = 0, FUNC = 1, LOOP = 2, BRANCH = 3;


    public Scope(){
        nowActionIndex = 0;
        prevScope = null;
        dict = new Hashtable<>();
        actionList = new ArrayList<>();
        type = NORMAL;
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
        Scope nowScope = this;
        while (nowScope != null && dict.get(now) == null)
            nowScope = nowScope.prevScope;
        if (nowScope == null) return null;
        return dict.get(now);
    }

    public TypeSymbol getType(String now){
        Symbol ret = get(now);
        if (ret != null && ret instanceof TypeSymbol) return (TypeSymbol) ret;
        return null;
    }

    public VariableSymbol getVar(String now){
        Symbol ret = get(now);
        if (ret != null && ret instanceof VariableSymbol) return (VariableSymbol)ret;
        return null;
    }

    public  FuncSymbol getFunc(String now){
        Symbol ret = get(now);
        if (ret != null && ret instanceof FuncSymbol) return (FuncSymbol)ret;
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

    public Scope visitScope(){
        nowActionIndex = 0;
        lastScope = getCurrentScope();
        return this;
    }

    public Scope endScope(){
        return lastScope;
    }

    public Symbol put(String now,Symbol nowSymbol){
        Symbol prevSymbol = get(now);
        if (prevSymbol == null || !prevSymbol.primitive && dict.get(now) == null){
            dict.put(now,nowSymbol);
            nowSymbol.name = now;
            return nowSymbol;
        }
        return null;
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

    public Scope returnTo(){
        Scope nowScope = this;
        while ( nowScope != null && nowScope.type != FUNC)
            nowScope = nowScope.prevScope;
        if (nowScope == null) return null;
        else return nowScope.lastScope;
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

    public VariableSymbol putVar(String now){
        VariableSymbol nowSymbol = new VariableSymbol();
        return (VariableSymbol) put(now,nowSymbol);
    }

    public FuncSymbol putFunc(String now){
        FuncSymbol nowSymbol =new FuncSymbol();
        return (FuncSymbol) put(now,nowSymbol);
    }


    public TypeSymbol putType(String now){
        TypeSymbol nowSymbol = new TypeSymbol(false);
        return (TypeSymbol) put(now,nowSymbol);
    }

    public TypeSymbol putType(String now,Object x){
        TypeSymbol nowSymbol = new TypeSymbol(true);
        return (TypeSymbol) put(now,nowSymbol);
    }

    public Reserved putReservedKey(String now){
        Symbol nowSymbol = new Reserved() ;
        return (Reserved) put(now,nowSymbol);
    }

    public void addAction(ActionNodeBase now){
        actionList.add(now);
    }

    public ActionNodeBase popAction(){
        if (nowActionIndex > actionList.size())
            return null;
        return actionList.get(nowActionIndex++) ;
    }

    public int getType(){
        return type;
    }
    public int size(){
        return actionList.size();
    }
}
