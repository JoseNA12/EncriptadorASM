;Proyecto ASM, encriptacion y desencriptación
;Instituto Tecnológico de Costa Rica.
;Arquitectura de Computadoras - Carlos Benavides.
;Josué Suárez Campos - José Navarro Acuña.
;2017

SPila Segment

     db 1000 Dup ('?')
     
SPila EndS

SDato Segment

	LineCommand db 0FFh Dup (?)
	metodoCriptografico db ?
	variableW db 1 dup (?)
	nombreArchivo db 15 dup (?)
	nombreNuevo db 'result.txt', 0
	arrayClave db 64 dup (?)
	puntero dw 0
	texto db 1000 dup (?)
	cerosW db 1000 dup (?) 
	letraML db ?
	claveDefecto db 'clave',0
	nombreDefecto db 'archivo.txt',0
	ayudaVar1 db 10,13,'Tecnologico de Costa Rica',10,13,'Josue Suarez Campos',10,13, 'Jose Navarro Acuña',10,13,'Arquitectura de Computadores',10,13,'Grupo 1',10,13,'Criptografia'
	ayudaVar2 db 10,13,10,13,'Los parametros disponibles para la linea de comandos son los siguientes:',10,13,'encri [e|d] [/?|h] archivo.txt [/n | /m | /l:LETRA ] [clave] [/w]',10,13
	ayudaVar3 db 'e: Encriptar',10,13,'d: Desencriptar',10,13,'/? | /h: Ayuda',10,13,'archivo.txt: Indique el nombre del archivo a encriptar, si no se provee un nombre de archivo el sistema utilizara uno predefinido.'
	ayudaVar4 db 10,13,'/n: Metodo de criptografia que tomara tantos caracteres del archivo como cantidad de caracteres tenga la clave. A los caracteres seleccionados los escribira al revez. Por ejemplo, la palabra casa pasaria a ser asac y asi hasta terminar todo lo que contiene el documento'
	ayudaVar5 db 10,13,'/m: Este método de criptografia va sacando del texto, 8 caracteres a los cuales les saca su equivalente binario. Estos bits se agrega a una matriz. Cada fila de la matriz representa una letra nueva en el texto cifrado.',10,13,'/l:Letra: Este metodo de criptografia modificara el abecedario empezando desde la letra indicada por el usuario. Seguidamente transformara el texto cambiando las letras con el nuevo abecedario.'
	ayudaVar6 db 'Por ultimo se aplica el metodo /n',10,13,'A los 3 metodos de criptografia se les procesara por el metodo XOR, cuyo proceso es hacer un XOR entre los caracteres del texto y los de la clave.'
	ayudaVar7 db 10,13,'Clave: Muy importante de indicar por el usuario',10,13,'/w: Elimina de forma irrecuperable el texto del archivo original',10,13,'$'
	
	errorProcesos db 10,13,'Ha ocurrido un error durante el proceso. Intentelo de nuevo.',10,13,'$'
	msjProcesoTerminado db 10,13,'El proceso ha finalizado con exito!.',10,13,'$'
	
	arrayTexto db 1000 dup (?)

	longClave dw ?
	longTexto dw ?
	longClaveN dw ?
	longClaveL dw ?
	textoBloque db 255 dup (?)		;Contiene el bloque de texto
	textoCifrado db 1000 dup (?)	;Contiene el texto cifrado del metodo elegido
	opcionProceso db ?
	textoXOR db 5000 dup (?)
	abcMin db 61h, 62h, 63h, 64h, 65h, 66h, 67h, 68h, 69h, 6ah, 6bh, 6ch, 6dh, 6eh, 0A4h, 6fh, 70h, 71h, 72h, 73h, 74h, 75h, 76h, 77h, 78h, 79h, 7ah, 41h, 42h, 43h, 44h, 45h, 46h, 47h, 48h, 49h, 4ah, 4bh, 4ch, 4dh, 4eh, 0A5h, 4fh, 50h, 51h, 52h, 53h, 54h, 55h, 56h, 57h, 58h, 59h, 5ah
	abcMod db 54 dup (?)	
	textoMod db 1000 dup (?)
	
	;VARIABLES M
	cociente db ?
	residuo db ?
	arrayBits db 2000 dup (?)
	arrayBitsLE db 2000 dup (?) ;Little endian
	longLetra dw ?
	indiceActual dw ?
	resultadoM db ?
	textoM db 2000 dup (?) 
	indiceTxt dw ?
	
	vectorL1 db 8 dup (?)
	vectorL2 db 8 dup (?)
	vectorL3 db 8 dup (?)
	vectorL4 db 8 dup (?)

	vectorR1 db 8 dup (?)
	vectorR2 db 8 dup (?)
	vectorR3 db 8 dup (?)
	vectorR4 db 8 dup (?)
	
	binarioCaracter1 db 8 dup (?)
	binarioCaracter2 db 8 dup (?)
	binarioCaracter3 db 8 dup (?)
	binarioCaracter4 db 8 dup (?)
	binarioCaracter5 db 8 dup (?)
	binarioCaracter6 db 8 dup (?)
	binarioCaracter7 db 8 dup (?)
	binarioCaracter8 db 8 dup (?)
	
	textoDescifrado db 5000 dup (?)
	textoBinarioD db 8 dup (?)
	caracterBinario db 8 dup (?)
	caracterBinarioLE db 8 dup (?)
	indiceBloque dw ?
	indiceTextoM dw ?
	indiceArrayTexto dw ?
	indiceTextoDescifrar dw ?
	indiceTextoFinal dw ?
	columnaVector dw 7
	  
