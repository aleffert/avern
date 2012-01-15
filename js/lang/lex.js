var Lex = function () {
    return this;
}

Lex.prototype.setInput = function (string) {
    this.tokens = this.processLexemes(Tokenize.parse(string));
};

Lex.prototype.lex = function () {
    var owner = this;
    return Case(this.tokens, function () {
        return "EOF";
    }, function (t, ts) {
        owner.tokens = ts;
        if('value' in t) {
            owner.yytext = t.value;
            return t.token.tag;
        }
        else {
            owner.yytext = null;
            return t.tag;
        }
    });
};
Lex.prototype.processLexemes = function (tokens) {
    return (function f(tokens, stack) {
        return Case(tokens, function () {
            return Case(stack, function() {
                return Nil;
            }, function(w, ws) {
                if(w.size == 0) {
                    throw "ParseError";
                }
                else {
                    return Cons(CLOSE, f(Nil, ws));
                }
                return Nil;
            });
        }, function (t, ts) {
            if(t.tag == WST) {
                var n = t.size;
                return Case(stack, function () {
                    return Cons(OPEN, f(ts, Cons(n, Nil)));
                }, function(w, ws) {
                    if(n == w) {
                        return Cons(TERM, f(ts, Cons(w, ws)));
                    }
                    else if(n < w) {
                        return Cons(CLOSE, f(ts, ws));
                    }
                    else {
                        return Cons(OPEN, f(ts, Cons(n, stack)));
                    }
                });
            }
            else if(t.tag == OPEN) {
                return Cons(OPEN, f(ts, Cons(0, ws)));
            }
            else if(t.tag == CLOSE) {
                return Case(stack, function () {
                    throw "Parse Error";
                }, function (w, ws) {
                    if(w == 0) {
                        return Cons(CLOSE, f(ts, ws));
                    }
                    else {
                        throw "Parse Error";
                    }
                });
            }
            else {
                return Cons(t, f(ts, stack))
            }
        });
    }(tokens, Nil));
}

function Token(t) {
    return {tag : t};
};

var WST = new Token('ws');

function WS (n) {
    return {tag : WST, size : n};
};

var IDENTT = new Token('IDENT');
function IDENT(i) {
    return {token : IDENTT, value : i};
}

var NUMT = new Token('NUM');
function NUM(n) {
    return {token : NUMT, value : n};
}

var OPEN = new Token('OPEN');
var CLOSE = new Token('CLOSE');
var TERM = new Token('TERM');
var FUN = new Token('FUN');
var IN = new Token('IN');
var IS = new Token('IS');
var DO = new Token('DO');
var IF = new Token('IF');
var THEN = new Token('THEN');
var ELSE = new Token('ELSE');
var FOR = new Token('FOR');

