realizarXor Macro longTexto, longClave, textoCifrado, textoBloque, textoXOR, arrayClave
	local limpiarSI2, recorrerTexto, LimpiarSI, hacerXor


	xor ax, ax					
	xor bx, bx					
	xor di, di

	limpiarSI2:						;Asignar la cantidad de la longitud de la clave
				
		xor si,si					;Una vez almacenado el indice, se borra el SI porque se necesita a la hora de almacenar el bloque de texto en el vector
	
	recorrerTexto:					;Analiza el texto deacuerdo a la longitud de la clave. El SI está en 0 por primera vez
		cmp si, longClave			;Compara el SI con la longitud de la clave alcenada anteriormente para ir sacando el bloque de texto
		je LimpiarSI				;Cuando el SI es igual a la longitud se va a hacer el xor de cada caracter del bloque de texto con la clave
		
		mov al, textoCifrado[di]	;Se almacena el caracter del texto en AL deacuerdo al SI
		mov textoBloque[si], al		;Luego, el AL se se almacena en el Vector
		inc si						;Se incrementa el SI para iterar en el texto
		inc di						;Se incrementa el DI para almacenar consecutivamente el bloque de texto
		
		jmp recorrerTexto			;Realiza el Loop

	LimpiarSI:						;Se crea esta etiqueta aparte porque recorrer2 y hacerXor hacen Loop's y se necesita mantener el SI en esas dos etiquetas y no modificar el valor
		xor si, si					;Borra el si para empezar a analizar el bloque de texto y la clave desde la posicion 0
		sub di, longClave			;Se resta al DI, la longitud de clave para que cuando se realiza el xor del bloque de texto, no meta en el archivo espacios en blanco por la..
									;.. iteracion de la etiqueta recorrer2
	hacerXor:
		xor ax, ax					;Para observar mejor en tiempo de ejecucion el registro
		xor bx, bx					;
		
		cmp di, longTexto			;En caso de que la longitud de la clave no concuerde con el bloque final del texto, se compara con el '$' para salir del programa
		je puenteXOR
		
		cmp longClave, si			;Cuando el SI sea igual a la longitud de la clave, salta a esta etiqueta principalmente por el xor
		je limpiarSI2
		
		mov al, textoBloque[si]		;Almacena el caracter del bloque de texto según la posicion del SI
		mov bl, arrayClave[si]		;Almacena el caracter de la clave en la misma posisión que el bloque de texto
		xor al, bl					;Se hace el XOR, el valor queda en el AL
		
		mov textoXOR[di], al		;Se almacena en el vector, segun el indice DI, el valor del XOR
		inc si
		inc di
		
		jmp hacerXor

EndM
	