SDato EndS


;-----------------------------------------------------------------------------------------------------------------------------------------------------------
;	MACROS
;-----------------------------------------------------------------------------------------------------------------------------------------------------------

Include macros.asm
Include macrosCr.asm
Include macroXOR.asm

;-----------------------------------------------------------------------------------------------------------------------------------------------------------

;-----------------------------------------------------------------------------------------------------------------------------------------------------------


SCodigo Segment				
	Assume CS:SCodigo, SS:SPila, DS:SDato;Asignación de los segmentos a los registro de segmentos del CPU.

      GetCommanderLine Proc Near
            LongLC    EQU   80h     ;Cada vez que se pongo LongLC se cambiará a 80h 
            Mov   Bp,Sp 
            Mov   Ax,Es				;ES -> Apunta al PSP
            Mov   Ds,Ax				;Ax -> apunta ahora al segmento de datos
            Mov   Di,2[Bp] 			;Di (Di = 0) -> apuntador a la linea de comandos /Bp apunta al SP
            Mov   Ax,4[Bp]
            Mov   Es,Ax 			;Es -> ahora el Es apunta al segmento de datos
            Xor   Cx,Cx				;Limpia el cx
            Mov   Cl,Byte Ptr Ds:[LongLC] ;Ds apunta al PSP / Pasa al CL la cantidad de caracteres que hay en la linea de comandos
            dec Cl 					;Evitar que agarre el enter (esto se ve en el wacht)
			Mov   Si, 2[LongLC] 	;SI -> ahora tiene 80h más 2    (primera letra sin el espacio en blanco) ;dos = uno por la posición 81h y uno más por el espacio en blanco.
            cld						;Limpia la bandera de dirección
			Rep   Movsb				;Repite tantas veces , osea 12 veces
            Ret 2*2

      GetCommanderLine EndP
	
;------------------------------------------------------;
;                Programa Principal                    ;
;------------------------------------------------------;
Begin:
      Xor Ax,Ax						
      Mov Ax,SDato					;Mueve la posición de SData Al reg Ax.
      Mov DS,Ax						;Mueve la posición de Ax (SData) Al reg DS.
      Xor Ax,Ax
      push ds
	  mov ax, Seg LineCommand
	  push ax
	  Lea ax, LineCommand
	  push ax
	  call GetCommanderLine
	  pop ds
	  mov si, offset LineCommand

	  xor ax,ax						;Lo que se ha leido en la linea de comandos ahora esta en la variable LineCommand
	  
	  cmp LineCommand[si], 'e'		;
	  je agregarMetodoCriptografico	;Se compara la posinion del LineCommand con la opcion de encriptado/descifrado
	  cmp LineCommand[si], 'd'		;
	  je agregarMetodoCriptografico	;
	  
	  cmp LineCommand[si], 'E'		;
	  je cambiarE					;En caso de insertar mayusculas, se cambia a minusculas para manejar un estandar.
	  cmp LineCommand[si], 'D'		;
	  je cambiarD					;
	  
	  cmp LineCommand[si], '['		;Si no se ingresa el tipo se asigna por defecto la opcion de encriptar
	  je encriptarDefecto
	  
	  jmp salgaError1				;Salte error si no se ingreso nada.
	  
;*******************************;
cambiarE:						;
	mov al, 'e'					;
	mov metodoCriptografico, al	;
	jmp leerSiguiente			;	Asignar la letra en minuscula del metodo criptografico
