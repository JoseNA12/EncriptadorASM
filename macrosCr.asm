metodoN Macro arrayTexto, textoCifrado, longclave, longClaveN, longtexto
	local inicioN, parada1, parada2, parada3, proceso, ultimaPalabra, puenteHaciaPProcesos_1
	
	xor bx,bx
	xor si,si
	xor di,di
	xor ax,ax
	
	mov ax, longclave
	sub ax,1						;Restar uno porque en el array el cero cuenta pero en variable no
	mov longclaveN, ax
	
	xor ax, ax
	
	inicioN:
		cmp si, longtexto			;Si el si es igual a la longitud del texto, salte a la ultima palabra
		je parada3
		
		cmp longClaveN, bx			;Sacar el bloque de texto de acuerdo a la longutd de la clave
		je parada1

		inc si
		add bx, 1
		
		jmp inicioN
	
	parada1:
		push si
		jmp proceso
	
	parada2:
		pop si
		inc si
		inc di
		jmp inicioN

	parada3:
		dec si	
		jmp ultimaPalabra
	
	proceso:
		
		mov al, arrayTexto[si]		;Meter el bloque de acuerdo a la clave de forma inversa
		mov textoCifrado[di], al
		cmp bx, 0					;Cuando termine, empieze con el otro bloque
		je parada2
		
		inc di
		dec si
		
		sub bx, 1					;Controla las veces de la iteracion
		
		jmp proceso
		
	ultimaPalabra:					;Hace lo mismo que proceso, a excepcion del flujo de salida
		
		cmp bx, 0					;Fin del encriptado
		je puenteHaciaPProcesos_1
		
		mov al, arrayTexto[si]
		mov textoCifrado[di], al
		
		inc di
		dec si
		
		sub bx, 1
		
		jmp ultimaPalabra
		
	puenteHaciaPProcesos_1:
		jmp puenteHaciaPProcesos
	
EndM


;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------



metodoL Macro letraML, abcMin, abcMod, arrayTexto, longtexto, textoMod, longClaveN, longclave, textoCifrado
	local encontrarLetra, hacerABC, finalizarABC, copiarABC, iniciarProceso, etapa1, etapa2, etapa3, agregarEspacioSigno, puenteLlamarN_1

	xor ax, ax					
	xor bx, bx					
	xor di, di
	xor si, si

	encontrarLetra:
		cmp letraML, 'a'		;El ABC queda igual, no tiene sentido hacer el proceso
		je copiarABC			;Para seguir la lógica de las variables, se copia exactamente lo mismo del ABC al ABCMOD
		
		mov al, abcMin[si]		;Para hacer la comparación de abajo
		
		cmp al, letraML			;Cuando encuentra la letra que pidió, salte
		je hacerABC
		
		inc si
		jmp encontrarLetra
		
	hacerABC:					;A este punto el SI, tiene la posición en el ABC donde esta la letra
		mov al, abcMin[si]		;Le pasa a AL la letra donde está en el ABC. El SI es acumumlativo en 'etapa1' y 'etapa2'
		mov abcMod[di], al		;Se almacena el ABC de acuerdo a la letra
		
		cmp al, 'Z'				;Cuando AL sea Z, limpia el SI para ir al principio del ABC y almacenar el resto del ABC que quedó 'detrás'
		je finalizarABC
		
		inc si
		inc di
		
		mov al, abcMin[si]		;Para hacer la comparación de abajo
		
		cmp al, letraML			;Cuando AL tenga la letra deseada, indica el final
		je iniciarProceso		;Sale cuando haya pasado por la etiqueta 'finalizar'
		
		jmp hacerABC
		
	finalizarABC:
		xor si, si
		inc di
		jmp hacerABC
		
	copiarABC:					;En caso de que la letra sea A, se copia tal cual el ABC

		cmp si, 54 				;Longitud del ABC
		je iniciarProceso
		
		mov al, abcMin[si]
		mov abcMod[si], al
		
		inc si
		jmp copiarABC
		
	;------------------------------------------;
	;Pasar el array texto al nuevo abc
	iniciarProceso:
		xor si, si
		xor di, di

	etapa1:
		mov al, arrayTexto[si]	;Caracter a analizar
		
		cmp si, longtexto
		je puenteLlamarN_1		;Fin del encriptado
		
	etapa2:
		cmp al, abcMin[di]		;Cuando encuentre la posicion en el ABC normal, en etapa3 lo almacena en el vector pero en relacion con el ABCMOD
		je etapa3				;Ambos ABC's tienen la misma longitud
		
		cmp di, 54				;Agregar un espacio o el signo al texto modificado
		je agregarEspacioSigno
		
		inc di
		jmp etapa2


	agregarEspacioSigno:
		mov textoMod[si], al	;Agregar un espacio al texto modificado
		xor di, di
		inc si
		jmp etapa1				;Continua con el siguiente caracter del texto
	
		
	etapa3:
		mov al, abcMod[di]		;Agregar el nuevo cararter de acuerdo al nuevo abc
		mov textoMod[si], al
		
		xor di, di
		inc si
		jmp etapa1
	
	puenteLlamarN_1:
	jmp puenteLlamarN
	
