package antlr;
// Generated from D:/OneDrive/Ideaprojects/compiler2016\Meazza.g4 by ANTLR 4.5.1
import org.antlr.v4.runtime.Lexer;
import org.antlr.v4.runtime.CharStream;
import org.antlr.v4.runtime.Token;
import org.antlr.v4.runtime.TokenStream;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.misc.*;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast"})
public class MeazzaLexer extends Lexer {
	static { RuntimeMetaData.checkVersion("4.5.1", RuntimeMetaData.VERSION); }

	protected static final DFA[] _decisionToDFA;
	protected static final PredictionContextCache _sharedContextCache =
		new PredictionContextCache();
	public static final int
		T__0=1, T__1=2, T__2=3, T__3=4, T__4=5, T__5=6, T__6=7, T__7=8, T__8=9, 
		T__9=10, T__10=11, T__11=12, T__12=13, T__13=14, T__14=15, T__15=16, T__16=17, 
		T__17=18, T__18=19, T__19=20, T__20=21, T__21=22, T__22=23, T__23=24, 
		T__24=25, T__25=26, T__26=27, T__27=28, T__28=29, T__29=30, T__30=31, 
		T__31=32, T__32=33, T__33=34, T__34=35, T__35=36, T__36=37, T__37=38, 
		T__38=39, CONST=40, UNSIGNED=41, CLASS=42, INT_POST=43, ID=44, INT_DATA=45, 
		LBRACE=46, RBRACE=47, LBLOCK=48, RBLOCK=49, FLOAT_DATA=50, CHAR_DATA=51, 
		STRING_DATA=52, Translate=53, LINE_COMMENT=54, BLOCK_COMMENT=55, WS=56;
	public static String[] modeNames = {
		"DEFAULT_MODE"
	};

	public static final String[] ruleNames = {
		"T__0", "T__1", "T__2", "T__3", "T__4", "T__5", "T__6", "T__7", "T__8", 
		"T__9", "T__10", "T__11", "T__12", "T__13", "T__14", "T__15", "T__16", 
		"T__17", "T__18", "T__19", "T__20", "T__21", "T__22", "T__23", "T__24", 
		"T__25", "T__26", "T__27", "T__28", "T__29", "T__30", "T__31", "T__32", 
		"T__33", "T__34", "T__35", "T__36", "T__37", "T__38", "CONST", "UNSIGNED", 
		"CLASS", "INT_POST", "ID", "INT_DATA", "LBRACE", "RBRACE", "LBLOCK", "RBLOCK", 
		"FLOAT_DATA", "CHAR_DATA", "STRING_DATA", "Translate", "CCHAR", "SCHAR", 
		"LINE_COMMENT", "BLOCK_COMMENT", "ID_head", "ID_tail", "WS"
	};

	private static final String[] _LITERAL_NAMES = {
		null, "'='", "';'", "'null'", "'true'", "'false'", "','", "'{'", "'}'", 
		"'if'", "'else'", "'for'", "'while'", "'break'", "'continue'", "'return'", 
		"'new'", "'.'", "'-'", "'~'", "'!'", "'++'", "'--'", "'*'", "'/'", "'%'", 
		"'+'", "'<<'", "'>>'", "'>'", "'<'", "'>='", "'<='", "'=='", "'!='", "'&'", 
		"'^'", "'|'", "'&&'", "'||'", "'const'", "'unsigned'", "'class'", null, 
		null, null, "'('", "')'", "'['", "']'"
	};
	private static final String[] _SYMBOLIC_NAMES = {
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, null, null, "CONST", "UNSIGNED", "CLASS", "INT_POST", "ID", 
		"INT_DATA", "LBRACE", "RBRACE", "LBLOCK", "RBLOCK", "FLOAT_DATA", "CHAR_DATA", 
		"STRING_DATA", "Translate", "LINE_COMMENT", "BLOCK_COMMENT", "WS"
	};
	public static final Vocabulary VOCABULARY = new VocabularyImpl(_LITERAL_NAMES, _SYMBOLIC_NAMES);