cambiarD:						;
	mov al, 'd'					;
	mov metodoCriptografico, al	;
	jmp leerSiguiente			;
;*******************************;
	  
agregarMetodoCriptografico:
	mov al, LineCommand[si]			;Asignar el metodo escogido por el usuario
	mov metodoCriptografico, al
	jmp leerSiguiente
	

;*******************************************;
encriptarDefecto:							;
	inc si									;
	cmp LineCommand[si], ']'				;
	je agregarMetodoCriptograficoDefecto	;
											;
	jmp salgaError1							; Asingacion del metodo por defecto, en caso de no ingresar uno en la linea de comandos.
											;
agregarMetodoCriptograficoDefecto:			;
											;
	mov al, 'e'								;
	mov metodoCriptografico, al				;
											;
	jmp leerSiguiente						;
;*******************************************;
	
	
leerSiguiente:
	xor di, di
	
	add si, 2
	
	cmp LineCommand[si], '/'
	jne leerNombreArchivo
	
leerAyuda:
	inc si
	cmp LineCommand[si], '?'		;Mostrdo en pantalla de la ayuda
	je imprimirAyuda
	cmp LineCommand[si], 'h'
	je imprimirAyuda
	
	jmp salgaError					;En caso de no ingresar ? o h despues del / salte a error.
		
imprimirAyuda:

	imprimirVariable ayudaVar1
	jmp salga1


leerNombreArchivo:
	cmp LineCommand[si], '['		;Inicio de la lectura del nombre del archivo.
	je leerNombreArchivo2	
	
	jmp salgaError1
	
leerNombreArchivo2:
	inc si
	
leerNombreArchivo3:
	
	cmp LineCommand[si], ']' 		;Recorre el nombre del archivo
	je leerSiguiente2				;Si encuentra ']' indica el final del nombre
	
	mov al, [LineCommand[si]] 		;Se pasa primero al registro. No se pueden pasar datos directamente de memoria a memoria
	mov nombreArchivo[di], al
	 
	inc di
	inc si
	loop leerNombreArchivo3

	
leerSiguiente2:	
	xor di,di
	cmp nombreArchivo, ''			;En caso de no ingresar un nombre de archivo. Se asigna uno por defecto
	je meterNombrePredef
	
	jmp menuMetodo
	
meterNombrePredef:
	
	cmp di, 11 
	je menuMetodo
	mov bl, nombreDefecto[di]		;Asignacion del nombre por defecto -> 'archivo.txt'
	mov nombreArchivo[di], bl
	
	inc di
	jmp meterNombrePredef
	
salga2:	
	mov ax, 4c00h
	int 21h

menuMetodo:							;Encargado de leer el tipo de encriptado
	add si,2
	
	cmp LineCommand[si], '['		;Si no se inserta el tipo, se asigna por defecto
	je Puente_metodoPredefinido
	
	cmp LineCommand[si], '/'		;Simbolo no valido
	jne salga2
	
	inc si
	
	cmp LineCommand[si], 'n'		;
	je guardarOpcion				;
	cmp LineCommand[si], 'm'		;En caso de coincidir se almacena la opcin escogida
	je guardarOpcion				;
	cmp LineCommand[si], 'l'		;
	je guardarOpcionL				;
	
	cmp LineCommand[si], 'M'		;
	je cambiarM						;
	cmp LineCommand[si], 'N'		;En caso de ingresar el tipo de metodo en mayuscula se cambia a minuscula para manejar un estandar
	je cambiarN						;
	cmp LineCommand[si], 'L'		;
	je cambiarL						;
	  
	 
	jmp salgaError1

guardarOpcion:
	mov bl, LineCommand[si]			;Almecena la opcion de encriptado. 'e' o 'd'
	mov opcionProceso, bl
	add si, 2
	xor di,di
	
	jmp leerClave

guardarOpcionL:					
	mov bl, LineCommand[si]			;Guarda la el tipo de encriptacion, en este caso el 'L'
	mov opcionProceso, bl
	add si, 2
	
	mov bl, LineCommand[si]
	mov letraML, bl					;Guarda la letra escogida para hacer el procedimiento
	add si, 2
	xor di,di
	jmp leerClave
	
Puente_metodoPredefinido:
	jmp metodoPredefinido

;***************************;
cambiarM:					;
	mov bl, 'm'				;
	mov opcionProceso, bl	;
	add si, 2				;
	xor di,di				;
	jmp leerClave			;
							;
