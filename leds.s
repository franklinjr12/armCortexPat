	THUMB
		
	; -------------------------------------------------------------------------------
	; �rea de C�digo - Tudo abaixo da diretiva a seguir ser� armazenado na mem�ria de 
	;                  c�digo
			AREA    |.text|, CODE, READONLY, ALIGN=2
				
		IMPORT  SysTick_Wait1ms
		IMPORT  SysTick_Wait1us
        IMPORT  PortA_Output
		IMPORT  PortB_Output
		IMPORT  PortQ_Output	
			
			
			
	ALIGN
	END