start = line

line = ws:(' '*) tokens:tokens { return Cons(WS(ws.length),tokens); }
    / "\n" line:line {return line;}

tokens = ' ' ts:tokens {return ts; }
    / !keyword i:ident ts:tokens {return Cons(i, ts); }
    / k:keyword ts:tokens {return Cons(k,ts); }
    / n:number ts:tokens {return Cons(n, ts); }
    / '{' ts:tokens {return Cons(OPEN,ts); }
    / '}' ts:tokens {return Cons(CLOSE,ts); }
    / ';' ts:tokens {return Cons(TERM,ts); }
    / '-' ts:tokens {return Cons(MINUS,ts); }
    / '+' ts:tokens {return Cons(PLUS,ts); }
    / '(' ts:tokens {return Cons(LPAREN,ts); }
    / ')' ts:tokens {return Cons(RPAREN,ts); }
    / '\\\n' ts:tokens {return ts; }
    / '\n' ts:line {return ts; }
    / {return Nil};

ident = !keyword i:([a-zA-Z]) is:(identPart*) {return IDENT(i.concat(is.join("")))};

number = n:([0-9]+) {return NUM(n.join("")); }

identPart = p:([a-zA-Z0-9_]) {return p};

keyword = 'fun' !identPart{ return FUN; }
    / 'in' !identPart {return IN; }
    / 'do' !identPart {return DO; }
    / 'is' !identPart {return IS; }
    / 'if' !identPart {return IF; }
    / 'then' !identPart {return THEN; }
    / 'else' !identPart {return ELSE; }
    / 'for' !identPart {return FOR; }
