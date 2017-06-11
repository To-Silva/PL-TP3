CC = gcc
CFLAGS = -Wall -lm
DEPS = $(wildcard *.h)
OBJ := $(patsubst %.c,%.o,$(filter-out lex.yy.c y.tab.c,$(wildcard *.c)))

all: $(OBJ) dep
	gcc $(CFLAGS) -o tp3 $(OBJ) y.tab.c


dep:
		flex tp3.fl
		yacc tp3.y

%.o: %.c $(DEPS)


clean:
	rm y.tab.c lex.yy.c tp3 *.o
