all: 
	bison -d exvar.y
	flex exvar.l
	g++ exvar.tab.c lex.yy.c -o exvar