EndM			




;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------


metodoLDesencriptarL Macro letraML, abcMin, abcMod, arrayTexto, longtexto, textoMod, longClaveN, longclave, textoCifrado
	local puenteL, encontrarLetra, hacerABC, finalizarABC, copiarABC, iniciarProceso, etapa1, etapa2, etapa3, agregarEspacioSigno, inicioN, parada1, parada2, parada3, proceso, ultimaPalabra, puenteSalida
	
	xor bx,bx
	xor si,si
	xor di,di
	xor ax,ax
	
	mov ax, longclave
	sub ax,1
	mov longclaveN, ax
	
	xor ax, ax
	
	inicioN:
		cmp si, longtexto
		je parada3
		
		cmp longClaveN, bx
		je parada1

		inc si
		add bx, 1
		
		jmp inicioN
	
	parada1:
		push si
		jmp proceso
	
	parada2:
		pop si
		inc si
		inc di
		jmp inicioN

	parada3:
		dec si	
		jmp ultimaPalabra
	
	proceso:
		
		mov al, arrayTexto[si]
		mov textoCifrado[di], al
		cmp bx, 0
		je parada2
		
		inc di
		dec si
		
		sub bx, 1
		
		jmp proceso
		
	ultimaPalabra:
		
		cmp bx, 0
		je puenteL
		
		mov al, arrayTexto[si]
		mov textoCifrado[di], al
		
		inc di
		dec si
		
		sub bx, 1
		
		jmp ultimaPalabra
		
		
		
	puenteL:
	xor ax, ax					
	xor bx, bx					
	xor di, di
	xor si, si

	encontrarLetra:
		cmp letraML, 'a'		;El ABC queda igual, no tiene sentido hacer el proceso
		je copiarABC			;Para seguir la lógica de las variables, se copia exactamente lo mismo del ABC al ABCMOD
		
		mov al, abcMin[si]		;Para hacer la comparación de abajo
		
		cmp al, letraML			;Cuando encuentra la letra que pidió, salte
		je hacerABC
		
		inc si
		jmp encontrarLetra
		
	hacerABC:					;A este punto el SI, tiene la posición en el ABC donde esta la letra
		mov al, abcMin[si]		;Le pasa a AL la letra donde está en el ABC. El SI es acumumlativo en 'etapa1' y 'etapa2'
		mov abcMod[di], al		;Se almacena el ABC de acuerdo a la letra
		
		cmp al, 'Z'				;Cuando AL sea Z, limpia el SI para ir al principio del ABC y almacenar el resto del ABC que quedó 'detrás'
		je finalizarABC
		
		inc si
		inc di
		
		mov al, abcMin[si]		;Para hacer la comparación de abajo
		
		cmp al, letraML			;Cuando AL tenga la letra deseada, indica el final
		je iniciarProceso		;Sale cuando haya pasado por la etiqueta 'finalizar'
		
		jmp hacerABC
		
	finalizarABC:
		xor si, si
		inc di
		jmp hacerABC
		
	copiarABC:				;En caso de que la letra sea A, se copia tal cual el ABC

		cmp si, 54			;Longitud del ABC
		je iniciarProceso
		
		mov al, abcMin[si]
		mov abcMod[si], al
		
		inc si
		jmp copiarABC
		
	;------------------------------------------;
	;Pasar el array texto al nuevo abc
	iniciarProceso:
		xor ax,ax
		xor bx,bx
		xor si, si
		xor di, di

	etapa1:
		mov al, textoCifrado[si]	;Caracter a analizar
		
		cmp si, longtexto
		je puenteSalida
		
	etapa2:
		cmp al, abcMod[di]	;Cuando encuentre la posicion en el ABC normal, en etapa3 lo almacena en el vector pero en relacion con el ABCMOD
		je etapa3			;Ambos ABC's tienen la misma longitud
		
		cmp di, 54			;Agregar un espacio al texto modificado
		je agregarEspacioSigno
		
		inc di
		jmp etapa2


	agregarEspacioSigno:
		mov textoMod[si], al;Agregar un espacio al texto modificado
		xor di, di
		inc si
		jmp etapa1			;Continua con el siguiente caracter del texto
	
		
	etapa3:
		mov al, abcMin[di]
		mov textoMod[si], al
		
		xor di, di
		inc si
		jmp etapa1
	
	puenteSalida:
	jmp puenteProcesos
	
