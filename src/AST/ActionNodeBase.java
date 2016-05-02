package AST;

/**
 * Created by Bill on 2016/4/4.
 */
public abstract class ActionNodeBase {
    public ActionNodeBase parentAction = null;
    public void execute(){}
    public ActionNodeBase(){
    }
    public abstract void Translate();
}
