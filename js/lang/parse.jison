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
    : cexp %prec SEXP {$$ = new Lang.SExp($cexp); }
    | idents IS cexp %prec SBIND {$$ = new Lang.SBind($idents, $cexp);}
    ;

cexp 
    : IF cexp THEN cexp ELSE cexp {
        $$ = new Lang.EIf($cexp1, $cexp2, $cexp3);
    }
    | OPEN stmts CLOSE {
        $$ = new Lang.EStmts($stmts);
    }
    | exp {
        $$ = $exp;
    }
;
exp
    : exp PLUS exp {
        $$ = new Lang.EBinOp($exp1, '+', $exp2);
    }
    | exp MINUS exp {
        $$ = new Lang.EBinOp($exp1, '-', $exp2);
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
                            return new Lang.EApp(acc, new Lang.EEVar(x));
                        });
                });
            }
        );
    }
    
;

app : app atom %prec APP {
        $$ = new Lang.EApp($app, $atom);
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
        $$ = new Lang.EUnOp('-', $atom);
    }
    | NUM {
        $$ = new Lang.ENumConst(yytext);
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

ident : IDENT { $$ = yytext; };