cambiarN:					;
	mov bl, 'n'				;
	mov opcionProceso, bl	;
	add si, 2				;		Cuando el usuario inserta la opcion de encriptado/descifrado en mayuscula
	xor di,di				;		se cambia por minusculas. Se maneja un estandar en las comparaciones.
	jmp leerClave			;		Solo se se aceptan minusculas.
							;
cambiarL:					;
	mov bl, 'l'				;
	mov opcionProceso, bl	;
	add si, 2				;
	mov bl, LineCommand[si]	;
	mov letraML, bl			;
	add si, 2				;
	xor di,di				;
	jmp leerClave			;
;***************************;

salga1:
	mov ax, 4c00h
	int 21h
salgaError1:
	imprimirVariable errorProcesos
	mov ax, 4c00h
	int 21h
	
metodoPredefinido:					;En caso de no escoger una opcion para encriptar/desencriptar se asigna una por deficion
	 inc si
	 
	 cmp LineCommand[si], ']'
	 je metodoPredefinido1
	 
	 jmp salga1
	 
	metodoPredefinido1: 
	 mov opcionProceso, 'n'			;Se asigna la opcion 'n' por definicion
	 add si, 2
	 xor di, di
	 
	 jmp leerClave					;Se procede a leer la clave


leerClave:
	cmp LineCommand[si], '['		;Inidica el inicio de la clave. Se utilizan '[]' en caso de que la clave contenga espacios.
	je leerClave2
	
	jmp salgaError1					;Caso contrario, muestra el error.
	
leerClave2:
	inc si							;Saltar el simbolo '['
	
leerClave3:
	cmp LineCommand[si], ']' 		;Recorre el nombre de la clave. Cuando encuentra ']' significa que termina la clave.
	je  parada
	
	mov al, LineCommand[si] 		;Se pasa primero al registro. No se pueden pasar datos directamente de memoria a memoria
	mov arrayClave[di], al
	 
	inc di
	inc si
	jmp leerClave3
	
parada:
	xor di,di
	cmp arrayClave, ''				;En caso de no ingresar una clave. Se asigna por definicion.
	je meterClavePredef
	jmp leerW
	
meterClavePredef:					;Asignacion de la clave por definicion
	cmp di, 5 
	je leerW
	mov bl, claveDefecto[di]
	mov arrayClave[di], bl
	
	inc di
	jmp meterClavePredef


leerW:
	xor di,di
	add si,2
	cmp LineCommand[si], '' 		;
	je leerArchivoTxt				;
									;
	cmp LineCommand[si], ' ' 		;Comparaciones para saber si se ingreso la opcion W
	je leerArchivoTxt				;
									;
	cmp LineCommand[si], '/' 		;
	jne leerArchivoTxt
	
	inc si
	
	cmp LineCommand[si], 'w'
	jne leerArchivoTxt
	
	mov al, LineCommand[si] 		;Se pasa primero al registro. No se pueden pasar datos directamente de memoria a memoria
	mov variableW[di], al			;Se almacena la opcion en la variable para luego comparar al final del programa y realizar el procedimiento
	xor di,di
	jmp leerArchivoTxt

leerArchivoTxt:
									;Si el CF es 0, funcionó.
	abrirArchivo nombreArchivo, 3D02h ;ah = 3Dh (abrir el archivo), al = 2 (edicón y lectura)
	
	mov puntero, ax
	
	mov ax, 3f00h 					;El ax tiene el número de bytes leidos.																								
	mov cx, 0FFFFh																						
	lea dx, arrayTexto																										
	mov bx, puntero																												
	int 21h	
	
	cerrarArchivo 3Eh 				;Cerrar el procedimiento del archivo abierto
	
obtenerApuntadorArchivoTxt:			;Abrir un archivo, esta vez solo en modo lectura
	
	abrirArchivo nombreArchivo, 3D00h ;ah = 3Dh (abrir el archivo), al = 0 (solo lectura)

	mov bx,ax           			;Almacena el handle del archivo en bx
    mov ax,4202h        			;ah = 42h, al = 2 (END + cx:dx offset) -> donde bx tiene 'lea dx, nombreArchivo'
    xor cx,cx           
    xor dx,dx           
    int 21h            				;ax almacenará el apuntador del final del archivo
	
	mov longtexto, ax
	
	cerrarArchivo 3Eh 				;Cerrar el procedimiento del archivo abierto
		
