FLAGS = -no-pie -g 

all:
	as meuAlocador.s -o meuAlocador.o
	gcc avalia.c meuAlocador.o $(FLAGS)

clean:
	rm -f meuAlocador.o a.out
