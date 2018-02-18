# See https://github.com/ocaml/ocamlbuild/blob/master/examples/
DOCDIR = doc/ocspbt.docdir
.PHONY: all clean byte native profile debug

OCB_FLAGS = -use-ocamlfind
OCB = ocamlbuild

all: native byte

clean:
	$(OCB) -clean

native:
	$(OCB) $(OCB_FLAGS) main.native

byte:
	$(OCB) $(OCB_FLAGS) main.byte

profile:
	$(OCB) $(OCB_FLAGS) -tag profile main.native

debug:
	$(OCB) $(OCB_FLAGS) -tag debug main.byte

doc_html:
	$(OCB) $(OCB_FLAGS) $(DOCDIR)/index.html

doc_man:
	$(OCB) $(OCB_FLAGS) $(DOCDIR)/ocspbt.man

doc_tex:
	$(OCB) $(OCB_FLAGS) $(DOCDIR)/ocspbt.tex

doc_texinfo:
	$(OCB) $(OCB_FLAGS) $(DOCDIR)/ocspbt.texi

doc_dot:
	$(OCB) $(OCB_FLAGS) $(DOCDIR)/ocspbt.dot

tags:
	ctags src/*.ml src/*.mli Makefile
