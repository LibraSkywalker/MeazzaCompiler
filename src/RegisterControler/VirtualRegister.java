package RegisterControler;

/**
 * Created by Bill on 2016/4/26.
 */
public class VirtualRegister {
    static int VReg = 1;
    public static int newVReg(){
        return VReg++;
    }
}
