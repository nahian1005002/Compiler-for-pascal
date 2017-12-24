flex a.lex
bison -dy a.y
gcc lex.yy.c y.tab.c -o hello.exe