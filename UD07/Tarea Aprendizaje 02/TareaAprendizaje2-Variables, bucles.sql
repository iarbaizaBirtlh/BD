--1.Crea un  bloque anónimo que visualice en pantalla la frase. "HOLA MUNDO!"
SET SERVEROUTPUT ON;
BEGIN
dbms_output.put_line('Hola Mundo');
END;
/
--2.Crea un bloque anónimo que pida por teclado un nombre y lo visualice en pantalla dentro del siguiente mensaje. 'Hola,nombre'.
SET SERVEROUTPUT ON
SET VERIFY OFF --Opcional.Se utiliza para no mostrar antiguo y nuevo en la ejecución.
DECLARE
nombre VARCHAR2(20):='&nombre';
BEGIN
dbms_output.put_line('Hola '||nombre);
END;
/

--3.Crea un bloque anónimo que sume dos números enteros que introducimos por teclado.
SET SERVEROUTPUT ON;
DECLARE
var1 PLS_INTEGER:=&var1;
var2 PLS_INTEGER:=&var2;
var3 PLS_INTEGER;
BEGIN
var3:=var1+var2;
dbms_output.put_line(var3);
END;
/

--4.Crea un bloque anónimo que mire si un determinado número introducido por teclado es positivo, negativo o cero.
SET SERVEROUTPUT ON;
DECLARE
num1 NUMBER := &num1;
BEGIN
IF num1 < 0 THEN
DBMS_OUTPUT.PUT_LINE ('El numero '||num1||' es un numero negativo');
ELSIF num1 = 0 THEN
DBMS_OUTPUT.PUT_LINE ('El numero '||num1||' is igual a cero');
ELSE
DBMS_OUTPUT.PUT_LINE ('El numero '||num1||' es un numero positivo');
END IF;
END;
/

--5.Crea un bloque anónimo que introduciendo una nota numérica por teclado del 0-10 muestre en pantalla su equivalente nominal. Por ejemplo si la nota es 8 deberá mostrar "Tu nota es: notable". Si la nota es no válida lo deberá mostrar en un mensaje. Utiliza la función CASE.
SET SERVEROUTPUT ON;
DECLARE
    notanum NUMBER:='&notanum';
BEGIN    
  CASE 
    WHEN notanum BETWEEN 9 AND 10 THEN dbms_output.put_line('Tu nota es: sobresaliente');
    WHEN notanum BETWEEN 7 AND 8.99 THEN dbms_output.put_line('Tu nota es: notable');
    WHEN notanum BETWEEN 6 AND 6.99 THEN dbms_output.put_line('Tu nota es: bien');
    WHEN notanum BETWEEN 5 AND 5.99 THEN dbms_output.put_line('Tu nota es: aprobado');
    WHEN notanum BETWEEN 0 AND 5 THEN dbms_output.put_line('Tu nota es: mejorable');
  ELSE dbms_output.put_line('No es una nota válida');
  END CASE;
END;
/

--6.Escribe un bloque anónimo en PL/SQL que chequee si un determinado carácter es una letra o un dígito.
SET SERVEROUTPUT ON;
DECLARE
    ctr CHAR(1) := '&ctr';
BEGIN
    IF ( ctr >= 'A' AND ctr <= 'Z' ) OR ( ctr >= 'a' AND ctr <= 'z' ) THEN
      dbms_output.Put_line ('El caracter introducido es una letra');
    ELSIF ctr BETWEEN '0' AND '9' THEN
      dbms_output.Put_line ('El caracter introducido es un numero');
    ELSE
      dbms_output.Put_line ('El caracter introducido no es ni una letra ni un número');
    END IF;
END; 
/

--7.Escribe un bloque anónimo en PL/SQL que imprima los primeros n numeros. Del 1 hasta el n introducido por teclado.
DECLARE
  N NUMBER:= &numero;
BEGIN
 dbms_output.put_line ('Los primeros '||N||' números son: ');
    FOR I IN 1..N LOOP
       dbms_output.put(I||'  ');
    END LOOP;
    dbms_output.new_line;
 END;
/
--8.Escribe un bloque anónimo en PL/SQL que saca la tabla de multiplicar hasta 10 de un número introducido por teclado.
SET SERVEROUTPUT ON;
DECLARE
	N NUMBER:=&n;
BEGIN
	FOR I IN 1..10
	LOOP
		dbms_output.put_line(N||' x '||I||' = '||N*I);
	END LOOP;
END;
/

--9.Escribe un bloque anónimo en PL/SQL para imprimir los numeros primos desde el 1 hasta el 50. Un número primo es un número natural mayor que 1 que tiene únicamente dos divisores distintos: él mismo y el 1
DECLARE
    i NUMBER(3);
    j NUMBER(3);
BEGIN
dbms_output.Put_line('Los números primos son:');
	dbms_output.new_line;
    i := 2;
    LOOP
        j := 2;
        LOOP
            EXIT WHEN( ( MOD(i, j) = 0 ) OR ( j = i ) );
            j := j + 1;
        END LOOP;
        IF( j = i )THEN
          dbms_output.Put(i||'   ');							   
        END IF;
        i := i + 1;
        exit WHEN i = 50;
    END LOOP;
	dbms_output.new_line;
END;
/

--10.Escribe un bloque anónimo en PL/SQL que devuelva el reverso de un número introducido por teclado. Si introduzco 2345 me devolverá 5432
SET SERVEROUTPUT ON;
DECLARE
	N NUMBER :=&n;
	rev NUMBER:=0;
	R NUMBER;
BEGIN
	WHILE N>0
	LOOP
		R:=MOD(N,10);
		rev:=(rev*10)+R;
		N:=TRUNC(N/10);
	END LOOP;
	dbms_output.put_line('El número al revés es '||rev);
END;
/
--11.Escribe un bloque anónimo en PL/SQL que devuelva la serie fibonacci hasta la posición que indiquemos en el número introducido por teclado. La serie comienza con los números 0 y 1,​ y a partir de estos, cada término es la suma de los dos anteriores. La secuencia es la siguiente: 0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377...
SET SERVEROUTPUT ON;
DECLARE
	primero NUMBER:=0;
	segundo NUMBER:=1;
	tercero NUMBER;
	N NUMBER:=&n;
 
BEGIN
	dbms_output.put_line('La serie Fibonacci es:');
	dbms_output.put_line(primero);
	dbms_output.put_line(segundo);	
 
	FOR I IN 2..N
	LOOP
		tercero:=primero+segundo;
		primero:=segundo;
		segundo:=tercero;
		dbms_output.put_line(tercero);
	END LOOP;
END;
/