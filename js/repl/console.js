var Console = function() {
    this.consoleInputID = "#consoleInput";
    this.setup = function () { /* Do nothing for now */ };
    this.savedText = "";

    this.appendLog = function(text, className) {
        var newDiv = document.createElement('div');
        newDiv.setAttribute('class', className);
        newDiv.innerText = text;
        var consoleLog = $('#consoleLog');
        consoleLog.append(newDiv);
    }

    this.submit = function () {
        var textArea = $('#consoleInput');
        var text = textArea.val();
        this.appendLog(text, 'consolePastInput');
        textArea.val("");
        parse.lexer = new Lex();
        var ast = parse.parse(text);

        if(ast == null) {
            this.savedText += text;
        }
        else {
            this.savedText = "";
            this.appendLog(Lang.astToString(ast), 'consoleResult');
        }
    };
};

var term = new Console();
term.setup();
