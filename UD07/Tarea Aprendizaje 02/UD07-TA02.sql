--1.Crea un bloque anónimo que visualice en pantalla la frase. "HOLA MUNDO!
SET SERVEROUTPUT ON;
BEGIN
    dbms_output.put_line('HOLA MUNDO!');
END;
/

--2.Crea un bloque anónimo que pida por teclado un nombre y lo visualice en
--pantalla dentro del siguiente mensaje. 'Hola, nombre'.
SET SERVEROUTPUT ON;
ACCEPT nombre PROMPT 'Introduce tu nombre: '
DECLARE
    nombre VARCHAR2(20) := '&nombre';
BEGIN
    dbms_output.put_line('Hola, ' || nombre);
END;
/

--3.Crea un bloque anónimo que sume dos números enteros que introducimos por teclado.
SET SERVEROUTPUT ON;
ACCEPT num1 PROMPT 'Introduce el primer numero: '
ACCEPT num2 PROMPT 'Introduce el segundo numero: '
DECLARE
    num1 PLS_INTEGER := '&num1';
    num2 PLS_INTEGER := '&num2';
    results PLS_INTEGER;
BEGIN
    results := num1+num2;
    dbms_output.put_line('La suma entre los 2 numeros es ' || results);
END;
/

--4.Crea un bloque anónimo que mire si un determinado numero introducido por
--teclado es positivo, negativo o cero.
SET SERVEROUTPUT ON;
ACCEPT num1 PROMPT 'Introduce un numero: '
DECLARE
    num1 PLS_INTEGER := '&num1';
BEGIN
    IF num1 > 0 THEN
        dbms_output.put_line('El numero introducido es positivo');
    ELSIF num1 < 0 THEN
        dbms_output.put_line('El numero introducido es negativo');
    ELSE
        dbms_output.put_line('El numero introducido es 0');
    END IF;
END;
/

--5.Crea un bloque anónimo que introduciendo una nota numérica por teclado del
--0-10 muestre en pantalla su equivalente nominal. Por ejemplo si la nota es 8 
--deberá mostrar "Tu nota es: notable". Si la nota es no válida lo deberá mostrar
--en un mensaje. Utiliza la función CASE.
SET SERVEROUTPUT ON;
ACCEPT nota PROMPT 'Introduce la nota (0-10): '
DECLARE
    nota NUMBER := '&nota';
    resultado VARCHAR2(20);
BEGIN
    CASE
        WHEN nota BETWEEN 0 AND 4.99 THEN
            resultado := 'suspenso';
        WHEN nota BETWEEN 5 AND 5.99 THEN
            resultado := 'aprobado';
        WHEN nota BETWEEN 6 AND 6.99 THEN
            resultado := 'bien';
        WHEN nota BETWEEN 7 AND 8.99 THEN
            resultado := 'notable';
        WHEN nota BETWEEN 9 AND 10 THEN
            resultado := 'sobresaliente';
        ELSE
            resultado := 'Nota no válida';
    END CASE;
    dbms_output.put_line('Tu nota es: ' || resultado);
END;
/

--6.Escribe un bloque anónimo en PL/SQL que chequee si un determinado carácter
--introducido por teclado es una letra o un dígito.
SET SERVEROUTPUT ON;
ACCEPT caracter PROMPT 'Introduce un caracter: '
DECLARE
    caracter CHAR(1) := '&caracter';
BEGIN
    IF (caracter >= 'A' AND caracter <= 'Z') OR (caracter >= 'a' AND caracter <= 'z') THEN
        dbms_output.put_line('El caracter introducido es una letra.');
    ELSIF caracter BETWEEN '0' AND '9' THEN
        dbms_output.put_line('El caracter introducido es un numero.');
    ELSE
        dbms_output.put_line('El caracter introducido no es ni una letra ni un numero.');
    END IF;
END;
/

--7.Escribe un bloque anónimo en PL/SQL que imprima los primeros n numeros.
--Del 1 hasta el n introducido por teclado.
SET SERVEROUTPUT ON;
ACCEPT num1 PROMPT 'Introduce un numero: '
DECLARE
    num1 NUMBER := '&num1';
BEGIN
    dbms_output.put_line('Los primeros ' || num1 || ' numeros son: ');
    FOR i IN 1..num1 LOOP
        dbms_output.put_line(i);
    END LOOP;
END;
/

--8.Escribe un bloque anónimo en PL/SQL que saca la tabla de multiplicar
--hasta 10 de un número introducido por teclado.
SET SERVEROUTPUT ON;
ACCEPT num1 PROMPT 'Introduce un numero: '
DECLARE
    num1 NUMBER := '&num1';
BEGIN
    FOR i IN 1..10 LOOP
        dbms_output.put_line(num1 || ' x ' || i || ' = ' || (num1*i));
    END LOOP;
END;
/

--9.Escribe un bloque anónimo en PL/SQL para imprimir los numeros primos desde
--el 1 hasta el 50. Un número primo es un número natural mayor que 1 que tiene
--únicamente dos divisores distintos: él mismo y el 1
SET SERVEROUTPUT ON;
DECLARE
    contador NUMBER(3);
BEGIN
    FOR i IN 2..50 LOOP
        contador := 0;
        FOR j IN 1..i LOOP
            IF (MOD(i, j) = 0) THEN
                contador := contador + 1;
            END IF;
        END LOOP;
        IF contador = 2 THEN
            dbms_output.put_line(i);
        END IF;
    END LOOP;
END;
/

--10.Escribe un bloque anónimo en PL/SQL que devuelva el reverso de un número
--introducido por teclado. Si introduzco 2345 me devolverá 5432
SET SERVEROUTPUT ON;
ACCEPT num1 PROMPT 'Introduce un numero: '
DECLARE
    num1 NUMBER := '&num1';
    tmp NUMBER := 0;
    rev NUMBER := 0;
BEGIN
    WHILE num1 > 0 LOOP
        tmp := MOD(num1, 10);       --Devuelve el resto de la division (ejem. 2345/10 = 234.5->5)
        num1 := TRUNC(num1 / 10);   --Divide entre 10 y Redondea el numero (ejem. 234.5->234)
        rev := rev * 10 + tmp;      --Añade el ultimo numero detras (ejem. 0*10+5=5 -> 5*10+4=54)
    END LOOP;
    dbms_output.put_line(rev);
END;
/

--11.Escribe un bloque anónimo en PL/SQL que devuelva la serie fibonacci hasta
--la posición que indiquemos en el número introducido por teclado.
--La serie comienza con los números 0 y 1,​ y a partir de estos, cada término es
--la suma de los dos anteriores. La secuencia es la siguiente:
--0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377...
SET SERVEROUTPUT ON;
ACCEPT num1 PROMPT 'Introduce un numero: '
DECLARE
    num1 NUMBER := '&num1';
    primero NUMBER := 0;
    segundo NUMBER := 1;
    tercero NUMBER;
BEGIN
    FOR i IN 1..num1 LOOP
        dbms_output.put_line(primero);
        tercero := primero + segundo;
        primero := segundo;
        segundo := tercero;
    END LOOP;
END;
/
