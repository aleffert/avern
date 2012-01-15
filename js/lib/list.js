var Cons = function (x, xs) {
    return {head : x, tail : xs};
};
var Nil = {};

var Case = function(x, nilFunc, constFunc) {
    if(x == Nil) {
        return nilFunc();
    }
    else {
        return constFunc(x.head, x.tail);
    }
}

var List = {
    reverse : function (l) {
        return (function rever (ls, acc) {
            return Case(ls,
                function () { return acc; },
                function (x, xs) { return rever(xs, Cons(x, acc)); });
        }(l, Nil));
    },
    foldl : function (f, acc, xs) {
        return Case(xs,
            function () { return acc; },
            function (x, xs) {
                return List.foldl(f, f(x), xs);
            }
        );
    }
};
