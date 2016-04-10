// Generated from C:/Users/Bill/OneDrive/Ideaprojects/Meazzacompiler\Meazza.g4 by ANTLR 4.5.1
package antlr;
import org.antlr.v4.runtime.atn.*;
import org.antlr.v4.runtime.dfa.DFA;
import org.antlr.v4.runtime.*;
import org.antlr.v4.runtime.misc.*;
import org.antlr.v4.runtime.tree.*;
import java.util.List;
import java.util.Iterator;
import java.util.ArrayList;

@SuppressWarnings({"all", "warnings", "unchecked", "unused", "cast"})
public class MeazzaParser extends Parser {
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
		T__38=39, T__39=40, CONST=41, UNSIGNED=42, CLASS=43, STRING=44, INT_POST=45, 
		ID=46, INT_DATA=47, LBRACE=48, RBRACE=49, LBLOCK=50, RBLOCK=51, FLOAT_DATA=52, 
		CHAR_DATA=53, STRING_DATA=54, LINE_COMMENT=55, BLOCK_COMMENT=56, Translate=57, 
		WS=58;
	public static final int
		RULE_r = 0, RULE_prog = 1, RULE_comment = 2, RULE_var_declaration = 3, 
		RULE_raw_declaration = 4, RULE_type = 5, RULE_array = 6, RULE_type_name = 7, 
		RULE_const_expression = 8, RULE_func_declaration = 9, RULE_parameters = 10, 
		RULE_parameter = 11, RULE_compound_statement = 12, RULE_statement = 13, 
		RULE_if_statement = 14, RULE_for_statement = 15, RULE_while_statement = 16, 
		RULE_jump_statement = 17, RULE_normal_statement = 18, RULE_expression = 19, 
		RULE_class_declaration = 20;
	public static final String[] ruleNames = {
		"r", "prog", "comment", "var_declaration", "raw_declaration", "type", 
		"array", "type_name", "const_expression", "func_declaration", "parameters", 
		"parameter", "compound_statement", "statement", "if_statement", "for_statement", 
		"while_statement", "jump_statement", "normal_statement", "expression", 
		"class_declaration"
	};