limpiarRegistros:
	xor ax, ax					
	xor bx, bx					
	xor di, di
	xor si, si
	xor cx,cx
		
	
recorrerClave:
									;Recorre toda la clave para obtener la longitud
	cmp arrayClave[si], ''			;Comparacion con '' indica que ya pasó por todos los caracteres de la clave
	je sacarLongitud				;Se va a sacarLongitud para hacer la asignación a la variable longClave
		
	inc si
		
	jmp recorrerClave				;Realiza el Loop
	
	sacarLongitud:					
		mov longClave, si			;Asignar la cantidad de la longitud de la clave
		xor si,si					;Una vez almacenado el indice, se borra el SI porque se necesita a la hora de almacenar el bloque de texto en el vector
	

MenuMetodos:						;Se evalua la opcion de encriptado/descifrado escogido por el usuario.
	xor si, si
	xor di, di
	xor ax, ax
	xor bx, bx
	
	cmp metodoCriptografico, 'e'
	je encriptarMetodos				;Salta a evaluar la opcion de encriptados
	
	
	cmp metodoCriptografico, 'd'
	je desencriptarMetodos			;Salta a evaluar la opcion de encriptados
	
;----------------------------------------------------------------------------------------------------------------------------------------------------------------
encriptarMetodos:					;Se evalua cual opcion escogio el usuario para encriptar.
	cmp opcionProceso, 'n'
	je llamarNEncriptar
	
	cmp opcionProceso, 'm'
	je puenteLlamarMEncriptar
	
	cmp opcionProceso, 'l'
	je puenteLlamarLEncriptar
	
;----------------------------------------------------------------------------------------------------------------------------------------------------------------	

desencriptarMetodos:				;Llamada al proceso del XOR en el momento del descifrado
	jmp llamarXORDesencriptar
	
desencriptarMetodos2:				;Se evalua cual opcion escogio el usuario para desencriptar.
	cmp opcionProceso, 'n'
	je llamarNDesencriptar
	
	cmp opcionProceso, 'm'
	je puenteHaciaDescencriptarM_1
	
	cmp opcionProceso, 'l'
	je puentellamarLDesencriptar
	
;----------------------------------------------------------------------------------------------------------------------------------------------------------------
;******************************;
puenteLlamarLEncriptar:        ;
	jmp llamarLEncriptar       ;
puentellamarLDesencriptar:     ;
	jmp llamarLDesencriptar    ;
puenteLlamarMEncriptar:		   ;
	jmp llamarMEncriptar	   ;
;******************************;	

llamarNEncriptar:					;Realiza el encriptado del metodo 'N'. El xor se aplicara despues.
	metodoN arrayTexto, textoCifrado, longClave, longClaveN, longTexto
	
;************************************;
puenteHaciaDescencriptarM_1:		 ;
	jmp puenteHaciaDescencriptarM_2	 ;
;************************************;

llamarNDesencriptar:  				;Al desencriptar realiza el XOR primero y luego lo pasa al método, por lo que en lugar de array texto hay que enviarle textoXOR
	metodoN textoXOR, textoCifrado, longClave, longClaveN, longTexto
	
;************************;
puenteHaciaPProcesos:	 ;
	jmp puenteProcesos   ;
;************************;	

llamarMEncriptar:					;Realiza el encriptado del metodo 'M'. El xor se aplicara despues.
	metodoM longtexto, indiceArrayTexto, arraytexto, textoBloque, indiceBloque, columnaVector, caracterBinario, caracterBinarioLE, cociente, vectorR1, vectorR2, vectorR3, vectorR4, vectorL1, vectorL2, vectorL3, vectorL4, textoCifrado, indiceTextoM, resultadoM

llamarLEncriptar:					;Realiza el encriptado del metodo 'L'. El xor se aplicara despues.
	metodoL letraML, abcMin, abcMod, arrayTexto, longtexto, textoMod, longClaveN, longclave, textoCifrado
	
;*********************************************************************;	
puenteLlamarN:														  ;
	metodoN textoMod, textoCifrado, longClave, longClaveN, longTexto  ;
																	  ;
puenteHaciaDescencriptarM_2:										  ;
	jmp llamarMDesencriptar											  ;
;*********************************************************************;

llamarLDesencriptar:				;Realiza el descifrado del metodo 'L'. El XOR ya se ha aplicado.
	metodoLDesencriptarL letraML, abcMin, abcMod, textoXOR, longtexto, textoMod, longClaveN, longclave, textoCifrado