EndM			


;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

metodoM Macro longtexto, indiceArrayTexto, arrayTexto, textoBloque, indiceBloque, columnaVector, caracterBinario, caracterBinarioLE, cociente, vectorR1, vectorR2, vectorR3, vectorR4, vectorL1, vectorL2, vectorL3, vectorL4, textoCifrado, indiceTextoM, resultadoM
	local inicioCifradoM, sacarCaracteres, limpiarRegistros2, limpiarVectores, limpiarSI, limpiarRegistros, dividirBinario1, dividirBinario2, dividirBinario3, convertirTexto, meterCaracterBinario, meterVector, Puente_convertirTexto, voltearBinario
	
	empezarProceso:
		xor ax,ax
		xor bx,bx
		xor si,si
		xor di,di
		xor cx,cx
		jmp inicioCifradoM
	
	terminar_M:
		jmp llamarXOREncriptar
		
	inicioCifradoM:
		xor bx,bx
		cmp cx, longtexto
		jge terminar_M
		
		add cx, 8
		mov di, indiceArrayTexto
		
	sacarCaracteres:
		cmp bx,8
		je limpiarRegistros2
		
		mov al, arrayTexto[di]
		mov textoBloque[bx], al
		
		inc di
		inc bx
		
		jmp sacarCaracteres
			
	limpiarRegistros2:
		mov indiceArrayTexto, di
		mov indiceBloque, 0
		mov columnaVector, 7
		xor ax,ax
		xor bx,bx
		xor di,di
		xor si,si
		
	limpiarVectores:
		cmp si, 8
		je limpiarSI
		
		mov caracterBinario[si],0
		inc si
		jmp limpiarVectores
		
	limpiarSI:
		xor si,si
		jmp dividirBinario1
	
		
	limpiarRegistros:
		xor ax,ax
		xor bx,bx
		xor di,di
		mov si, indiceBloque
		
	
	dividirBinario1:
		cmp si, 8
		je Puente_convertirTexto
		
		mov al, textoBloque[si]
		mov bl, 2
		div bl	 ;divide ax/bx el resultado lo almacena en al, el residuo en ah
		
		mov caracterBinario[di], ah
		mov cociente, al
		
		xor ax,ax
		xor bx,bx
		inc di
		jmp dividirBinario2
		
		
	dividirBinario2:
		cmp cociente, 1
		je dividirBinario3
		
		cmp cociente, 0
		je dividirBinario3
		
		mov al, cociente
		mov bl, 2
		div bl
		
		mov caracterBinario[di], ah
		mov cociente, al
		
		inc di
		
		xor ax,ax
		xor bx,bx
		jmp dividirBinario2
		
	
		
	dividirBinario3:
		mov ah, cociente
		mov caracterBinario[di], ah	;Añadir el cociente que queda cuando termina la division
	
		mov indiceBloque, si
		xor si,si
		mov di, 7
	
	
		
	voltearBinario:
		mov al, caracterBinario[di]
		mov caracterBinarioLE[si], al
		
		cmp di, 0
		je meterVector
		
		inc si
		dec di
		
		jmp voltearBinario
	
	Puente_convertirTexto:
		jmp convertirTexto
		
	meterVector:
		xor di,di
		mov si, indiceBloque
		mov bx, columnaVector
		
	meterCaracterBinario: 
		mov al, caracterBinarioLE[di]
		mov vectorR1[bx], al
		inc di
		
		mov al, caracterBinarioLE[di]
		mov vectorL1[bx], al
		inc di
		
		mov al, caracterBinarioLE[di]
		mov vectorR2[bx], al
		inc di
		
		mov al, caracterBinarioLE[di]
		mov vectorL2[bx], al
		inc di
		
		mov al, caracterBinarioLE[di]
		mov vectorR3[bx], al
		inc di
		
		mov al, caracterBinarioLE[di]
		mov vectorL3[bx], al
		inc di
		
		mov al, caracterBinarioLE[di]
		mov vectorR4[bx], al
		inc di
		
		mov al, caracterBinarioLE[di]
		mov vectorL4[bx], al
		
		inc si
		mov indiceBloque, si
		dec bx
		mov columnaVector, bx
		jmp limpiarRegistros

		
	convertirTexto:
		mov resultadoM,0
		mov si, indiceTextoM
		push si
		binario2Decimal vectorR1, resultadoM
		pop si
		mov al, resultadoM
		mov textoCifrado[si], al
		inc si
	
		mov resultadoM,0
		push si
		binario2Decimal vectorR2, resultadoM
		pop si
		mov al, resultadoM
		mov textoCifrado[si], al
		inc si
		
		mov resultadoM,0
		push si
		binario2Decimal vectorR3, resultadoM
		pop si
		mov al, resultadoM
		mov textoCifrado[si], al
		inc si
		
		mov resultadoM,0
		push si
		binario2Decimal vectorR4, resultadoM
		pop si
		mov al, resultadoM
		mov textoCifrado[si], al
		inc si
		
		mov resultadoM,0
		push si
		binario2Decimal vectorL1, resultadoM
		pop si
		mov al, resultadoM
		mov textoCifrado[si], al
		inc si
		
		mov resultadoM,0
		push si
		binario2Decimal vectorL2, resultadoM
		pop si
		mov al, resultadoM
		mov textoCifrado[si], al
		inc si
		
		mov resultadoM,0
		push si
		binario2Decimal vectorL3, resultadoM
		pop si
		mov al, resultadoM
		mov textoCifrado[si], al
		inc si
		
		mov resultadoM,0
		push si
		binario2Decimal vectorL4, resultadoM
		pop si
		mov al, resultadoM
		mov textoCifrado[si], al
		inc si
		
		mov indiceTextoM, si
		
		
		jmp inicioCifradoM
			