	private static final String[] _LITERAL_NAMES = {
		null, "'='", "';'", "'null'", "'true'", "'false'", "'void'", "','", "'{'", 
		"'}'", "'if'", "'else'", "'for'", "'while'", "'break'", "'continue'", 
		"'return'", "'.'", "'new'", "'-'", "'~'", "'!'", "'++'", "'--'", "'*'", 
		"'/'", "'%'", "'+'", "'<<'", "'>>'", "'>'", "'<'", "'>='", "'<='", "'=='", 
		"'!='", "'&'", "'^'", "'|'", "'&&'", "'||'", "'const'", "'unsigned'", 
		"'class'", "'string'", null, null, null, "'('", "')'", "'['", "']'"
	};
	private static final String[] _SYMBOLIC_NAMES = {
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, null, null, null, null, null, null, null, null, null, null, 
		null, null, null, null, null, "CONST", "UNSIGNED", "CLASS", "STRING", 
		"INT_POST", "ID", "INT_DATA", "LBRACE", "RBRACE", "LBLOCK", "RBLOCK", 
		"FLOAT_DATA", "CHAR_DATA", "STRING_DATA", "LINE_COMMENT", "BLOCK_COMMENT", 
		"Translate", "WS"
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

	@Override
	public String getGrammarFileName() { return "Meazza.g4"; }

	@Override
	public String[] getRuleNames() { return ruleNames; }

	@Override
	public String getSerializedATN() { return _serializedATN; }

	@Override
	public ATN getATN() { return _ATN; }

	public MeazzaParser(TokenStream input) {
		super(input);
		_interp = new ParserATNSimulator(this,_ATN,_decisionToDFA,_sharedContextCache);
	}
	public static class RContext extends ParserRuleContext {
		public ProgContext prog() {
			return getRuleContext(ProgContext.class,0);
		}
		public RContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_r; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof MeazzaListener ) ((MeazzaListener)listener).enterR(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof MeazzaListener ) ((MeazzaListener)listener).exitR(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof MeazzaVisitor ) return ((MeazzaVisitor<? extends T>)visitor).visitR(this);
			else return visitor.visitChildren(this);
		}
	}

	public final RContext r() throws RecognitionException {
		RContext _localctx = new RContext(_ctx, getState());
		enterRule(_localctx, 0, RULE_r);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(42);
			prog();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ProgContext extends ParserRuleContext {
		public List<Var_declarationContext> var_declaration() {
			return getRuleContexts(Var_declarationContext.class);
		}
		public Var_declarationContext var_declaration(int i) {
			return getRuleContext(Var_declarationContext.class,i);
		}
		public List<Func_declarationContext> func_declaration() {
			return getRuleContexts(Func_declarationContext.class);
		}
		public Func_declarationContext func_declaration(int i) {
			return getRuleContext(Func_declarationContext.class,i);
		}
		public List<Class_declarationContext> class_declaration() {
			return getRuleContexts(Class_declarationContext.class);
		}
		public Class_declarationContext class_declaration(int i) {
			return getRuleContext(Class_declarationContext.class,i);
		}
		public List<CommentContext> comment() {
			return getRuleContexts(CommentContext.class);
		}
		public CommentContext comment(int i) {
			return getRuleContext(CommentContext.class,i);
		}
		public ProgContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_prog; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof MeazzaListener ) ((MeazzaListener)listener).enterProg(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof MeazzaListener ) ((MeazzaListener)listener).exitProg(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof MeazzaVisitor ) return ((MeazzaVisitor<? extends T>)visitor).visitProg(this);
			else return visitor.visitChildren(this);
		}
	}

	public final ProgContext prog() throws RecognitionException {
		ProgContext _localctx = new ProgContext(_ctx, getState());
		enterRule(_localctx, 2, RULE_prog);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(48); 
			_errHandler.sync(this);
			_la = _input.LA(1);
			do {
				{
				setState(48);
				switch ( getInterpreter().adaptivePredict(_input,0,_ctx) ) {
				case 1:
					{
					setState(44);
					var_declaration();
					}
					break;
				case 2:
					{
					setState(45);
					func_declaration();
					}
					break;
				case 3:
					{
					setState(46);
					class_declaration();
					}
					break;
				case 4:
					{
					setState(47);
					comment();
					}
					break;
				}
				}
				setState(50); 
				_errHandler.sync(this);
				_la = _input.LA(1);
			} while ( (((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__5) | (1L << CLASS) | (1L << ID) | (1L << LINE_COMMENT) | (1L << BLOCK_COMMENT))) != 0) );
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class CommentContext extends ParserRuleContext {
		public TerminalNode LINE_COMMENT() { return getToken(MeazzaParser.LINE_COMMENT, 0); }
		public TerminalNode BLOCK_COMMENT() { return getToken(MeazzaParser.BLOCK_COMMENT, 0); }
		public CommentContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_comment; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof MeazzaListener ) ((MeazzaListener)listener).enterComment(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof MeazzaListener ) ((MeazzaListener)listener).exitComment(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof MeazzaVisitor ) return ((MeazzaVisitor<? extends T>)visitor).visitComment(this);
			else return visitor.visitChildren(this);
		}
	}

	public final CommentContext comment() throws RecognitionException {
		CommentContext _localctx = new CommentContext(_ctx, getState());
		enterRule(_localctx, 4, RULE_comment);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(52);
			_la = _input.LA(1);
			if ( !(_la==LINE_COMMENT || _la==BLOCK_COMMENT) ) {
			_errHandler.recoverInline(this);
			} else {
				consume();
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class Var_declarationContext extends ParserRuleContext {
		public TypeContext type() {
			return getRuleContext(TypeContext.class,0);
		}
		public TerminalNode ID() { return getToken(MeazzaParser.ID, 0); }
		public ExpressionContext expression() {
			return getRuleContext(ExpressionContext.class,0);
		}
		public Var_declarationContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_var_declaration; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof MeazzaListener ) ((MeazzaListener)listener).enterVar_declaration(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof MeazzaListener ) ((MeazzaListener)listener).exitVar_declaration(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof MeazzaVisitor ) return ((MeazzaVisitor<? extends T>)visitor).visitVar_declaration(this);
			else return visitor.visitChildren(this);
		}
	}

	public final Var_declarationContext var_declaration() throws RecognitionException {
		Var_declarationContext _localctx = new Var_declarationContext(_ctx, getState());
		enterRule(_localctx, 6, RULE_var_declaration);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(54);
			type();
			setState(55);
			match(ID);
			setState(58);
			_la = _input.LA(1);
			if (_la==T__0) {
				{
				setState(56);
				match(T__0);
				setState(57);
				expression(0);
				}
			}

			setState(60);
			match(T__1);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class Raw_declarationContext extends ParserRuleContext {
		public TypeContext type() {
			return getRuleContext(TypeContext.class,0);
		}
		public TerminalNode ID() { return getToken(MeazzaParser.ID, 0); }
		public Raw_declarationContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_raw_declaration; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof MeazzaListener ) ((MeazzaListener)listener).enterRaw_declaration(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof MeazzaListener ) ((MeazzaListener)listener).exitRaw_declaration(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof MeazzaVisitor ) return ((MeazzaVisitor<? extends T>)visitor).visitRaw_declaration(this);
			else return visitor.visitChildren(this);
		}
	}

	public final Raw_declarationContext raw_declaration() throws RecognitionException {
		Raw_declarationContext _localctx = new Raw_declarationContext(_ctx, getState());
		enterRule(_localctx, 8, RULE_raw_declaration);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(62);
			type();
			setState(63);
			match(ID);
			setState(64);
			match(T__1);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class TypeContext extends ParserRuleContext {
		public Type_nameContext type_name() {
			return getRuleContext(Type_nameContext.class,0);
		}
		public List<ArrayContext> array() {
			return getRuleContexts(ArrayContext.class);
		}
		public ArrayContext array(int i) {
			return getRuleContext(ArrayContext.class,i);
		}
		public TypeContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_type; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof MeazzaListener ) ((MeazzaListener)listener).enterType(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof MeazzaListener ) ((MeazzaListener)listener).exitType(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof MeazzaVisitor ) return ((MeazzaVisitor<? extends T>)visitor).visitType(this);
			else return visitor.visitChildren(this);
		}
	}

	public final TypeContext type() throws RecognitionException {
		TypeContext _localctx = new TypeContext(_ctx, getState());
		enterRule(_localctx, 10, RULE_type);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(66);
			type_name();
			setState(70);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==LBLOCK) {
				{
				{
				setState(67);
				array();
				}
				}
				setState(72);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ArrayContext extends ParserRuleContext {
		public ArrayContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_array; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof MeazzaListener ) ((MeazzaListener)listener).enterArray(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof MeazzaListener ) ((MeazzaListener)listener).exitArray(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof MeazzaVisitor ) return ((MeazzaVisitor<? extends T>)visitor).visitArray(this);
			else return visitor.visitChildren(this);
		}
	}

	public final ArrayContext array() throws RecognitionException {
		ArrayContext _localctx = new ArrayContext(_ctx, getState());
		enterRule(_localctx, 12, RULE_array);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(73);
			match(LBLOCK);
			setState(74);
			match(RBLOCK);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class Type_nameContext extends ParserRuleContext {
		public TerminalNode ID() { return getToken(MeazzaParser.ID, 0); }
		public Type_nameContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_type_name; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof MeazzaListener ) ((MeazzaListener)listener).enterType_name(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof MeazzaListener ) ((MeazzaListener)listener).exitType_name(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof MeazzaVisitor ) return ((MeazzaVisitor<? extends T>)visitor).visitType_name(this);
			else return visitor.visitChildren(this);
		}
	}

	public final Type_nameContext type_name() throws RecognitionException {
		Type_nameContext _localctx = new Type_nameContext(_ctx, getState());
		enterRule(_localctx, 14, RULE_type_name);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(76);
			match(ID);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class Const_expressionContext extends ParserRuleContext {
		public Token nullData;
		public Token boolData;
		public TerminalNode INT_DATA() { return getToken(MeazzaParser.INT_DATA, 0); }
		public TerminalNode INT_POST() { return getToken(MeazzaParser.INT_POST, 0); }
		public TerminalNode FLOAT_DATA() { return getToken(MeazzaParser.FLOAT_DATA, 0); }
		public TerminalNode CHAR_DATA() { return getToken(MeazzaParser.CHAR_DATA, 0); }
		public TerminalNode STRING_DATA() { return getToken(MeazzaParser.STRING_DATA, 0); }
		public Const_expressionContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_const_expression; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof MeazzaListener ) ((MeazzaListener)listener).enterConst_expression(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof MeazzaListener ) ((MeazzaListener)listener).exitConst_expression(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof MeazzaVisitor ) return ((MeazzaVisitor<? extends T>)visitor).visitConst_expression(this);
			else return visitor.visitChildren(this);
		}
	}

	public final Const_expressionContext const_expression() throws RecognitionException {
		Const_expressionContext _localctx = new Const_expressionContext(_ctx, getState());
		enterRule(_localctx, 16, RULE_const_expression);
		try {
			setState(88);
			switch (_input.LA(1)) {
			case INT_DATA:
				enterOuterAlt(_localctx, 1);
				{
				setState(78);
				match(INT_DATA);
				setState(80);
				switch ( getInterpreter().adaptivePredict(_input,4,_ctx) ) {
				case 1:
					{
					setState(79);
					match(INT_POST);
					}
					break;
				}
				}
				break;
			case FLOAT_DATA:
				enterOuterAlt(_localctx, 2);
				{
				setState(82);
				match(FLOAT_DATA);
				}
				break;
			case T__2:
				enterOuterAlt(_localctx, 3);
				{
				setState(83);
				((Const_expressionContext)_localctx).nullData = match(T__2);
				}
				break;
			case T__3:
				enterOuterAlt(_localctx, 4);
				{
				setState(84);
				((Const_expressionContext)_localctx).boolData = match(T__3);
				}
				break;
			case T__4:
				enterOuterAlt(_localctx, 5);
				{
				setState(85);
				((Const_expressionContext)_localctx).boolData = match(T__4);
				}
				break;
			case CHAR_DATA:
				enterOuterAlt(_localctx, 6);
				{
				setState(86);
				match(CHAR_DATA);
				}
				break;
			case STRING_DATA:
				enterOuterAlt(_localctx, 7);
				{
				setState(87);
				match(STRING_DATA);
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class Func_declarationContext extends ParserRuleContext {
		public Token op;
		public TerminalNode ID() { return getToken(MeazzaParser.ID, 0); }
		public Compound_statementContext compound_statement() {
			return getRuleContext(Compound_statementContext.class,0);
		}
		public TypeContext type() {
			return getRuleContext(TypeContext.class,0);
		}
		public ParametersContext parameters() {
			return getRuleContext(ParametersContext.class,0);
		}
		public Func_declarationContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_func_declaration; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof MeazzaListener ) ((MeazzaListener)listener).enterFunc_declaration(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof MeazzaListener ) ((MeazzaListener)listener).exitFunc_declaration(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof MeazzaVisitor ) return ((MeazzaVisitor<? extends T>)visitor).visitFunc_declaration(this);
			else return visitor.visitChildren(this);
		}
	}

	public final Func_declarationContext func_declaration() throws RecognitionException {
		Func_declarationContext _localctx = new Func_declarationContext(_ctx, getState());
		enterRule(_localctx, 18, RULE_func_declaration);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(92);
			switch (_input.LA(1)) {
			case ID:
				{
				setState(90);
				type();
				}
				break;
			case T__5:
				{
				setState(91);
				((Func_declarationContext)_localctx).op = match(T__5);
				}
				break;
			default:
				throw new NoViableAltException(this);
			}
			setState(94);
			match(ID);
			setState(95);
			match(LBRACE);
			setState(97);
			_la = _input.LA(1);
			if (_la==ID) {
				{
				setState(96);
				parameters();
				}
			}

			setState(99);
			match(RBRACE);
			setState(100);
			compound_statement();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ParametersContext extends ParserRuleContext {
		public List<ParameterContext> parameter() {
			return getRuleContexts(ParameterContext.class);
		}
		public ParameterContext parameter(int i) {
			return getRuleContext(ParameterContext.class,i);
		}
		public ParametersContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_parameters; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof MeazzaListener ) ((MeazzaListener)listener).enterParameters(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof MeazzaListener ) ((MeazzaListener)listener).exitParameters(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof MeazzaVisitor ) return ((MeazzaVisitor<? extends T>)visitor).visitParameters(this);
			else return visitor.visitChildren(this);
		}
	}

	public final ParametersContext parameters() throws RecognitionException {
		ParametersContext _localctx = new ParametersContext(_ctx, getState());
		enterRule(_localctx, 20, RULE_parameters);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(102);
			parameter();
			setState(107);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==T__6) {
				{
				{
				setState(103);
				match(T__6);
				setState(104);
				parameter();
				}
				}
				setState(109);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ParameterContext extends ParserRuleContext {
		public TypeContext type() {
			return getRuleContext(TypeContext.class,0);
		}
		public TerminalNode ID() { return getToken(MeazzaParser.ID, 0); }
		public ParameterContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_parameter; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof MeazzaListener ) ((MeazzaListener)listener).enterParameter(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof MeazzaListener ) ((MeazzaListener)listener).exitParameter(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof MeazzaVisitor ) return ((MeazzaVisitor<? extends T>)visitor).visitParameter(this);
			else return visitor.visitChildren(this);
		}
	}

	public final ParameterContext parameter() throws RecognitionException {
		ParameterContext _localctx = new ParameterContext(_ctx, getState());
		enterRule(_localctx, 22, RULE_parameter);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(110);
			type();
			setState(111);
			match(ID);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class Compound_statementContext extends ParserRuleContext {
		public List<StatementContext> statement() {
			return getRuleContexts(StatementContext.class);
		}
		public StatementContext statement(int i) {
			return getRuleContext(StatementContext.class,i);
		}
		public List<Var_declarationContext> var_declaration() {
			return getRuleContexts(Var_declarationContext.class);
		}
		public Var_declarationContext var_declaration(int i) {
			return getRuleContext(Var_declarationContext.class,i);
		}
		public Compound_statementContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_compound_statement; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof MeazzaListener ) ((MeazzaListener)listener).enterCompound_statement(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof MeazzaListener ) ((MeazzaListener)listener).exitCompound_statement(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof MeazzaVisitor ) return ((MeazzaVisitor<? extends T>)visitor).visitCompound_statement(this);
			else return visitor.visitChildren(this);
		}
	}

	public final Compound_statementContext compound_statement() throws RecognitionException {
		Compound_statementContext _localctx = new Compound_statementContext(_ctx, getState());
		enterRule(_localctx, 24, RULE_compound_statement);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(113);
			match(T__7);
			setState(118);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__1) | (1L << T__2) | (1L << T__3) | (1L << T__4) | (1L << T__7) | (1L << T__9) | (1L << T__11) | (1L << T__12) | (1L << T__13) | (1L << T__14) | (1L << T__15) | (1L << T__17) | (1L << T__18) | (1L << T__19) | (1L << T__20) | (1L << T__21) | (1L << T__22) | (1L << ID) | (1L << INT_DATA) | (1L << LBRACE) | (1L << FLOAT_DATA) | (1L << CHAR_DATA) | (1L << STRING_DATA))) != 0)) {
				{
				setState(116);
				switch ( getInterpreter().adaptivePredict(_input,9,_ctx) ) {
				case 1:
					{
					setState(114);
					statement();
					}
					break;
				case 2:
					{
					setState(115);
					var_declaration();
					}
					break;
				}
				}
				setState(120);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(121);
			match(T__8);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class StatementContext extends ParserRuleContext {
		public Compound_statementContext compound_statement() {
			return getRuleContext(Compound_statementContext.class,0);
		}
		public Var_declarationContext var_declaration() {
			return getRuleContext(Var_declarationContext.class,0);
		}
		public If_statementContext if_statement() {
			return getRuleContext(If_statementContext.class,0);
		}
		public For_statementContext for_statement() {
			return getRuleContext(For_statementContext.class,0);
		}
		public While_statementContext while_statement() {
			return getRuleContext(While_statementContext.class,0);
		}
		public Jump_statementContext jump_statement() {
			return getRuleContext(Jump_statementContext.class,0);
		}
		public Normal_statementContext normal_statement() {
			return getRuleContext(Normal_statementContext.class,0);
		}
		public StatementContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_statement; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof MeazzaListener ) ((MeazzaListener)listener).enterStatement(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof MeazzaListener ) ((MeazzaListener)listener).exitStatement(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof MeazzaVisitor ) return ((MeazzaVisitor<? extends T>)visitor).visitStatement(this);
			else return visitor.visitChildren(this);
		}
	}

	public final StatementContext statement() throws RecognitionException {
		StatementContext _localctx = new StatementContext(_ctx, getState());
		enterRule(_localctx, 26, RULE_statement);
		try {
			setState(130);
			switch ( getInterpreter().adaptivePredict(_input,11,_ctx) ) {
			case 1:
				enterOuterAlt(_localctx, 1);
				{
				setState(123);
				compound_statement();
				}
				break;
			case 2:
				enterOuterAlt(_localctx, 2);
				{
				setState(124);
				var_declaration();
				}
				break;
			case 3:
				enterOuterAlt(_localctx, 3);
				{
				setState(125);
				if_statement();
				}
				break;
			case 4:
				enterOuterAlt(_localctx, 4);
				{
				setState(126);
				for_statement();
				}
				break;
			case 5:
				enterOuterAlt(_localctx, 5);
				{
				setState(127);
				while_statement();
				}
				break;
			case 6:
				enterOuterAlt(_localctx, 6);
				{
				setState(128);
				jump_statement();
				}
				break;
			case 7:
				enterOuterAlt(_localctx, 7);
				{
				setState(129);
				normal_statement();
				}
				break;
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class If_statementContext extends ParserRuleContext {
		public ExpressionContext expression() {
			return getRuleContext(ExpressionContext.class,0);
		}
		public List<StatementContext> statement() {
			return getRuleContexts(StatementContext.class);
		}
		public StatementContext statement(int i) {
			return getRuleContext(StatementContext.class,i);
		}
		public If_statementContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_if_statement; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof MeazzaListener ) ((MeazzaListener)listener).enterIf_statement(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof MeazzaListener ) ((MeazzaListener)listener).exitIf_statement(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof MeazzaVisitor ) return ((MeazzaVisitor<? extends T>)visitor).visitIf_statement(this);
			else return visitor.visitChildren(this);
		}
	}

	public final If_statementContext if_statement() throws RecognitionException {
		If_statementContext _localctx = new If_statementContext(_ctx, getState());
		enterRule(_localctx, 28, RULE_if_statement);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(132);
			match(T__9);
			setState(133);
			match(LBRACE);
			setState(134);
			expression(0);
			setState(135);
			match(RBRACE);
			setState(136);
			statement();
			setState(139);
			switch ( getInterpreter().adaptivePredict(_input,12,_ctx) ) {
			case 1:
				{
				setState(137);
				match(T__10);
				setState(138);
				statement();
				}
				break;
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class For_statementContext extends ParserRuleContext {
		public ExpressionContext exp1;
		public ExpressionContext exp2;
		public ExpressionContext exp3;
		public StatementContext statement() {
			return getRuleContext(StatementContext.class,0);
		}
		public List<ExpressionContext> expression() {
			return getRuleContexts(ExpressionContext.class);
		}
		public ExpressionContext expression(int i) {
			return getRuleContext(ExpressionContext.class,i);
		}
		public For_statementContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_for_statement; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof MeazzaListener ) ((MeazzaListener)listener).enterFor_statement(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof MeazzaListener ) ((MeazzaListener)listener).exitFor_statement(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof MeazzaVisitor ) return ((MeazzaVisitor<? extends T>)visitor).visitFor_statement(this);
			else return visitor.visitChildren(this);
		}
	}

	public final For_statementContext for_statement() throws RecognitionException {
		For_statementContext _localctx = new For_statementContext(_ctx, getState());
		enterRule(_localctx, 30, RULE_for_statement);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(141);
			match(T__11);
			setState(142);
			match(LBRACE);
			setState(144);
			_la = _input.LA(1);
			if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__2) | (1L << T__3) | (1L << T__4) | (1L << T__17) | (1L << T__18) | (1L << T__19) | (1L << T__20) | (1L << T__21) | (1L << T__22) | (1L << ID) | (1L << INT_DATA) | (1L << LBRACE) | (1L << FLOAT_DATA) | (1L << CHAR_DATA) | (1L << STRING_DATA))) != 0)) {
				{
				setState(143);
				((For_statementContext)_localctx).exp1 = expression(0);
				}
			}

			setState(146);
			match(T__1);
			setState(148);
			_la = _input.LA(1);
			if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__2) | (1L << T__3) | (1L << T__4) | (1L << T__17) | (1L << T__18) | (1L << T__19) | (1L << T__20) | (1L << T__21) | (1L << T__22) | (1L << ID) | (1L << INT_DATA) | (1L << LBRACE) | (1L << FLOAT_DATA) | (1L << CHAR_DATA) | (1L << STRING_DATA))) != 0)) {
				{
				setState(147);
				((For_statementContext)_localctx).exp2 = expression(0);
				}
			}

			setState(150);
			match(T__1);
			setState(152);
			_la = _input.LA(1);
			if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__2) | (1L << T__3) | (1L << T__4) | (1L << T__17) | (1L << T__18) | (1L << T__19) | (1L << T__20) | (1L << T__21) | (1L << T__22) | (1L << ID) | (1L << INT_DATA) | (1L << LBRACE) | (1L << FLOAT_DATA) | (1L << CHAR_DATA) | (1L << STRING_DATA))) != 0)) {
				{
				setState(151);
				((For_statementContext)_localctx).exp3 = expression(0);
				}
			}

			setState(154);
			match(RBRACE);
			setState(155);
			statement();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class While_statementContext extends ParserRuleContext {
		public ExpressionContext expression() {
			return getRuleContext(ExpressionContext.class,0);
		}
		public StatementContext statement() {
			return getRuleContext(StatementContext.class,0);
		}
		public While_statementContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_while_statement; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof MeazzaListener ) ((MeazzaListener)listener).enterWhile_statement(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof MeazzaListener ) ((MeazzaListener)listener).exitWhile_statement(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof MeazzaVisitor ) return ((MeazzaVisitor<? extends T>)visitor).visitWhile_statement(this);
			else return visitor.visitChildren(this);
		}
	}

	public final While_statementContext while_statement() throws RecognitionException {
		While_statementContext _localctx = new While_statementContext(_ctx, getState());
		enterRule(_localctx, 32, RULE_while_statement);
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(157);
			match(T__12);
			setState(158);
			match(LBRACE);
			setState(159);
			expression(0);
			setState(160);
			match(RBRACE);
			setState(161);
			statement();
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class Jump_statementContext extends ParserRuleContext {
		public Token op;
		public ExpressionContext expression() {
			return getRuleContext(ExpressionContext.class,0);
		}
		public Jump_statementContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_jump_statement; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof MeazzaListener ) ((MeazzaListener)listener).enterJump_statement(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof MeazzaListener ) ((MeazzaListener)listener).exitJump_statement(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof MeazzaVisitor ) return ((MeazzaVisitor<? extends T>)visitor).visitJump_statement(this);
			else return visitor.visitChildren(this);
		}
	}

	public final Jump_statementContext jump_statement() throws RecognitionException {
		Jump_statementContext _localctx = new Jump_statementContext(_ctx, getState());
		enterRule(_localctx, 34, RULE_jump_statement);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(169);
			switch (_input.LA(1)) {
			case T__13:
				{
				setState(163);
				((Jump_statementContext)_localctx).op = match(T__13);
				}
				break;
			case T__14:
				{
				setState(164);
				((Jump_statementContext)_localctx).op = match(T__14);
				}
				break;
			case T__15:
				{
				setState(165);
				((Jump_statementContext)_localctx).op = match(T__15);
				setState(167);
				_la = _input.LA(1);
				if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__2) | (1L << T__3) | (1L << T__4) | (1L << T__17) | (1L << T__18) | (1L << T__19) | (1L << T__20) | (1L << T__21) | (1L << T__22) | (1L << ID) | (1L << INT_DATA) | (1L << LBRACE) | (1L << FLOAT_DATA) | (1L << CHAR_DATA) | (1L << STRING_DATA))) != 0)) {
					{
					setState(166);
					expression(0);
					}
				}

				}
				break;
			default:
				throw new NoViableAltException(this);
			}
			setState(171);
			match(T__1);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class Normal_statementContext extends ParserRuleContext {
		public ExpressionContext expression() {
			return getRuleContext(ExpressionContext.class,0);
		}
		public Normal_statementContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_normal_statement; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof MeazzaListener ) ((MeazzaListener)listener).enterNormal_statement(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof MeazzaListener ) ((MeazzaListener)listener).exitNormal_statement(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof MeazzaVisitor ) return ((MeazzaVisitor<? extends T>)visitor).visitNormal_statement(this);
			else return visitor.visitChildren(this);
		}
	}

	public final Normal_statementContext normal_statement() throws RecognitionException {
		Normal_statementContext _localctx = new Normal_statementContext(_ctx, getState());
		enterRule(_localctx, 36, RULE_normal_statement);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(174);
			_la = _input.LA(1);
			if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__2) | (1L << T__3) | (1L << T__4) | (1L << T__17) | (1L << T__18) | (1L << T__19) | (1L << T__20) | (1L << T__21) | (1L << T__22) | (1L << ID) | (1L << INT_DATA) | (1L << LBRACE) | (1L << FLOAT_DATA) | (1L << CHAR_DATA) | (1L << STRING_DATA))) != 0)) {
				{
				setState(173);
				expression(0);
				}
			}

			setState(176);
			match(T__1);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public static class ExpressionContext extends ParserRuleContext {
		public Token uop;
		public Token fop;
		public Token oop;
		public Token op;
		public List<ExpressionContext> expression() {
			return getRuleContexts(ExpressionContext.class);
		}
		public ExpressionContext expression(int i) {
			return getRuleContext(ExpressionContext.class,i);
		}
		public Const_expressionContext const_expression() {
			return getRuleContext(Const_expressionContext.class,0);
		}
		public TerminalNode ID() { return getToken(MeazzaParser.ID, 0); }
		public Type_nameContext type_name() {
			return getRuleContext(Type_nameContext.class,0);
		}
		public List<ArrayContext> array() {
			return getRuleContexts(ArrayContext.class);
		}
		public ArrayContext array(int i) {
			return getRuleContext(ArrayContext.class,i);
		}
		public ExpressionContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_expression; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof MeazzaListener ) ((MeazzaListener)listener).enterExpression(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof MeazzaListener ) ((MeazzaListener)listener).exitExpression(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof MeazzaVisitor ) return ((MeazzaVisitor<? extends T>)visitor).visitExpression(this);
			else return visitor.visitChildren(this);
		}
	}

	public final ExpressionContext expression() throws RecognitionException {
		return expression(0);
	}

	private ExpressionContext expression(int _p) throws RecognitionException {
		ParserRuleContext _parentctx = _ctx;
		int _parentState = getState();
		ExpressionContext _localctx = new ExpressionContext(_ctx, _parentState);
		ExpressionContext _prevctx = _localctx;
		int _startState = 38;
		enterRecursionRule(_localctx, 38, RULE_expression, _p);
		int _la;
		try {
			int _alt;
			enterOuterAlt(_localctx, 1);
			{
			setState(219);
			switch ( getInterpreter().adaptivePredict(_input,23,_ctx) ) {
			case 1:
				{
				setState(179);
				((ExpressionContext)_localctx).uop = _input.LT(1);
				_la = _input.LA(1);
				if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__18) | (1L << T__19) | (1L << T__20))) != 0)) ) {
					((ExpressionContext)_localctx).uop = (Token)_errHandler.recoverInline(this);
				} else {
					consume();
				}
				setState(180);
				expression(14);
				}
				break;
			case 2:
				{
				setState(181);
				((ExpressionContext)_localctx).uop = _input.LT(1);
				_la = _input.LA(1);
				if ( !(_la==T__21 || _la==T__22) ) {
					((ExpressionContext)_localctx).uop = (Token)_errHandler.recoverInline(this);
				} else {
					consume();
				}
				setState(182);
				expression(12);
				}
				break;
			case 3:
				{
				setState(183);
				const_expression();
				}
				break;
			case 4:
				{
				setState(184);
				match(ID);
				}
				break;
			case 5:
				{
				setState(185);
				match(ID);
				setState(186);
				((ExpressionContext)_localctx).fop = match(LBRACE);
				setState(195);
				_la = _input.LA(1);
				if ((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__2) | (1L << T__3) | (1L << T__4) | (1L << T__17) | (1L << T__18) | (1L << T__19) | (1L << T__20) | (1L << T__21) | (1L << T__22) | (1L << ID) | (1L << INT_DATA) | (1L << LBRACE) | (1L << FLOAT_DATA) | (1L << CHAR_DATA) | (1L << STRING_DATA))) != 0)) {
					{
					setState(187);
					expression(0);
					setState(192);
					_errHandler.sync(this);
					_la = _input.LA(1);
					while (_la==T__6) {
						{
						{
						setState(188);
						match(T__6);
						setState(189);
						expression(0);
						}
						}
						setState(194);
						_errHandler.sync(this);
						_la = _input.LA(1);
					}
					}
				}

				setState(197);
				((ExpressionContext)_localctx).fop = match(RBRACE);
				}
				break;
			case 6:
				{
				setState(198);
				((ExpressionContext)_localctx).uop = match(T__17);
				{
				setState(199);
				type_name();
				}
				setState(206);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,21,_ctx);
				while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
					if ( _alt==1 ) {
						{
						{
						setState(200);
						match(LBLOCK);
						setState(201);
						expression(0);
						setState(202);
						match(RBLOCK);
						}
						} 
					}
					setState(208);
					_errHandler.sync(this);
					_alt = getInterpreter().adaptivePredict(_input,21,_ctx);
				}
				setState(212);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,22,_ctx);
				while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
					if ( _alt==1 ) {
						{
						{
						setState(209);
						array();
						}
						} 
					}
					setState(214);
					_errHandler.sync(this);
					_alt = getInterpreter().adaptivePredict(_input,22,_ctx);
				}
				}
				break;
			case 7:
				{
				setState(215);
				((ExpressionContext)_localctx).oop = match(LBRACE);
				setState(216);
				expression(0);
				setState(217);
				match(RBRACE);
				}
				break;
			}
			_ctx.stop = _input.LT(-1);
			setState(270);
			_errHandler.sync(this);
			_alt = getInterpreter().adaptivePredict(_input,26,_ctx);
			while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER ) {
				if ( _alt==1 ) {
					if ( _parseListeners!=null ) triggerExitRuleEvent();
					_prevctx = _localctx;
					{
					setState(268);
					switch ( getInterpreter().adaptivePredict(_input,25,_ctx) ) {
					case 1:
						{
						_localctx = new ExpressionContext(_parentctx, _parentState);
						pushNewRecursionContext(_localctx, _startState, RULE_expression);
						setState(221);
						if (!(precpred(_ctx, 18))) throw new FailedPredicateException(this, "precpred(_ctx, 18)");
						setState(222);
						((ExpressionContext)_localctx).op = match(T__16);
						setState(223);
						expression(19);
						}
						break;
					case 2:
						{
						_localctx = new ExpressionContext(_parentctx, _parentState);
						pushNewRecursionContext(_localctx, _startState, RULE_expression);
						setState(224);
						if (!(precpred(_ctx, 11))) throw new FailedPredicateException(this, "precpred(_ctx, 11)");
						setState(225);
						((ExpressionContext)_localctx).op = _input.LT(1);
						_la = _input.LA(1);
						if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__23) | (1L << T__24) | (1L << T__25))) != 0)) ) {
							((ExpressionContext)_localctx).op = (Token)_errHandler.recoverInline(this);
						} else {
							consume();
						}
						setState(226);
						expression(12);
						}
						break;
					case 3:
						{
						_localctx = new ExpressionContext(_parentctx, _parentState);
						pushNewRecursionContext(_localctx, _startState, RULE_expression);
						setState(227);
						if (!(precpred(_ctx, 10))) throw new FailedPredicateException(this, "precpred(_ctx, 10)");
						setState(228);
						((ExpressionContext)_localctx).op = _input.LT(1);
						_la = _input.LA(1);
						if ( !(_la==T__18 || _la==T__26) ) {
							((ExpressionContext)_localctx).op = (Token)_errHandler.recoverInline(this);
						} else {
							consume();
						}
						setState(229);
						expression(11);
						}
						break;
					case 4:
						{
						_localctx = new ExpressionContext(_parentctx, _parentState);
						pushNewRecursionContext(_localctx, _startState, RULE_expression);
						setState(230);
						if (!(precpred(_ctx, 9))) throw new FailedPredicateException(this, "precpred(_ctx, 9)");
						setState(231);
						((ExpressionContext)_localctx).op = _input.LT(1);
						_la = _input.LA(1);
						if ( !(_la==T__27 || _la==T__28) ) {
							((ExpressionContext)_localctx).op = (Token)_errHandler.recoverInline(this);
						} else {
							consume();
						}
						setState(232);
						expression(10);
						}
						break;
					case 5:
						{
						_localctx = new ExpressionContext(_parentctx, _parentState);
						pushNewRecursionContext(_localctx, _startState, RULE_expression);
						setState(233);
						if (!(precpred(_ctx, 8))) throw new FailedPredicateException(this, "precpred(_ctx, 8)");
						setState(234);
						((ExpressionContext)_localctx).op = _input.LT(1);
						_la = _input.LA(1);
						if ( !((((_la) & ~0x3f) == 0 && ((1L << _la) & ((1L << T__29) | (1L << T__30) | (1L << T__31) | (1L << T__32))) != 0)) ) {
							((ExpressionContext)_localctx).op = (Token)_errHandler.recoverInline(this);
						} else {
							consume();
						}
						setState(235);
						expression(9);
						}
						break;
					case 6:
						{
						_localctx = new ExpressionContext(_parentctx, _parentState);
						pushNewRecursionContext(_localctx, _startState, RULE_expression);
						setState(236);
						if (!(precpred(_ctx, 7))) throw new FailedPredicateException(this, "precpred(_ctx, 7)");
						setState(237);
						((ExpressionContext)_localctx).op = _input.LT(1);
						_la = _input.LA(1);
						if ( !(_la==T__33 || _la==T__34) ) {
							((ExpressionContext)_localctx).op = (Token)_errHandler.recoverInline(this);
						} else {
							consume();
						}
						setState(238);
						expression(8);
						}
						break;
					case 7:
						{
						_localctx = new ExpressionContext(_parentctx, _parentState);
						pushNewRecursionContext(_localctx, _startState, RULE_expression);
						setState(239);
						if (!(precpred(_ctx, 6))) throw new FailedPredicateException(this, "precpred(_ctx, 6)");
						setState(240);
						((ExpressionContext)_localctx).op = match(T__35);
						setState(241);
						expression(7);
						}
						break;
					case 8:
						{
						_localctx = new ExpressionContext(_parentctx, _parentState);
						pushNewRecursionContext(_localctx, _startState, RULE_expression);
						setState(242);
						if (!(precpred(_ctx, 5))) throw new FailedPredicateException(this, "precpred(_ctx, 5)");
						setState(243);
						((ExpressionContext)_localctx).op = match(T__36);
						setState(244);
						expression(6);
						}
						break;
					case 9:
						{
						_localctx = new ExpressionContext(_parentctx, _parentState);
						pushNewRecursionContext(_localctx, _startState, RULE_expression);
						setState(245);
						if (!(precpred(_ctx, 4))) throw new FailedPredicateException(this, "precpred(_ctx, 4)");
						setState(246);
						((ExpressionContext)_localctx).op = match(T__37);
						setState(247);
						expression(5);
						}
						break;
					case 10:
						{
						_localctx = new ExpressionContext(_parentctx, _parentState);
						pushNewRecursionContext(_localctx, _startState, RULE_expression);
						setState(248);
						if (!(precpred(_ctx, 3))) throw new FailedPredicateException(this, "precpred(_ctx, 3)");
						setState(249);
						((ExpressionContext)_localctx).op = match(T__38);
						setState(250);
						expression(4);
						}
						break;
					case 11:
						{
						_localctx = new ExpressionContext(_parentctx, _parentState);
						pushNewRecursionContext(_localctx, _startState, RULE_expression);
						setState(251);
						if (!(precpred(_ctx, 2))) throw new FailedPredicateException(this, "precpred(_ctx, 2)");
						setState(252);
						((ExpressionContext)_localctx).op = match(T__39);
						setState(253);
						expression(3);
						}
						break;
					case 12:
						{
						_localctx = new ExpressionContext(_parentctx, _parentState);
						pushNewRecursionContext(_localctx, _startState, RULE_expression);
						setState(254);
						if (!(precpred(_ctx, 1))) throw new FailedPredicateException(this, "precpred(_ctx, 1)");
						setState(255);
						((ExpressionContext)_localctx).op = match(T__0);
						setState(256);
						expression(1);
						}
						break;
					case 13:
						{
						_localctx = new ExpressionContext(_parentctx, _parentState);
						pushNewRecursionContext(_localctx, _startState, RULE_expression);
						setState(257);
						if (!(precpred(_ctx, 17))) throw new FailedPredicateException(this, "precpred(_ctx, 17)");
						setState(262); 
						_errHandler.sync(this);
						_alt = 1;
						do {
							switch (_alt) {
							case 1:
								{
								{
								setState(258);
								((ExpressionContext)_localctx).op = match(LBLOCK);
								setState(259);
								expression(0);
								setState(260);
								match(RBLOCK);
								}
								}
								break;
							default:
								throw new NoViableAltException(this);
							}
							setState(264); 
							_errHandler.sync(this);
							_alt = getInterpreter().adaptivePredict(_input,24,_ctx);
						} while ( _alt!=2 && _alt!=org.antlr.v4.runtime.atn.ATN.INVALID_ALT_NUMBER );
						}
						break;
					case 14:
						{
						_localctx = new ExpressionContext(_parentctx, _parentState);
						pushNewRecursionContext(_localctx, _startState, RULE_expression);
						setState(266);
						if (!(precpred(_ctx, 13))) throw new FailedPredicateException(this, "precpred(_ctx, 13)");
						setState(267);
						((ExpressionContext)_localctx).uop = _input.LT(1);
						_la = _input.LA(1);
						if ( !(_la==T__21 || _la==T__22) ) {
							((ExpressionContext)_localctx).uop = (Token)_errHandler.recoverInline(this);
						} else {
							consume();
						}
						}
						break;
					}
					} 
				}
				setState(272);
				_errHandler.sync(this);
				_alt = getInterpreter().adaptivePredict(_input,26,_ctx);
			}
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			unrollRecursionContexts(_parentctx);
		}
		return _localctx;
	}

	public static class Class_declarationContext extends ParserRuleContext {
		public TerminalNode ID() { return getToken(MeazzaParser.ID, 0); }
		public List<Raw_declarationContext> raw_declaration() {
			return getRuleContexts(Raw_declarationContext.class);
		}
		public Raw_declarationContext raw_declaration(int i) {
			return getRuleContext(Raw_declarationContext.class,i);
		}
		public Class_declarationContext(ParserRuleContext parent, int invokingState) {
			super(parent, invokingState);
		}
		@Override public int getRuleIndex() { return RULE_class_declaration; }
		@Override
		public void enterRule(ParseTreeListener listener) {
			if ( listener instanceof MeazzaListener ) ((MeazzaListener)listener).enterClass_declaration(this);
		}
		@Override
		public void exitRule(ParseTreeListener listener) {
			if ( listener instanceof MeazzaListener ) ((MeazzaListener)listener).exitClass_declaration(this);
		}
		@Override
		public <T> T accept(ParseTreeVisitor<? extends T> visitor) {
			if ( visitor instanceof MeazzaVisitor ) return ((MeazzaVisitor<? extends T>)visitor).visitClass_declaration(this);
			else return visitor.visitChildren(this);
		}
	}

	public final Class_declarationContext class_declaration() throws RecognitionException {
		Class_declarationContext _localctx = new Class_declarationContext(_ctx, getState());
		enterRule(_localctx, 40, RULE_class_declaration);
		int _la;
		try {
			enterOuterAlt(_localctx, 1);
			{
			setState(273);
			match(CLASS);
			setState(274);
			match(ID);
			setState(275);
			match(T__7);
			setState(279);
			_errHandler.sync(this);
			_la = _input.LA(1);
			while (_la==ID) {
				{
				{
				setState(276);
				raw_declaration();
				}
				}
				setState(281);
				_errHandler.sync(this);
				_la = _input.LA(1);
			}
			setState(282);
			match(T__8);
			}
		}
		catch (RecognitionException re) {
			_localctx.exception = re;
			_errHandler.reportError(this, re);
			_errHandler.recover(this, re);
		}
		finally {
			exitRule();
		}
		return _localctx;
	}

	public boolean sempred(RuleContext _localctx, int ruleIndex, int predIndex) {
		switch (ruleIndex) {
		case 19:
			return expression_sempred((ExpressionContext)_localctx, predIndex);
		}
		return true;
	}
	private boolean expression_sempred(ExpressionContext _localctx, int predIndex) {
		switch (predIndex) {
		case 0:
			return precpred(_ctx, 18);
		case 1:
			return precpred(_ctx, 11);
		case 2:
			return precpred(_ctx, 10);
		case 3:
			return precpred(_ctx, 9);
		case 4:
			return precpred(_ctx, 8);
		case 5:
			return precpred(_ctx, 7);
		case 6:
			return precpred(_ctx, 6);
		case 7:
			return precpred(_ctx, 5);
		case 8:
			return precpred(_ctx, 4);
		case 9:
			return precpred(_ctx, 3);
		case 10:
			return precpred(_ctx, 2);
		case 11:
			return precpred(_ctx, 1);
		case 12:
			return precpred(_ctx, 17);
		case 13:
			return precpred(_ctx, 13);
		}
		return true;
	}

	public static final String _serializedATN =
		"\3\u0430\ud6d1\u8206\uad2d\u4417\uaef1\u8d80\uaadd\3<\u011f\4\2\t\2\4"+
		"\3\t\3\4\4\t\4\4\5\t\5\4\6\t\6\4\7\t\7\4\b\t\b\4\t\t\t\4\n\t\n\4\13\t"+
		"\13\4\f\t\f\4\r\t\r\4\16\t\16\4\17\t\17\4\20\t\20\4\21\t\21\4\22\t\22"+
		"\4\23\t\23\4\24\t\24\4\25\t\25\4\26\t\26\3\2\3\2\3\3\3\3\3\3\3\3\6\3\63"+
		"\n\3\r\3\16\3\64\3\4\3\4\3\5\3\5\3\5\3\5\5\5=\n\5\3\5\3\5\3\6\3\6\3\6"+
		"\3\6\3\7\3\7\7\7G\n\7\f\7\16\7J\13\7\3\b\3\b\3\b\3\t\3\t\3\n\3\n\5\nS"+
		"\n\n\3\n\3\n\3\n\3\n\3\n\3\n\5\n[\n\n\3\13\3\13\5\13_\n\13\3\13\3\13\3"+
		"\13\5\13d\n\13\3\13\3\13\3\13\3\f\3\f\3\f\7\fl\n\f\f\f\16\fo\13\f\3\r"+
		"\3\r\3\r\3\16\3\16\3\16\7\16w\n\16\f\16\16\16z\13\16\3\16\3\16\3\17\3"+
		"\17\3\17\3\17\3\17\3\17\3\17\5\17\u0085\n\17\3\20\3\20\3\20\3\20\3\20"+
		"\3\20\3\20\5\20\u008e\n\20\3\21\3\21\3\21\5\21\u0093\n\21\3\21\3\21\5"+
		"\21\u0097\n\21\3\21\3\21\5\21\u009b\n\21\3\21\3\21\3\21\3\22\3\22\3\22"+
		"\3\22\3\22\3\22\3\23\3\23\3\23\3\23\5\23\u00aa\n\23\5\23\u00ac\n\23\3"+
		"\23\3\23\3\24\5\24\u00b1\n\24\3\24\3\24\3\25\3\25\3\25\3\25\3\25\3\25"+
		"\3\25\3\25\3\25\3\25\3\25\3\25\7\25\u00c1\n\25\f\25\16\25\u00c4\13\25"+
		"\5\25\u00c6\n\25\3\25\3\25\3\25\3\25\3\25\3\25\3\25\7\25\u00cf\n\25\f"+
		"\25\16\25\u00d2\13\25\3\25\7\25\u00d5\n\25\f\25\16\25\u00d8\13\25\3\25"+
		"\3\25\3\25\3\25\5\25\u00de\n\25\3\25\3\25\3\25\3\25\3\25\3\25\3\25\3\25"+
		"\3\25\3\25\3\25\3\25\3\25\3\25\3\25\3\25\3\25\3\25\3\25\3\25\3\25\3\25"+
		"\3\25\3\25\3\25\3\25\3\25\3\25\3\25\3\25\3\25\3\25\3\25\3\25\3\25\3\25"+
		"\3\25\3\25\3\25\3\25\3\25\6\25\u0109\n\25\r\25\16\25\u010a\3\25\3\25\7"+
		"\25\u010f\n\25\f\25\16\25\u0112\13\25\3\26\3\26\3\26\3\26\7\26\u0118\n"+
		"\26\f\26\16\26\u011b\13\26\3\26\3\26\3\26\2\3(\27\2\4\6\b\n\f\16\20\22"+
		"\24\26\30\32\34\36 \"$&(*\2\n\3\29:\3\2\25\27\3\2\30\31\3\2\32\34\4\2"+
		"\25\25\35\35\3\2\36\37\3\2 #\3\2$%\u0143\2,\3\2\2\2\4\62\3\2\2\2\6\66"+
		"\3\2\2\2\b8\3\2\2\2\n@\3\2\2\2\fD\3\2\2\2\16K\3\2\2\2\20N\3\2\2\2\22Z"+
		"\3\2\2\2\24^\3\2\2\2\26h\3\2\2\2\30p\3\2\2\2\32s\3\2\2\2\34\u0084\3\2"+
		"\2\2\36\u0086\3\2\2\2 \u008f\3\2\2\2\"\u009f\3\2\2\2$\u00ab\3\2\2\2&\u00b0"+
		"\3\2\2\2(\u00dd\3\2\2\2*\u0113\3\2\2\2,-\5\4\3\2-\3\3\2\2\2.\63\5\b\5"+
		"\2/\63\5\24\13\2\60\63\5*\26\2\61\63\5\6\4\2\62.\3\2\2\2\62/\3\2\2\2\62"+
		"\60\3\2\2\2\62\61\3\2\2\2\63\64\3\2\2\2\64\62\3\2\2\2\64\65\3\2\2\2\65"+
		"\5\3\2\2\2\66\67\t\2\2\2\67\7\3\2\2\289\5\f\7\29<\7\60\2\2:;\7\3\2\2;"+
		"=\5(\25\2<:\3\2\2\2<=\3\2\2\2=>\3\2\2\2>?\7\4\2\2?\t\3\2\2\2@A\5\f\7\2"+
		"AB\7\60\2\2BC\7\4\2\2C\13\3\2\2\2DH\5\20\t\2EG\5\16\b\2FE\3\2\2\2GJ\3"+
		"\2\2\2HF\3\2\2\2HI\3\2\2\2I\r\3\2\2\2JH\3\2\2\2KL\7\64\2\2LM\7\65\2\2"+
		"M\17\3\2\2\2NO\7\60\2\2O\21\3\2\2\2PR\7\61\2\2QS\7/\2\2RQ\3\2\2\2RS\3"+
		"\2\2\2S[\3\2\2\2T[\7\66\2\2U[\7\5\2\2V[\7\6\2\2W[\7\7\2\2X[\7\67\2\2Y"+
		"[\78\2\2ZP\3\2\2\2ZT\3\2\2\2ZU\3\2\2\2ZV\3\2\2\2ZW\3\2\2\2ZX\3\2\2\2Z"+
		"Y\3\2\2\2[\23\3\2\2\2\\_\5\f\7\2]_\7\b\2\2^\\\3\2\2\2^]\3\2\2\2_`\3\2"+
		"\2\2`a\7\60\2\2ac\7\62\2\2bd\5\26\f\2cb\3\2\2\2cd\3\2\2\2de\3\2\2\2ef"+
		"\7\63\2\2fg\5\32\16\2g\25\3\2\2\2hm\5\30\r\2ij\7\t\2\2jl\5\30\r\2ki\3"+
		"\2\2\2lo\3\2\2\2mk\3\2\2\2mn\3\2\2\2n\27\3\2\2\2om\3\2\2\2pq\5\f\7\2q"+
		"r\7\60\2\2r\31\3\2\2\2sx\7\n\2\2tw\5\34\17\2uw\5\b\5\2vt\3\2\2\2vu\3\2"+
		"\2\2wz\3\2\2\2xv\3\2\2\2xy\3\2\2\2y{\3\2\2\2zx\3\2\2\2{|\7\13\2\2|\33"+
		"\3\2\2\2}\u0085\5\32\16\2~\u0085\5\b\5\2\177\u0085\5\36\20\2\u0080\u0085"+
		"\5 \21\2\u0081\u0085\5\"\22\2\u0082\u0085\5$\23\2\u0083\u0085\5&\24\2"+
		"\u0084}\3\2\2\2\u0084~\3\2\2\2\u0084\177\3\2\2\2\u0084\u0080\3\2\2\2\u0084"+
		"\u0081\3\2\2\2\u0084\u0082\3\2\2\2\u0084\u0083\3\2\2\2\u0085\35\3\2\2"+
		"\2\u0086\u0087\7\f\2\2\u0087\u0088\7\62\2\2\u0088\u0089\5(\25\2\u0089"+
		"\u008a\7\63\2\2\u008a\u008d\5\34\17\2\u008b\u008c\7\r\2\2\u008c\u008e"+
		"\5\34\17\2\u008d\u008b\3\2\2\2\u008d\u008e\3\2\2\2\u008e\37\3\2\2\2\u008f"+
		"\u0090\7\16\2\2\u0090\u0092\7\62\2\2\u0091\u0093\5(\25\2\u0092\u0091\3"+
		"\2\2\2\u0092\u0093\3\2\2\2\u0093\u0094\3\2\2\2\u0094\u0096\7\4\2\2\u0095"+
		"\u0097\5(\25\2\u0096\u0095\3\2\2\2\u0096\u0097\3\2\2\2\u0097\u0098\3\2"+
		"\2\2\u0098\u009a\7\4\2\2\u0099\u009b\5(\25\2\u009a\u0099\3\2\2\2\u009a"+
		"\u009b\3\2\2\2\u009b\u009c\3\2\2\2\u009c\u009d\7\63\2\2\u009d\u009e\5"+
		"\34\17\2\u009e!\3\2\2\2\u009f\u00a0\7\17\2\2\u00a0\u00a1\7\62\2\2\u00a1"+
		"\u00a2\5(\25\2\u00a2\u00a3\7\63\2\2\u00a3\u00a4\5\34\17\2\u00a4#\3\2\2"+
		"\2\u00a5\u00ac\7\20\2\2\u00a6\u00ac\7\21\2\2\u00a7\u00a9\7\22\2\2\u00a8"+
		"\u00aa\5(\25\2\u00a9\u00a8\3\2\2\2\u00a9\u00aa\3\2\2\2\u00aa\u00ac\3\2"+
		"\2\2\u00ab\u00a5\3\2\2\2\u00ab\u00a6\3\2\2\2\u00ab\u00a7\3\2\2\2\u00ac"+
		"\u00ad\3\2\2\2\u00ad\u00ae\7\4\2\2\u00ae%\3\2\2\2\u00af\u00b1\5(\25\2"+
		"\u00b0\u00af\3\2\2\2\u00b0\u00b1\3\2\2\2\u00b1\u00b2\3\2\2\2\u00b2\u00b3"+
		"\7\4\2\2\u00b3\'\3\2\2\2\u00b4\u00b5\b\25\1\2\u00b5\u00b6\t\3\2\2\u00b6"+
		"\u00de\5(\25\20\u00b7\u00b8\t\4\2\2\u00b8\u00de\5(\25\16\u00b9\u00de\5"+
		"\22\n\2\u00ba\u00de\7\60\2\2\u00bb\u00bc\7\60\2\2\u00bc\u00c5\7\62\2\2"+
		"\u00bd\u00c2\5(\25\2\u00be\u00bf\7\t\2\2\u00bf\u00c1\5(\25\2\u00c0\u00be"+
		"\3\2\2\2\u00c1\u00c4\3\2\2\2\u00c2\u00c0\3\2\2\2\u00c2\u00c3\3\2\2\2\u00c3"+
		"\u00c6\3\2\2\2\u00c4\u00c2\3\2\2\2\u00c5\u00bd\3\2\2\2\u00c5\u00c6\3\2"+
		"\2\2\u00c6\u00c7\3\2\2\2\u00c7\u00de\7\63\2\2\u00c8\u00c9\7\24\2\2\u00c9"+
		"\u00d0\5\20\t\2\u00ca\u00cb\7\64\2\2\u00cb\u00cc\5(\25\2\u00cc\u00cd\7"+
		"\65\2\2\u00cd\u00cf\3\2\2\2\u00ce\u00ca\3\2\2\2\u00cf\u00d2\3\2\2\2\u00d0"+
		"\u00ce\3\2\2\2\u00d0\u00d1\3\2\2\2\u00d1\u00d6\3\2\2\2\u00d2\u00d0\3\2"+
		"\2\2\u00d3\u00d5\5\16\b\2\u00d4\u00d3\3\2\2\2\u00d5\u00d8\3\2\2\2\u00d6"+
		"\u00d4\3\2\2\2\u00d6\u00d7\3\2\2\2\u00d7\u00de\3\2\2\2\u00d8\u00d6\3\2"+
		"\2\2\u00d9\u00da\7\62\2\2\u00da\u00db\5(\25\2\u00db\u00dc\7\63\2\2\u00dc"+
		"\u00de\3\2\2\2\u00dd\u00b4\3\2\2\2\u00dd\u00b7\3\2\2\2\u00dd\u00b9\3\2"+
		"\2\2\u00dd\u00ba\3\2\2\2\u00dd\u00bb\3\2\2\2\u00dd\u00c8\3\2\2\2\u00dd"+
		"\u00d9\3\2\2\2\u00de\u0110\3\2\2\2\u00df\u00e0\f\24\2\2\u00e0\u00e1\7"+
		"\23\2\2\u00e1\u010f\5(\25\25\u00e2\u00e3\f\r\2\2\u00e3\u00e4\t\5\2\2\u00e4"+
		"\u010f\5(\25\16\u00e5\u00e6\f\f\2\2\u00e6\u00e7\t\6\2\2\u00e7\u010f\5"+
		"(\25\r\u00e8\u00e9\f\13\2\2\u00e9\u00ea\t\7\2\2\u00ea\u010f\5(\25\f\u00eb"+
		"\u00ec\f\n\2\2\u00ec\u00ed\t\b\2\2\u00ed\u010f\5(\25\13\u00ee\u00ef\f"+
		"\t\2\2\u00ef\u00f0\t\t\2\2\u00f0\u010f\5(\25\n\u00f1\u00f2\f\b\2\2\u00f2"+
		"\u00f3\7&\2\2\u00f3\u010f\5(\25\t\u00f4\u00f5\f\7\2\2\u00f5\u00f6\7\'"+
		"\2\2\u00f6\u010f\5(\25\b\u00f7\u00f8\f\6\2\2\u00f8\u00f9\7(\2\2\u00f9"+
		"\u010f\5(\25\7\u00fa\u00fb\f\5\2\2\u00fb\u00fc\7)\2\2\u00fc\u010f\5(\25"+
		"\6\u00fd\u00fe\f\4\2\2\u00fe\u00ff\7*\2\2\u00ff\u010f\5(\25\5\u0100\u0101"+
		"\f\3\2\2\u0101\u0102\7\3\2\2\u0102\u010f\5(\25\3\u0103\u0108\f\23\2\2"+
		"\u0104\u0105\7\64\2\2\u0105\u0106\5(\25\2\u0106\u0107\7\65\2\2\u0107\u0109"+
		"\3\2\2\2\u0108\u0104\3\2\2\2\u0109\u010a\3\2\2\2\u010a\u0108\3\2\2\2\u010a"+
		"\u010b\3\2\2\2\u010b\u010f\3\2\2\2\u010c\u010d\f\17\2\2\u010d\u010f\t"+
		"\4\2\2\u010e\u00df\3\2\2\2\u010e\u00e2\3\2\2\2\u010e\u00e5\3\2\2\2\u010e"+
		"\u00e8\3\2\2\2\u010e\u00eb\3\2\2\2\u010e\u00ee\3\2\2\2\u010e\u00f1\3\2"+
		"\2\2\u010e\u00f4\3\2\2\2\u010e\u00f7\3\2\2\2\u010e\u00fa\3\2\2\2\u010e"+
		"\u00fd\3\2\2\2\u010e\u0100\3\2\2\2\u010e\u0103\3\2\2\2\u010e\u010c\3\2"+
		"\2\2\u010f\u0112\3\2\2\2\u0110\u010e\3\2\2\2\u0110\u0111\3\2\2\2\u0111"+
		")\3\2\2\2\u0112\u0110\3\2\2\2\u0113\u0114\7-\2\2\u0114\u0115\7\60\2\2"+
		"\u0115\u0119\7\n\2\2\u0116\u0118\5\n\6\2\u0117\u0116\3\2\2\2\u0118\u011b"+
		"\3\2\2\2\u0119\u0117\3\2\2\2\u0119\u011a\3\2\2\2\u011a\u011c\3\2\2\2\u011b"+
		"\u0119\3\2\2\2\u011c\u011d\7\13\2\2\u011d+\3\2\2\2\36\62\64<HRZ^cmvx\u0084"+
		"\u008d\u0092\u0096\u009a\u00a9\u00ab\u00b0\u00c2\u00c5\u00d0\u00d6\u00dd"+
		"\u010a\u010e\u0110\u0119";
	public static final ATN _ATN =
		new ATNDeserializer().deserialize(_serializedATN.toCharArray());
	static {
		_decisionToDFA = new DFA[_ATN.getNumberOfDecisions()];
		for (int i = 0; i < _ATN.getNumberOfDecisions(); i++) {
			_decisionToDFA[i] = new DFA(_ATN.getDecisionState(i), i);
		}
	}
}