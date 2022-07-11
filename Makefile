evaluate : expression.cmx env.cmx interpreter.cmx parser.cmx lexer.cmx evaluate.cmx
	ocamlfind ocamlopt -linkpkg -package unix -o evaluate expression.cmx env.cmx interpreter.cmx parser.cmx lexer.cmx evaluate.cmx 

expression.cmi: expression.mli
	ocamlopt -c expression.mli

expression.cmx: expression.ml expression.cmi
	ocamlopt -c expression.ml

env.cmi: env.mli expression.cmi
	ocamlopt -c env.mli

env.cmx: env.ml env.cmi expression.cmi
	ocamlopt -c env.ml

interpreter.cmi : interpreter.mli expression.cmi env.cmi
	ocamlopt -c interpreter.mli

interpreter.cmx : interpreter.cmi interpreter.ml expression.cmi env.cmi
	ocamlopt -c interpreter.ml

parser.ml : parser.mly
	ocamlyacc parser.mly

parser.mli : parser.mly
	ocamlyacc parser.mly

lexer.ml : lexer.mll parser.mli
	ocamllex lexer.mll

parser.cmx : parser.cmi parser.ml
	ocamlopt -c parser.ml

parser.cmi : parser.mli
	ocamlopt -c parser.mli

lexer.cmx : parser.cmi lexer.ml
	ocamlopt -c lexer.ml

evaluate.cmx : parser.cmi lexer.cmx interpreter.cmi evaluate.ml
	ocamlopt -c evaluate.ml

clean:
	rm *.cmx *.cmi *.o evaluate lexer.ml parser.ml parser.mli
