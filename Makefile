CC=gcc
INCLUDES=-I/usr/local/include
LIBDIRS=-L/usr/local/lib
CFLAGS=-std=c99 -D_POSIX_C_SOURCE=2 -D_BSD_SOURCE -D_FILE_OFFSET_BITS=64 -O2 -Wall -g $(INCLUDES)
LIB=
LEX=flex
YACC=yacc

SRC=string_clear.c string_concatb.c string_concat.c string_concat_sprintf.c string_equals.c string_free.c string_get.c string_init.c string_initfromstringz.c string_lazyinit.c string_move.c string_putc.c string_putint.c
OBJ=$(patsubst %.c,%.o,$(SRC))

NAME = bstring

$(NAME): test.o $(OBJ)
	$(CC) -o $@ test.o $(OBJ) $(LIB) $(LIBDIRS)

%.o: %.c
	$(CC) $(CFLAGS) -o $(patsubst %.c,%.o,$<) -c $<

lex.yy.o: lex.yy.c y.tab.h

clean:
	rm -f *.o y.tab.c y.tab.h lex.yy.c string/*.o $(NAME)

splint:
	splint +posixlib +allglobals -type -mayaliasunique -predboolint \
		-retvalint $(CFLAGS) main.c $(SRC)
