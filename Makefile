CC = gcc
CFLAGS = -Wall -lm
DEPS = $(wildcard *.h)
COMP := $(filter-out lex.yy.c y.tab.c,$(wildcard *.c))
OBJ := $(patsubst %.c,%.o,$(filter-out lex.yy.c y.tab.c,$(wildcard *.c)))
TEST := $(patsubst %.banan,%.vm,$(wildcard ./testes/*.banan))
EXEP := $(filter-out ./testes/multiplicaArray.vm ./testes/soma2numLidos.vm ./testes/somaArray.vm ./testes/restoDivisao.vm ./testes/maior2numLidos.vm,$(wildcard ./testes/*.vm))

all: main

main: $(OBJ) dep
	gcc $(CFLAGS) -o tp3 $(OBJ) y.tab.c

debug: $(OBJ) dep
	gcc $(CFLAGS) -g -o tp3 $(COMP) y.tab.c

dep:
		flex tp3.fl
		yacc tp3.y

%.o: %.c $(DEPS)

testes: main $(TEST)

%.vm: %.banan
	./tp3 $@ < $<

clean:
	rm y.tab.c lex.yy.c tp3 *.o

cleantests:
	rm $(EXEP)
