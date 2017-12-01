crearArchivo Macro nombreArchivo, texto, longTexto
	xor ax,ax
	xor si,si
	xor di,di
	xor bx,bx
	
	mov ah,3ch ;instrucción para crear el archivo.
	mov cx, 0
	mov dx,offset nombreArchivo ;crea el archivo con el nombre archivo2.txt indicado indicado en la parte .data
	int 21h
		
	xor si, si
	
	mov si, longTexto

	mov ah,3dh
	mov al,1h ;Abrimos el archivo en solo escritura.
	mov dx,offset nombreArchivo
	int 21h

	;Escritura de archivo
	mov bx,ax ; mover hadfile
	mov cx,si ;num de caracteres a grabar
	mov dx,offset texto
	mov ah,40h
	int 21h
		
EndM

abrirArchivo Macro nombreArchivo, tipoInstruccion
	mov ax, tipoInstruccion
    lea dx, [nombreArchivo]
    int 21h
EndM

cerrarArchivo Macro tipoInstruccion
	mov ah, tipoInstruccion 
    int 21h 
EndM
	
imprimirVariable Macro variable
	
	mov ah, 09h
	mov dx, offset variable
	int 21h
	
EndM
