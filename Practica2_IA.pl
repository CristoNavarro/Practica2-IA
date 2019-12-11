%Posibles orillas, sobre estas listas permutaremos
%para calcular todas las posibles orillas que se pueden dar.
orilla([]).
orilla([pastor,lobo,oveja,col]).
orilla([lobo,col]).
orilla([pastor,lobo,col]).
orilla([col]).
orilla([pastor,oveja,col]).
orilla([oveja]).
orilla([pastor,oveja]).
orilla([pastor,lobo,oveja]).
orilla([lobo]).

%Invierte el orden de los elementos de la lista que le pasemos.
invierte([],[]).
invierte([H|T],L):- invierte(T,R), append(R,[H],L).

%Extrae el elemento X de la lista que le pasemos
extraer(X,[X|T],T).
extraer(X,[A|T],[A|R]):-extraer(X,T,R).

%Inserta por la cabeza de la lista Y el elemento X que le pasemos.
insertar_delante(X,Y,[X|Y]).

%Intercambia los elementos de la lista que le pasemos para generar
%todas las posibles ordenaciones que existen con sus elementos
%Es decir, para prolog no es lo mismo
%[lobo,col] que [col,lobo] por eso necesitamos reglas 
%que permuten los elementos de la lista.
permutacion([],[]).
permutacion([X|T],Y):-extraer(X,Y,Z), permutacion(T,Z).

%Comprueba que X es una orilla de las anteriormente declaradas
%ó si es una permutación de estas.
comprobar_orilla(X):- permutacion(Y,X), orilla(Y).

%Comprueba que la combinación de las dos orillas que forman 
%un estado están correctas. Esto es que ninguna se salta 
%las reglas del juego, ni en conjunto ni en separado.
comprobar_estado([X,Y],A):-
    comprobar_orilla(X),
    comprobar_orilla(Y),
    not(miembro([X,Y],A)).

%Comprueba si el estado que le pasemos está dentro del acumulador
%o sea, que ya ha sido visitado con anterioridad.
miembro([X,Y],A):-
    permutacion(B,X),
    member([B,_],A),
    permutacion(C,Y),
    member([B,C],A).

%Trata de mover el pastor de un lado a otro de la orilla, intenta
%llevar con él algún acompañante pero si no está permitido se moverá
%él solo.
mover_pastor([X,Y],A,R):- 
    extraer(pastor,X,T),
    insertar_delante(pastor,Y,C),
    mover_izq([T,C],A,R).

mover_pastor([X,Y],A,R):- 
    extraer(pastor,Y,T),
    insertar_delante(pastor,X,C),
    mover_dcha([C,T],A,R).

%Una vez movido el pastor trata de mover los animales o la col
%mover_izq se refiere a mover desde la izquierda, osea mover
%desde la orilla izquierda a la derecha
mover_izq([X,Y],A,Z):-
    extraer(lobo,X,T),
    append(Y,[lobo],C),
    comprobar_estado([T,C],A),
    Z = [T,C].

mover_izq([X,Y],A,Z):-
    extraer(col,X,T),
    append(Y,[col],C),
    comprobar_estado([T,C],A),
    Z = [T,C].

mover_izq([X,Y],A,Z):-
    extraer(oveja,X,T),
    append(Y,[oveja],C),
    comprobar_estado([T,C],A),
    Z = [T,C].

%Este es el último caso, se llega a él cuando sólo se puede
%mover al pastor, comprueba que el estado generado sea correcto
mover_izq([X,Y],A,Z):-
    comprobar_estado([X,Y],A),
    Z = [X,Y].

%Una vez movido el pastor trata de mover los animales o la col
%mover_dcha se refiere a mover desde la derecha, osea mover
%desde la orilla derecha a la izquierda
mover_dcha([X,Y],A,Z):-
    extraer(lobo,Y,T),
    append(X,[lobo],C),
    comprobar_estado([C,T],A),
    Z = [C,T].

mover_dcha([X,Y],A,Z):-
    extraer(col,Y,T),
    append(X,[col],C),
    comprobar_estado([C,T],A),
    Z = [C,T].

mover_dcha([X,Y],A,Z):-
    extraer(oveja,Y,T),
    append(X,[oveja],C),
    comprobar_estado([C,T],A),
    Z = [C,T].

%Este es el último caso, se llega a él cuando sólo se puede
%mover al pastor, comprueba que el estado generado sea correcto
mover_dcha([X,Y],A,Z):-
    comprobar_estado([X,Y],A),
    Z = [X,Y].

%Esta regla está para la comodidad del usuario, así no tiene que
%inicializar él el acumulador.
solucion(X,R):- solucionacc(X,[],[[X,[]]],R).

%Si le llega la lista vacía quiere decir que ya terminó, por lo tanto,
%procede a invertir el orden de los pasos que ha seguido, pues al 
%introducirlos han quedado ordenados en el orden inverso al que se han 
%hecho
solucionacc([],_,A,R):-
    invierte(A,R).

%Esta regla es la que encadena al resto para solucionar el problema.
%Se basa en intentar mover al pastor con o sin algún animal y llamarse
%de nuevo con las nuevas orillas generadas hasta que la orilla izquierda
%quede completamente vacía y por lo tanto, solucionando el problema
solucionacc(X,Y,A,R):- 
    mover_pastor([X,Y],A,B),
    nth0(0,B,U),
    nth0(1,B,V),
solucionacc(U,V,[B|A],R).
