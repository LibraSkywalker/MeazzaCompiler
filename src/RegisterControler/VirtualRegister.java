package RegisterControler;

import MIPS.BasicBlock;
import MIPS.Function;
import MIPS.Instruction.AddBinInstruction;
import MIPS.Instruction.Instruction;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.Queue;

import static MIPS.IRControler.getBlock;
import static MIPS.IRControler.getFunction;
import static MIPS.TextControler.GlobalState;
import static RegisterControler.RegisterName.*;

/**
 * Created by Bill on 2016/4/26.
 */
public class VirtualRegister {
    static int VReg = 32;

    static class RegisterState{
        int times;
        int name;
        RegisterState(){}
        RegisterState(int _name){
            name = _name;
        }
        public RegisterState(int _times,int _name){
            times = _times;
            name = _name;
        }
        void rename(){
            name = newVReg();
        }
        boolean clean(){
            return times == 0;
        }
        void set(int _times){
            times = _times;
        }
        void use(){
            times--;
        }
        public String toString(){
            return "<" + name + "," + times + ">";
        }
    }
    static LinkedList<RegisterState> newRegister = new LinkedList<>(),
                                    usedRegister = new LinkedList<>(),
                                    InMemory = new LinkedList<>();
    static RegisterState [] map = new RegisterState[500000];


    public static void BuildAllocater(Function nowFunc){
        VReg = 0;
        InMemory.clear();
        usedRegister.clear();
        newRegister.clear();
        for (int i = 0 ; i < 50000; i++) map[i] = null;
        newRegister.add(new RegisterState(24));
        newRegister.add(new RegisterState(25));

        for (int i = nowFunc.localState.Dic[localSaved].size();i < 7;i++)
            newRegister.add(new RegisterState(9 + i)); //t1 + i unused localSaved

        newRegister.add(new RegisterState(7));
        newRegister.add(new RegisterState(6));
        newRegister.add(new RegisterState(4));
        newRegister.add(new RegisterState(5));

        for (int i = GlobalState.Dic[global].size();i < 7;i++)
            newRegister.add(new RegisterState(16 + i)); //s0 + i  unused global
    }
    public static int newVReg(){
        return VReg++;
    }

    static RegisterState ForceOrder(Instruction last){
        if (!newRegister.isEmpty()){
            RegisterState now = newRegister.pop();
            usedRegister.add(now);
            return now;
        }
        else {
            RegisterState pre = usedRegister.pop();
            InMemory.add(pre);
            RegisterState now = new RegisterState(pre.name);
            pre.rename();

            Instruction past = new AddBinInstruction("la",8,"VReg"); // t_0
            past.configure();
            getBlock().BlockStat.add(getBlock().BlockStat.indexOf(last),past);

            past = new AddBinInstruction("sw",now.name,8,pre.name * 4);
            past.configure();
            getBlock().BlockStat.add(getBlock().BlockStat.indexOf(last),past);

            usedRegister.add(now);
            return now;
        }
    }

    public static Integer order(Instruction last,int virtualRegister){
        if (map[virtualRegister] == null){
            map[virtualRegister] = ForceOrder(last);
            map[virtualRegister].set(getFunction().localState.times(virtualRegister));
            System.err.println(virtualRegister);
            System.err.println(GlobalState.times(virtualRegister));
            map[virtualRegister].use();
        }else {
            if (InMemory.contains(map[virtualRegister])){
                RegisterState pre = map[virtualRegister];
                RegisterState now = ForceOrder(last);

                Instruction past = new AddBinInstruction("la",now.name,"VReg");
                past.configure();
                getBlock().BlockStat.add(getBlock().BlockStat.indexOf(last),past);

                past = new AddBinInstruction("lw",now.name,now.name,pre.name * 4);
                past.configure();
                getBlock().BlockStat.add(getBlock().BlockStat.indexOf(last),past);

                now.set(map[virtualRegister].times);
                now.use();
                map[virtualRegister] = now;
            }
            else map[virtualRegister].use();
        }
        RegisterState now = map[virtualRegister];
        if (now.clean()){
            map[virtualRegister] = null;
            newRegister.add(now);
            usedRegister.remove(now);
            InMemory.remove(now);
        }


        if (virtualRegister == 33){
            System.err.println(last.virtualPrint());
            System.err.println(virtualRegister);
            System.err.println(newRegister);
            System.err.println(usedRegister);
            System.err.println(now);
            System.err.println(now.clean());
        }

        return now.name;
    }




    /*
    static int[][] tempRegister = {{0,0},{24,0},{25,0},{7,0},{8,0},{5,0},{6,0},{4,0}};

    public static Integer order(int virtualRegister){
        int now = map[virtualRegister];
        if (now != 0){
            tempRegister[now][1]--;
            if (tempRegister[now][1] == 0) map[virtualRegister] = 0;
            return tempRegister[now][0];
        }
        else {
            for (int i = 1; i < 8; i++)
                if (tempRegister[i][1] == 0){
                    map[virtualRegister] = i;
                    tempRegister[i][1] = GlobalState.times(virtualRegister) - 1;
                    return tempRegister[i][0];
                }
            return -1;
        }
    }
    */
}
