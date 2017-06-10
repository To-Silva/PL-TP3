tp3: tp3.fl tp3.y
	flex tp3.fl
	yacc tp3.y
	cc -o tp3 y.tab.c
