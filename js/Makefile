all: lang/parse.js lang/tokenize.js

lang/parse.js: lang/parse.jison
	jison lang/parse.jison -o lang/parse.js
lang/tokenize.js: lang/tokenize.pegjs
	node_modules/pegjs/bin/pegjs --export-var Tokenize lang/tokenize.pegjs

clean:
	find . -name "*~" -exec rm -f {} \;
	rm -f lang/parse.js
	rm -f lang/tokenize.js
