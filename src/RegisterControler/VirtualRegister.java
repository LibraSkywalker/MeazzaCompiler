package RegisterControler;

import static MIPS.TextControler.GlobalState;

/**
 * Created by Bill on 2016/4/26.
 */
public class VirtualRegister {
    static int VReg = 32;
    static int[][] tempRegister = {{0,0},{24,0},{25,0},{7,0},{8,0},{5,0},{6,0},{4,0}};
    static int [] map = new int[500000];
    public static int newVReg(){
        return VReg++;
    }
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
}