EndM


;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------


metodoMDescriptar Macro longtexto, indiceTextoDescifrar, textoXOR, textoBloque, indiceBloque, caracterBinario, caracterBinarioLE, cociente, vectorR1, vectorR2, vectorR3, vectorR4, vectorL1, vectorL2, vectorL3, vectorL4, textoBinarioD, resultadoM, indiceTextoFinal, textoCifrado
	local descifrado, terminarDescencriptarM, inicioDescifrado, sacarCaracteresDescifrar, limpiarRDescifrar, escribirTextoDescifrado2, Puente_inicioDescifrado, escribirTextoDescifrado, sacarCaracteresOrden, stop1, Puente_limpiarRDescifrar2, Puente_inicioDescifrado2, meterVectorL1, meterVectorL2, meterVectorL3, meterVectorL4, meterVectorR1, meterVectorR2, meterVectorR3, meterVectorR4, meterVectorD, Puente_stop1, voltearBinarioD, dividirBinario3D, Puente_inicioDescifrado3, dividirBinario2D, dividirBinario1D, limpiarSI1, limpiarVectores1, limpiarSI2, limpiarVectores2, limpiarRDescifrar2


	descifrado:
		xor ax,ax
		xor bx,bx
		xor si,si
		xor di,di
		xor cx,cx
		
		jmp inicioDescifrado
		
	terminarDescencriptarM:
		jmp puenteProcesos
		
		
	inicioDescifrado:
		xor bx,bx
		cmp cx, longtexto
		jge terminarDescencriptarM
		
		add cx, 8
		mov di, indiceTextoDescifrar
		
	sacarCaracteresDescifrar:
		cmp bx,8
		je limpiarRDescifrar
		
		mov al, textoXOR[di]
		mov textoBloque[bx], al
		
		inc di
		inc bx
		
		jmp sacarCaracteresDescifrar
			
	limpiarRDescifrar:
		mov indiceTextoDescifrar, di
		mov indiceBloque, 0
		mov resultadoM,0
		xor ax,ax
		xor bx,bx
		xor di,di
		xor si,si
	
		jmp limpiarVectores2
		
	limpiarRDescifrar2:
		
		xor ax,ax
		xor bx,bx
		xor di,di
		xor si,si
		jmp limpiarVectores1
		
	limpiarVectores2:
		cmp si, 8
		je limpiarSI2
		
		mov caracterBinario[si],0
		inc si
		jmp limpiarVectores2
		
	limpiarSI2:
		xor si,si
		mov si, indiceBloque
		jmp dividirBinario1D
		
	limpiarVectores1:
		cmp si, 8
		je limpiarSI1
		
		mov caracterBinario[si],0
		inc si
		jmp limpiarVectores1
		
	limpiarSI1:
		xor si,si
		mov si, indiceBloque
		inc si
		
	dividirBinario1D:
		cmp si, 8
		je Puente_stop1
		
		mov al, textoBloque[si]
		mov bl, 2
		div bl	 ;divide ax/bx el resultado lo almacena en al, el residuo en ah
		
		mov caracterBinario[di], ah
		mov cociente, al
		
		xor ax,ax
		xor bx,bx
		inc di
		
	dividirBinario2D:
		cmp cociente, 1
		je dividirBinario3D
		
		cmp cociente, 0
		je dividirBinario3D
		
		mov al, cociente
		mov bl, 2
		div bl
		
		mov caracterBinario[di], ah
		mov cociente, al
		
		inc di
		
		xor ax,ax
		xor bx,bx
		jmp dividirBinario2D
	
	Puente_inicioDescifrado3:
		jmp inicioDescifrado
	
		
	dividirBinario3D:
	
		mov ah, cociente
		mov caracterBinario[di], ah	;Añadir el cociente que queda cuando termina la division
	
		mov indiceBloque, si
		xor si,si
		mov di, 7
	
		
	voltearBinarioD:
	
		mov al, caracterBinario[di]
		mov caracterBinarioLE[si], al
		
		cmp di, 0
		je meterVectorD
		
		inc si
		dec di
		
		jmp voltearBinarioD
	
	Puente_stop1:
		jmp stop1
		
	meterVectorD:
		xor di,di
		mov si, indiceBloque

		cmp si, 0
		je meterVectorR1
		
		cmp si, 1
		je meterVectorR2
		
		cmp si, 2
		je meterVectorR3
		
		cmp si, 3
		je meterVectorR4
		
		cmp si, 4
		je meterVectorL1
		
		cmp si, 5
		je meterVectorL2
		
		cmp si, 6
		je meterVectorL3
		
		cmp si, 7
		je meterVectorL4
	
	Puente_inicioDescifrado2:
		jmp Puente_inicioDescifrado3
	Puente_limpiarRDescifrar2:
		jmp limpiarRDescifrar2
	
		
	meterVectorR1:
		cmp di, 8
		je Puente_limpiarRDescifrar2
		mov al, caracterBinarioLE[di]
		mov vectorR1[di], al
		inc di
		jmp meterVectorR1
		
	meterVectorR2:
		cmp di, 8
		je Puente_limpiarRDescifrar2
		mov al, caracterBinarioLE[di]
		mov vectorR2[di], al
		inc di
		jmp meterVectorR2
	
	meterVectorR3:
		cmp di,8
		je Puente_limpiarRDescifrar2
		mov al, caracterBinarioLE[di]
		mov vectorR3[di], al
		inc di
		jmp meterVectorR3
	
	meterVectorR4:
		cmp di,8
		je Puente_limpiarRDescifrar2
		mov al, caracterBinarioLE[di]
		mov vectorR4[di], al
		inc di
		jmp meterVectorR4
	
	meterVectorL1:
		cmp di,8
		je Puente_limpiarRDescifrar2
		mov al, caracterBinarioLE[di]
		mov vectorL1[di], al
		inc di
		jmp meterVectorL1
	
	meterVectorL2:
		cmp di,8
		je Puente_limpiarRDescifrar2
		mov al, caracterBinarioLE[di]
		mov vectorL2[di], al
		inc di
		jmp meterVectorL2
		
	meterVectorL3:
		cmp di,8
		je Puente_limpiarRDescifrar2	
		mov al, caracterBinarioLE[di]
		mov vectorL3[di], al
		inc di
		jmp meterVectorL3
		
	meterVectorL4:
		cmp di,8
		je Puente_limpiarRDescifrar2
		mov al, caracterBinarioLE[di]
		mov vectorL4[di], al
		inc di
		jmp meterVectorL4
		
	stop1:
		xor di,di
		xor si,si
		xor bx,bx
		mov si,7
		

	sacarCaracteresOrden:
		mov al, vectorR1[si]
		mov textoBinarioD[di], al
		inc di
		
		mov al, vectorL1[si]
		mov textoBinarioD[di], al
		inc di
		
		mov al, vectorR2[si]
		mov textoBinarioD[di], al
		inc di
		
		mov al, vectorL2[si]
		mov textoBinarioD[di], al
		inc di
		
		mov al, vectorR3[si]
		mov textoBinarioD[di], al
		inc di
		
		mov al, vectorL3[si]
		mov textoBinarioD[di], al
		inc di
		
		mov al, vectorR4[si]
		mov textoBinarioD[di], al
		inc di
		
		mov al, vectorL4[si]
		mov textoBinarioD[di], al
		
		jmp escribirTextoDescifrado
		
	
		
	escribirTextoDescifrado:
		push si
	
		binario2Decimal textoBinarioD, resultadoM

		pop si
		jmp escribirTextoDescifrado2
		
	Puente_inicioDescifrado:
		jmp Puente_inicioDescifrado2
		
	escribirTextoDescifrado2:
		mov bx, indiceTextoFinal
		mov al, resultadoM
		mov textoCifrado[bx], al
		
		inc bx
		mov indiceTextoFinal, bx
		
		mov resultadoM,0
		
		cmp si, 0
		je Puente_inicioDescifrado
		
		dec si
		
		
		xor di,di
		jmp sacarCaracteresOrden

