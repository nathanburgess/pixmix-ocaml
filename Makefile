OBJS = ast.cmx codegen.cmx parser.cmx pixmix.cmx sast.cmx scanner.cmx semant.cmx
DEBUG = -g

# Color Definitions
clrClear = \033[0m
clrBlue  = \033[1;34m
clrPurple= \033[1;35m
clrGreen = \033[1;32m
clrRed   = \033[31;01m
clrYellow= \033[33;01m


default: pixmix.native

.PHONY : pixmix.native
pixmix.native :
	@rm lib/utils.bc parser.ml parser.mli | true
	ocamlbuild -use-ocamlfind -pkgs llvm,llvm.analysis,llvm.linker,llvm.bitreader,llvm.irreader -cflags -w,+a-4 pixmix.native
	clang -emit-llvm -o lib/utils.bc -c lib/utils.c -Wno-varargs

pixmix: $(OBJS)
	ocamlfind ocamlopt -linkpkg -package llvm -package llvm.analysis $(OBJS) -o pixmix

scanner.ml : scanner.mll
	ocamllex scanner.mll

parser.ml parser.mli : parser.mly
	ocamlyacc parser.mly

%.cmo : %.ml
	ocamlc -c $(DEBUG) $<

%.cmi : %.mli
	ocamlc -c $(DEBUG) $<

%.cmx : %.ml
	ocamlfind ocamlopt -c -package llvm $<

.PHONY : clean
clean :
	ocamlbuild -clean | true
	rm -f pixmix.native
	rm -f lib/utils.bc
	rm -f *.cmx *.cmi *.cmo *.cmx *.o* *.ll *.exe
	rm -f pixmix parser.ml parser.mli scanner.ml *.cmo *.cmi

# Generate a parser.output file with all states from the parser
.PHONY : debug
debug:
	@make
	OCAMLRUNPARAM='p' ocamlyacc -v parser.mly

# Run the testing suite
.PHONY : tests
tests :
	@make
	@./testall.sh

# Run just a single test on the file test.pm in the project root
.PHONY : test
test :
	@make
	@make runtest

.PHONY : runtest
runtest :
	@clang -emit-llvm -o lib/utils.bc -c lib/utils.c -Wno-everything
	@./pixmix.native test.pm > test.ll
	@clang -Wno-override-module lib/utils.bc test.ll -o test.exe -lm
	@./test.exe
	@rm test.ll
	@rm test.exe

# Run the same test as the test rule, but print out the AST
.PHONY : testast
testast :
	@make
	@clang -emit-llvm -o lib/utils.bc -c lib/utils.c -Wno-everything
	@./pixmix.native test.pm -a

# Run the same test as the test rule, but print out the SAST
.PHONY : testsast
testsast :
	@make
	@clang -emit-llvm -o lib/utils.bc -c lib/utils.c -Wno-everything
	@./pixmix.native test.pm -s

# Run the same test as the test rule, but print out the LLVM IR code
.PHONY : testlli
testlli :
	@make
	@clang -emit-llvm -o lib/utils.bc -c lib/utils.c -Wno-everything
	@./pixmix.native test.pm

# Run the same test as the test rule, but print out the AST, SAST, and LLVM IR code
.PHONY : testasl
testasl :
	@make
	@clang -emit-llvm -o lib/utils.bc -c lib/utils.c -Wno-everything
	@echo "\n$(clrGreen)--==[ $(clrBlue)Printing the $(clrPurple)AST$(clrBlue)... $(clrGreen)]==--$(clrClear)"
	@./pixmix.native test.pm -a
	@echo "\n$(clrGreen)--==[ $(clrBlue)Printing the $(clrPurple)SAST$(clrBlue)... $(clrGreen)]==--$(clrClear)"
	@./pixmix.native test.pm -s
	@echo "\n$(clrGreen)--==[ $(clrBlue)Printing the $(clrPurple)LLVM IR$(clrBlue)... $(clrGreen)]==--$(clrClear)"
	@./pixmix.native test.pm
	@echo "\n$(clrGreen)--==[ $(clrBlue)Printing $(clrPurple)output$(clrBlue) from running the program... $(clrGreen)]==--$(clrClear)"
	@make runtest

# Run the same test as the test rule and print out the state transition table along with it
.PHONY : debugtest
debugtest :
	@make
	@OCAMLRUNPARAM='p' make test

# Generated by "ocamldep *.ml *.mli" after building scanner.ml and parser.ml
ast.cmo :
ast.cmx :
codegen.cmo : sast.cmo
codegen.cmx : sast.cmx
pixmix.cmo : semant.cmo sast.cmo codegen.cmo ast.cmo
pixmix.cmx : semant.cmx sast.cmx codegen.cmx ast.cmx
sast.cmo : ast.cmo
sast.cmx : ast.cmx
semant.cmo : sast.cmo
semant.cmx : sast.cmx