	/**
	 * @deprecated Use {@link #VOCABULARY} instead.
	 */
	@Deprecated
	public static final String[] tokenNames;
	static {
		tokenNames = new String[_SYMBOLIC_NAMES.length];
		for (int i = 0; i < tokenNames.length; i++) {
			tokenNames[i] = VOCABULARY.getLiteralName(i);
			if (tokenNames[i] == null) {
				tokenNames[i] = VOCABULARY.getSymbolicName(i);
			}

			if (tokenNames[i] == null) {
				tokenNames[i] = "<INVALID>";
			}
		}
	}

	@Override
	@Deprecated
	public String[] getTokenNames() {
		return tokenNames;
	}

	@Override

	public Vocabulary getVocabulary() {
		return VOCABULARY;
	}


	public MeazzaLexer(CharStream input) {
		super(input);
		_interp = new LexerATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}

	@Override
	public String getGrammarFileName() { return "Meazza.g4"; }

	@Override
	public String[] getRuleNames() { return ruleNames; }

	@Override
	public String getSerializedATN() { return _serializedATN; }

	@Override
	public String[] getModeNames() { return modeNames; }

	@Override
	public ATN getATN() { return _ATN; }

	public static final String _serializedATN =
		"\3\u0430\ud6d1\u8206\uad2d\u4417\uaef1\u8d80\uaadd\2:\u016b\b\1\4\2\t"+
		"\2\4\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\4\13"+
		"\t\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t\20\4\21\t\21\4\22\t\22"+
		"\4\23\t\23\4\24\t\24\4\25\t\25\4\26\t\26\4\27\t\27\4\30\t\30\4\31\t\31"+
		"\4\32\t\32\4\33\t\33\4\34\t\34\4\35\t\35\4\36\t\36\4\37\t\37\4 \t \4!"+
		"\t!\4\"\t\"\4#\t#\4$\t$\4%\t%\4&\t&\4\'\t\'\4(\t(\4)\t)\4*\t*\4+\t+\4"+
		",\t,\4-\t-\4.\t.\4/\t/\4\60\t\60\4\61\t\61\4\62\t\62\4\63\t\63\4\64\t"+
		"\64\4\65\t\65\4\66\t\66\4\67\t\67\48\t8\49\t9\4:\t:\4;\t;\4<\t<\4=\t="+
		"\3\2\3\2\3\3\3\3\3\4\3\4\3\4\3\4\3\4\3\5\3\5\3\5\3\5\3\5\3\6\3\6\3\6\3"+
		"\6\3\6\3\6\3\7\3\7\3\b\3\b\3\t\3\t\3\n\3\n\3\n\3\13\3\13\3\13\3\13\3\13"+
		"\3\f\3\f\3\f\3\f\3\r\3\r\3\r\3\r\3\r\3\r\3\16\3\16\3\16\3\16\3\16\3\16"+
		"\3\17\3\17\3\17\3\17\3\17\3\17\3\17\3\17\3\17\3\20\3\20\3\20\3\20\3\20"+
		"\3\20\3\20\3\21\3\21\3\21\3\21\3\22\3\22\3\23\3\23\3\24\3\24\3\25\3\25"+
		"\3\26\3\26\3\26\3\27\3\27\3\27\3\30\3\30\3\31\3\31\3\32\3\32\3\33\3\33"+
		"\3\34\3\34\3\34\3\35\3\35\3\35\3\36\3\36\3\37\3\37\3 \3 \3 \3!\3!\3!\3"+
		"\"\3\"\3\"\3#\3#\3#\3$\3$\3%\3%\3&\3&\3\'\3\'\3\'\3(\3(\3(\3)\3)\3)\3"+
		")\3)\3)\3*\3*\3*\3*\3*\3*\3*\3*\3*\3+\3+\3+\3+\3+\3+\3,\3,\3,\3,\5,\u0113"+
		"\n,\3-\3-\7-\u0117\n-\f-\16-\u011a\13-\3.\6.\u011d\n.\r.\16.\u011e\3/"+
		"\3/\3\60\3\60\3\61\3\61\3\62\3\62\3\63\3\63\3\63\3\63\3\63\5\63\u012e"+
		"\n\63\3\64\3\64\3\64\5\64\u0133\n\64\3\64\3\64\3\65\3\65\3\65\7\65\u013a"+
		"\n\65\f\65\16\65\u013d\13\65\3\65\3\65\3\66\3\66\3\66\3\67\3\67\38\38"+
		"\39\39\39\39\79\u014c\n9\f9\169\u014f\139\39\39\3:\3:\3:\3:\7:\u0157\n"+
		":\f:\16:\u015a\13:\3:\3:\3:\3:\3:\3;\3;\3<\3<\3=\6=\u0166\n=\r=\16=\u0167"+
		"\3=\3=\3\u0158\2>\3\3\5\4\7\5\t\6\13\7\r\b\17\t\21\n\23\13\25\f\27\r\31"+
		"\16\33\17\35\20\37\21!\22#\23%\24\'\25)\26+\27-\30/\31\61\32\63\33\65"+
		"\34\67\359\36;\37= ?!A\"C#E$G%I&K\'M(O)Q*S+U,W-Y.[/]\60_\61a\62c\63e\64"+
		"g\65i\66k\67m\2o\2q8s9u\2w\2y:\3\2\r\3\2\62;\3\2))\3\2$$\3\2^^\t\2$$)"+
		")\61\61AA^^pptt\6\2\f\f\17\17))^^\6\2\f\f\17\17$$^^\4\2\f\f\17\17\5\2"+
		"C\\aac|\6\2\62;C\\aac|\5\2\13\f\17\17\"\"\u0170\2\3\3\2\2\2\2\5\3\2\2"+
		"\2\2\7\3\2\2\2\2\t\3\2\2\2\2\13\3\2\2\2\2\r\3\2\2\2\2\17\3\2\2\2\2\21"+
		"\3\2\2\2\2\23\3\2\2\2\2\25\3\2\2\2\2\27\3\2\2\2\2\31\3\2\2\2\2\33\3\2"+
		"\2\2\2\35\3\2\2\2\2\37\3\2\2\2\2!\3\2\2\2\2#\3\2\2\2\2%\3\2\2\2\2\'\3"+
		"\2\2\2\2)\3\2\2\2\2+\3\2\2\2\2-\3\2\2\2\2/\3\2\2\2\2\61\3\2\2\2\2\63\3"+
		"\2\2\2\2\65\3\2\2\2\2\67\3\2\2\2\29\3\2\2\2\2;\3\2\2\2\2=\3\2\2\2\2?\3"+
		"\2\2\2\2A\3\2\2\2\2C\3\2\2\2\2E\3\2\2\2\2G\3\2\2\2\2I\3\2\2\2\2K\3\2\2"+
		"\2\2M\3\2\2\2\2O\3\2\2\2\2Q\3\2\2\2\2S\3\2\2\2\2U\3\2\2\2\2W\3\2\2\2\2"+
		"Y\3\2\2\2\2[\3\2\2\2\2]\3\2\2\2\2_\3\2\2\2\2a\3\2\2\2\2c\3\2\2\2\2e\3"+
		"\2\2\2\2g\3\2\2\2\2i\3\2\2\2\2k\3\2\2\2\2q\3\2\2\2\2s\3\2\2\2\2y\3\2\2"+
		"\2\3{\3\2\2\2\5}\3\2\2\2\7\177\3\2\2\2\t\u0084\3\2\2\2\13\u0089\3\2\2"+
		"\2\r\u008f\3\2\2\2\17\u0091\3\2\2\2\21\u0093\3\2\2\2\23\u0095\3\2\2\2"+
		"\25\u0098\3\2\2\2\27\u009d\3\2\2\2\31\u00a1\3\2\2\2\33\u00a7\3\2\2\2\35"+
		"\u00ad\3\2\2\2\37\u00b6\3\2\2\2!\u00bd\3\2\2\2#\u00c1\3\2\2\2%\u00c3\3"+
		"\2\2\2\'\u00c5\3\2\2\2)\u00c7\3\2\2\2+\u00c9\3\2\2\2-\u00cc\3\2\2\2/\u00cf"+
		"\3\2\2\2\61\u00d1\3\2\2\2\63\u00d3\3\2\2\2\65\u00d5\3\2\2\2\67\u00d7\3"+
		"\2\2\29\u00da\3\2\2\2;\u00dd\3\2\2\2=\u00df\3\2\2\2?\u00e1\3\2\2\2A\u00e4"+
		"\3\2\2\2C\u00e7\3\2\2\2E\u00ea\3\2\2\2G\u00ed\3\2\2\2I\u00ef\3\2\2\2K"+
		"\u00f1\3\2\2\2M\u00f3\3\2\2\2O\u00f6\3\2\2\2Q\u00f9\3\2\2\2S\u00ff\3\2"+
		"\2\2U\u0108\3\2\2\2W\u0112\3\2\2\2Y\u0114\3\2\2\2[\u011c\3\2\2\2]\u0120"+
		"\3\2\2\2_\u0122\3\2\2\2a\u0124\3\2\2\2c\u0126\3\2\2\2e\u0128\3\2\2\2g"+
		"\u012f\3\2\2\2i\u0136\3\2\2\2k\u0140\3\2\2\2m\u0143\3\2\2\2o\u0145\3\2"+
		"\2\2q\u0147\3\2\2\2s\u0152\3\2\2\2u\u0160\3\2\2\2w\u0162\3\2\2\2y\u0165"+
		"\3\2\2\2{|\7?\2\2|\4\3\2\2\2}~\7=\2\2~\6\3\2\2\2\177\u0080\7p\2\2\u0080"+
		"\u0081\7w\2\2\u0081\u0082\7n\2\2\u0082\u0083\7n\2\2\u0083\b\3\2\2\2\u0084"+
		"\u0085\7v\2\2\u0085\u0086\7t\2\2\u0086\u0087\7w\2\2\u0087\u0088\7g\2\2"+
		"\u0088\n\3\2\2\2\u0089\u008a\7h\2\2\u008a\u008b\7c\2\2\u008b\u008c\7n"+
		"\2\2\u008c\u008d\7u\2\2\u008d\u008e\7g\2\2\u008e\f\3\2\2\2\u008f\u0090"+
		"\7.\2\2\u0090\16\3\2\2\2\u0091\u0092\7}\2\2\u0092\20\3\2\2\2\u0093\u0094"+
		"\7\177\2\2\u0094\22\3\2\2\2\u0095\u0096\7k\2\2\u0096\u0097\7h\2\2\u0097"+
		"\24\3\2\2\2\u0098\u0099\7g\2\2\u0099\u009a\7n\2\2\u009a\u009b\7u\2\2\u009b"+
		"\u009c\7g\2\2\u009c\26\3\2\2\2\u009d\u009e\7h\2\2\u009e\u009f\7q\2\2\u009f"+
		"\u00a0\7t\2\2\u00a0\30\3\2\2\2\u00a1\u00a2\7y\2\2\u00a2\u00a3\7j\2\2\u00a3"+
		"\u00a4\7k\2\2\u00a4\u00a5\7n\2\2\u00a5\u00a6\7g\2\2\u00a6\32\3\2\2\2\u00a7"+
		"\u00a8\7d\2\2\u00a8\u00a9\7t\2\2\u00a9\u00aa\7g\2\2\u00aa\u00ab\7c\2\2"+
		"\u00ab\u00ac\7m\2\2\u00ac\34\3\2\2\2\u00ad\u00ae\7e\2\2\u00ae\u00af\7"+
		"q\2\2\u00af\u00b0\7p\2\2\u00b0\u00b1\7v\2\2\u00b1\u00b2\7k\2\2\u00b2\u00b3"+
		"\7p\2\2\u00b3\u00b4\7w\2\2\u00b4\u00b5\7g\2\2\u00b5\36\3\2\2\2\u00b6\u00b7"+
		"\7t\2\2\u00b7\u00b8\7g\2\2\u00b8\u00b9\7v\2\2\u00b9\u00ba\7w\2\2\u00ba"+
		"\u00bb\7t\2\2\u00bb\u00bc\7p\2\2\u00bc \3\2\2\2\u00bd\u00be\7p\2\2\u00be"+
		"\u00bf\7g\2\2\u00bf\u00c0\7y\2\2\u00c0\"\3\2\2\2\u00c1\u00c2\7\60\2\2"+
		"\u00c2$\3\2\2\2\u00c3\u00c4\7/\2\2\u00c4&\3\2\2\2\u00c5\u00c6\7\u0080"+
		"\2\2\u00c6(\3\2\2\2\u00c7\u00c8\7#\2\2\u00c8*\3\2\2\2\u00c9\u00ca\7-\2"+
		"\2\u00ca\u00cb\7-\2\2\u00cb,\3\2\2\2\u00cc\u00cd\7/\2\2\u00cd\u00ce\7"+
		"/\2\2\u00ce.\3\2\2\2\u00cf\u00d0\7,\2\2\u00d0\60\3\2\2\2\u00d1\u00d2\7"+
		"\61\2\2\u00d2\62\3\2\2\2\u00d3\u00d4\7\'\2\2\u00d4\64\3\2\2\2\u00d5\u00d6"+
		"\7-\2\2\u00d6\66\3\2\2\2\u00d7\u00d8\7>\2\2\u00d8\u00d9\7>\2\2\u00d98"+
		"\3\2\2\2\u00da\u00db\7@\2\2\u00db\u00dc\7@\2\2\u00dc:\3\2\2\2\u00dd\u00de"+
		"\7@\2\2\u00de<\3\2\2\2\u00df\u00e0\7>\2\2\u00e0>\3\2\2\2\u00e1\u00e2\7"+
		"@\2\2\u00e2\u00e3\7?\2\2\u00e3@\3\2\2\2\u00e4\u00e5\7>\2\2\u00e5\u00e6"+
		"\7?\2\2\u00e6B\3\2\2\2\u00e7\u00e8\7?\2\2\u00e8\u00e9\7?\2\2\u00e9D\3"+
		"\2\2\2\u00ea\u00eb\7#\2\2\u00eb\u00ec\7?\2\2\u00ecF\3\2\2\2\u00ed\u00ee"+
		"\7(\2\2\u00eeH\3\2\2\2\u00ef\u00f0\7`\2\2\u00f0J\3\2\2\2\u00f1\u00f2\7"+
		"~\2\2\u00f2L\3\2\2\2\u00f3\u00f4\7(\2\2\u00f4\u00f5\7(\2\2\u00f5N\3\2"+
		"\2\2\u00f6\u00f7\7~\2\2\u00f7\u00f8\7~\2\2\u00f8P\3\2\2\2\u00f9\u00fa"+
		"\7e\2\2\u00fa\u00fb\7q\2\2\u00fb\u00fc\7p\2\2\u00fc\u00fd\7u\2\2\u00fd"+
		"\u00fe\7v\2\2\u00feR\3\2\2\2\u00ff\u0100\7w\2\2\u0100\u0101\7p\2\2\u0101"+
		"\u0102\7u\2\2\u0102\u0103\7k\2\2\u0103\u0104\7i\2\2\u0104\u0105\7p\2\2"+
		"\u0105\u0106\7g\2\2\u0106\u0107\7f\2\2\u0107T\3\2\2\2\u0108\u0109\7e\2"+
		"\2\u0109\u010a\7n\2\2\u010a\u010b\7c\2\2\u010b\u010c\7u\2\2\u010c\u010d"+
		"\7u\2\2\u010dV\3\2\2\2\u010e\u010f\7N\2\2\u010f\u0113\7N\2\2\u0110\u0111"+
		"\7W\2\2\u0111\u0113\7N\2\2\u0112\u010e\3\2\2\2\u0112\u0110\3\2\2\2\u0113"+
		"X\3\2\2\2\u0114\u0118\5u;\2\u0115\u0117\5w<\2\u0116\u0115\3\2\2\2\u0117"+
		"\u011a\3\2\2\2\u0118\u0116\3\2\2\2\u0118\u0119\3\2\2\2\u0119Z\3\2\2\2"+
		"\u011a\u0118\3\2\2\2\u011b\u011d\t\2\2\2\u011c\u011b\3\2\2\2\u011d\u011e"+
		"\3\2\2\2\u011e\u011c\3\2\2\2\u011e\u011f\3\2\2\2\u011f\\\3\2\2\2\u0120"+
		"\u0121\7*\2\2\u0121^\3\2\2\2\u0122\u0123\7+\2\2\u0123`\3\2\2\2\u0124\u0125"+
		"\7]\2\2\u0125b\3\2\2\2\u0126\u0127\7_\2\2\u0127d\3\2\2\2\u0128\u0129\5"+
		"[.\2\u0129\u012a\7\60\2\2\u012a\u012d\5[.\2\u012b\u012c\7G\2\2\u012c\u012e"+
		"\5[.\2\u012d\u012b\3\2\2\2\u012d\u012e\3\2\2\2\u012ef\3\2\2\2\u012f\u0132"+
		"\t\3\2\2\u0130\u0133\5m\67\2\u0131\u0133\5k\66\2\u0132\u0130\3\2\2\2\u0132"+
		"\u0131\3\2\2\2\u0133\u0134\3\2\2\2\u0134\u0135\t\3\2\2\u0135h\3\2\2\2"+
		"\u0136\u013b\t\4\2\2\u0137\u013a\5o8\2\u0138\u013a\5k\66\2\u0139\u0137"+
		"\3\2\2\2\u0139\u0138\3\2\2\2\u013a\u013d\3\2\2\2\u013b\u0139\3\2\2\2\u013b"+
		"\u013c\3\2\2\2\u013c\u013e\3\2\2\2\u013d\u013b\3\2\2\2\u013e\u013f\t\4"+
		"\2\2\u013fj\3\2\2\2\u0140\u0141\t\5\2\2\u0141\u0142\t\6\2\2\u0142l\3\2"+
		"\2\2\u0143\u0144\n\7\2\2\u0144n\3\2\2\2\u0145\u0146\n\b\2\2\u0146p\3\2"+
		"\2\2\u0147\u0148\7\61\2\2\u0148\u0149\7\61\2\2\u0149\u014d\3\2\2\2\u014a"+
		"\u014c\n\t\2\2\u014b\u014a\3\2\2\2\u014c\u014f\3\2\2\2\u014d\u014b\3\2"+
		"\2\2\u014d\u014e\3\2\2\2\u014e\u0150\3\2\2\2\u014f\u014d\3\2\2\2\u0150"+
		"\u0151\b9\2\2\u0151r\3\2\2\2\u0152\u0153\7\61\2\2\u0153\u0154\7,\2\2\u0154"+
		"\u0158\3\2\2\2\u0155\u0157\13\2\2\2\u0156\u0155\3\2\2\2\u0157\u015a\3"+
		"\2\2\2\u0158\u0159\3\2\2\2\u0158\u0156\3\2\2\2\u0159\u015b\3\2\2\2\u015a"+
		"\u0158\3\2\2\2\u015b\u015c\7,\2\2\u015c\u015d\7\61\2\2\u015d\u015e\3\2"+
		"\2\2\u015e\u015f\b:\2\2\u015ft\3\2\2\2\u0160\u0161\t\n\2\2\u0161v\3\2"+
		"\2\2\u0162\u0163\t\13\2\2\u0163x\3\2\2\2\u0164\u0166\t\f\2\2\u0165\u0164"+
		"\3\2\2\2\u0166\u0167\3\2\2\2\u0167\u0165\3\2\2\2\u0167\u0168\3\2\2\2\u0168"+
		"\u0169\3\2\2\2\u0169\u016a\b=\3\2\u016az\3\2\2\2\r\2\u0112\u0118\u011e"+
		"\u012d\u0132\u0139\u013b\u014d\u0158\u0167\4\2\3\2\b\2\2";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}