EndM

;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
;-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

binario2Decimal Macro vector, resultadoM
	xor ax,ax
	xor bx,bx
	xor si,si
	
	mov al, vector[si]
	mov bl, 128
	mul bl
	
	add resultadoM, al
	inc si
	xor ax,ax
	xor bx,bx
	
;----------------------------	

	mov al, vector[si]
	mov bl, 64
	mul bl
	
	add resultadoM, al
	inc si
	xor ax,ax
	xor bx,bx
;----------------------------	
	
	mov al, vector[si]
	mov bl, 32
	mul bl
	
	add resultadoM, al
	inc si
	xor ax,ax
	xor bx,bx	
;----------------------------	
	
	mov al, vector[si]
	mov bl, 16
	mul bl
	
	add resultadoM, al
	inc si
	xor ax,ax
	xor bx,bx
;----------------------------	
	
	mov al, vector[si]
	mov bl, 8
	mul bl
	
	add resultadoM, al
	inc si
	xor ax,ax
	xor bx,bx
;----------------------------	
	
	mov al, vector[si]
	mov bl, 4
	mul bl
	
	add resultadoM, al
	inc si
	xor ax,ax
	xor bx,bx
;----------------------------	
	
	mov al, vector[si]
	mov bl, 2
	mul bl
	
	add resultadoM, al
	inc si
	xor ax,ax
	xor bx,bx
;----------------------------	
	
	mov al, vector[si]
	mov bl, 1
	mul bl
	
	add resultadoM, al
	xor ax,ax
	xor bx,bx
	xor si, si
EndM
	