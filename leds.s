	THUMB
		
	; -------------------------------------------------------------------------------
	; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
	;                  código
			AREA    |.text|, CODE, READONLY, ALIGN=2
				
		IMPORT  SysTick_Wait1ms
		IMPORT  SysTick_Wait1us
        IMPORT  PortA_Output
		IMPORT  PortB_Output
		IMPORT  PortQ_Output	
			
			
			
	ALIGN
	END