llamarMDesencriptar:				;Realiza el descifrado del metodo 'M'. El XOR ya se ha aplicado.
	metodoMDescriptar longtexto, indiceTextoDescifrar, textoXOR, textoBloque, indiceBloque, caracterBinario, caracterBinarioLE, cociente, vectorR1, vectorR2, vectorR3, vectorR4, vectorL1, vectorL2, vectorL3, vectorL4, textoBinarioD, resultadoM, indiceTextoFinal, textoCifrado
	
llamarXOREncriptar:					;Realiza el XOR
	realizarXor longTexto, longClave, textoCifrado, textoBloque, textoXOR, arrayClave
	
llamarXORDesencriptar: 				;Al desencriptar se realiza el XOR primero y luego se va al método.
	realizarXor longTexto, longClave, arraytexto, textoBloque, textoXOR, arrayClave
	

;----------------------------------------------------------------------------------------------------------------------------------------------------------------

;*******************************;
puenteLlamarXOREncriptar: 		;
	jmp llamarXOREncriptar		;
								;	
puenteDesencriptarMetodos2:     ;
	jmp desencriptarMetodos2	;
;*******************************;
	
;*************************************;
puenteProcesos:						  ;
	cmp metodoCriptografico, 'e' 	  ; Si es encriptar se llama al XOR primero y luego a escribirArchivo
	je puenteLlamarXOREncriptar		  ; 
									  ;
	cmp metodoCriptografico,'d'		  ;	Si es desencriptar se llama a escribirArchivo, el XOR ya se ha aplicado
	je escribirArchivoDesencriptar    ;
;*************************************;	

;************************************;
puenteXOR:							 ;
	cmp metodoCriptografico,'d'		 ;
	je puenteDesencriptarMetodos2	 ;
									 ;
	cmp metodoCriptografico, 'e'	 ;
	je escribirArchivoEncriptar		 ;
;************************************;

;-------------------------------------------------------------Escribir Archivo-------------------------------------------------------------;

escribirArchivoEncriptar:								;Se envia a una macro el nuevo nombre del archivo (por definicion: result.txt)
	crearArchivo nombreNuevo, textoXOR, longtexto		;el textoXOR y la longitud del texto.
	imprimirVariable msjProcesoTerminado				;Salta a evaluarW para comprobar si es necesario proceder con la opcion
	jmp evaluarW
	
escribirArchivoDesencriptar:						
	cmp opcionProceso, 'l'								;Se comprueba opcionProceso con 'l', si es cierto, salta a la etiqueta para escribir
	je escribirArchivoDesencriptar_L					;el archivo pero con 'textoMod'

	crearArchivo nombreNuevo, textoCifrado, longtexto	;En caso de ser la opcion 'n' o 'm', se crea y escribe en el archivo utilizando
	imprimirVariable msjProcesoTerminado				;'textoCifrado'.
	jmp evaluarW										;Salta a evaluarW para comprobar si es necesario proceder con la opcion
	
escribirArchivoDesencriptar_L:							
	crearArchivo nombreNuevo, textoMod, longtexto		;En caso de ser la opcion 'l' el archivo se crea con 'textoMod'
	imprimirVariable msjProcesoTerminado
	jmp evaluarW										;Salta a evaluarW para comprobar si es necesario proceder con la opcion

;*******************************************************;
evaluarW:												;
	xor si,si											;
	xor bx,bx											; Se encarga de realizar la opcion /W
	cmp variableW[di], 'w'								;
	je procesoW											;
														;
	jmp salga											;
														; Se maneja un array nuevo (cerosW) que seguidamente
	procesoW:											; mediante la longitud del texto se escribiran
		cmp si, longtexto								; ceros en el archivo.
		je procesoW2									; Es la ultima opcion a evaluar. Si el usuario no selecciono
														; /w en la linea de comandos termina el programa. Caso contrario
		mov bl, '0'										; se realizar la opcion /w.
		mov cerosW[si], bl								;
														;
		inc si											;
		jmp procesoW									;
														;
	procesoW2:											;
		crearArchivo nombreArchivo, cerosW, longtexto	;
		xor si,si										;
		xor bx,bx										;
		jmp salga										;
														;
;*******************************************************;
	
salga:
	mov ax, 4c00h
	int 21h

	
salgaError:
	imprimirVariable errorProcesos
	mov ax, 4c00h
	int 21h
	
	  
	  
SCodigo EndS									;Fin del segmento de código.
      End Begin									;Fin del programa la etiqueta Al final dice en que punto debe comenzar el programa.
	  