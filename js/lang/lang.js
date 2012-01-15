var Lang = {};

// d    = x is e

// e    = e e | e binop e | let x = e; e | n
//      | fun xs -> e

Lang.DLet = function(x, e) {
    this.x = x;
    this.e = e;
    this.tag = 'DLet';
}

Lang.EApp = function(e1, e2) {
    this.e1 = e1;
    this.e2 = e2;
    this.tag = 'EApp';
}

Lang.EBinOp = function(e1, op, e2) {
    this.e1 = e1;
    this.e2 = e2;
    this.op = op;
    this.tag = 'EBinOp';
};

Lang.EEVar = function(x) {
    this.x = x;
    this.tag = 'EVar';
}

Lang.EUnOp = function(op, e) {
    this.op = op;
    this.e = e;
    this.tag = 'EUnOp';
};

Lang.ENumConst = function(value) {
    this.value = value;
    this.tag = 'ENumConst';
};

Lang.ELet = function(x, e1, e2) {
    this.x = x;
    this.e1 = e1;
    this.e2 = e2;
    this.tag = 'ELet';
}

Lang.EFun = function(args, e) {
    this.args = args;
    this.e = e;
    this.tag = 'EFun';
}

Lang.EStmts = function(stmts) {
    this.stmts = stmts;
    this.tag = 'EStmts';
}

Lang.SExp = function(e) {
    this.e = e;
    this.tag = 'SExp';
}

Lang.SBind = function(xs, e) {
    this.xs = xs;
    this.e = e;
    this.tag = 'SBind';
}


Lang.astToString = function(ast) {
    if(ast instanceof String || typeof(ast) == 'string') {
        return ast;
    }
    else if(ast instanceof Number || typeof(ast) == 'number') {
        return ast;
    }
    else {
        var result = "{";
        $.each(ast, function(key, value) {
            result = result + key + " = " + Lang.astToString(value) + ", ";
        });
        result += "}";
        return result;
   }
}
