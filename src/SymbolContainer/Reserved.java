package SymbolContainer;

/**
 * Created by Bill on 2016/4/9.
 */
public class Reserved extends Symbol {
    @Override
    public Symbol setPrimitive() {
        primitive = true;
        return this;
    }
}
