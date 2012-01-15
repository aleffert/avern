%non SBIND
%non SEXP
%left PLUS MINUS
%left '*' '/'
%left '^'
%left UMINUS
%left APP

%start program

%%
program
    : stmts EOF {
       return $stmts;
    };

stmts : rstmts { $$ = List.reverse($rstmts); };
rstmts : rstmts TERM stmt {
        $$ = Cons($stmt, $rstmts)
    }
    | stmt {
        $$ = Cons($stmt, Nil);
    };
stmt
    : cexp %prec SEXP {$$ = Lang.SExp($cexp); }
    | idents IS cexp %prec SBIND {$$ = Lang.SBind($idents, $cexp);}
    ;

cexp 
    : IF cexp THEN cexp ELSE cexp {
        $$ = Lang.EIf($cexp1, $cexp2, $cexp3);
    }
    | OPEN stmts CLOSE {
        $$ = Lang.EStmts($stmts);
    }
    | exp {
        $$ = $exp;
    }
;
exp
    : exp PLUS exp {
        $$ = Lang.EBinOp($exp1, '+', $exp2);
    }
    | exp MINUS exp {
        $$ = Lang.EBinOp($exp1, '-', $exp2);
    }
    | app %prec APP {
        $$ = $app;
    }
    | idents {
        $$ = Case($idents, 
            function () {
                throw "Somehow got empty ident list";
            },
            function (x, xs) {
                var ex = new Lang.EEVar($x);
                return Case(xs,
                    function () {
                        return ex;
                    },
                    function (y, ys) {
                        return List.foldl(xs, ex, function (x, acc) {
                            return Lang.EApp(acc, Lang.EEVar(x));
                        });
                });
            }
        );
        $$ = List.foldl($idents, Nil, function (x, acc) {
            return Lang.EApp(acc, x)
        });
        $$ = Lang.EEVar($idents);
    }
    
;

app : app atom %prec APP {
        $$ = Lang.EApp($app, $atom);
    }
    | atom {
        $$ = $atom;
    }
;
atom
    : LPAREN cexp RPAREN {
        $$ = $cexp;
    }
    | MINUS atom %prec UMINUS {
        $$ = Lang.EUnOp('-', $atom);
    }
    | NUM {
        $$ = Lang.ENumConst(yy.lexer.yytext);
    }
;

idents : ridents {
    $$ = List.reverse($ridents);
};

ridents
    : ridents ident {
        $$ = Cons($ident, $ridents);
    }
    | ident {
        $$ = Cons($ident, Nil);
    }
    ;

ident : IDENT { $$ = yy.lexer.yytext; };
