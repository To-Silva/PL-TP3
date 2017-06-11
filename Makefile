CC = gcc
CFLAGS = -Wall -lm
DEPS = $(wildcard *.h)
OBJ = $(patsubst %.c,%.o,$(wildcard *.c))

all: $(OBJ)
	gcc $(CFLAGS) -o tp3 $^ y.tab.c


y.tab.c:
	yacc tp3.y

lex.yy.c:
	flex tp3.fl

%.o: %.c $(DEPS) lex.yy.c y.tab.c
	$(CC) $(CFLAGS) -c -o $@ $<


clean:
	rm y.tab.c lex.yy.c tp3 *.o
