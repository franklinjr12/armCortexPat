

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
		EXPORT  mostra_Num
				
				
;Recebe o número a ser mostrado em R0 e o display a ser mostrado em R1
mostra_Num
	PUSH {LR}
	PUSH{R1}
	

	CMP R0, #0
	BLEQ prepara_Zero

	CMP R0, #1
	BLEQ prepara_Um

	CMP R0, #2
	BLEQ prepara_Dois

	CMP R0, #3
	BLEQ prepara_Tres

	CMP R0, #4
	BLEQ prepara_Quatro

	CMP R0, #5
	BLEQ prepara_Cinco

	CMP R0, #6
	BLEQ prepara_Seis

	CMP R0, #7
	BLEQ prepara_Sete

	CMP R0, #8
	BLEQ prepara_Oito

	CMP R0, #9
	BLEQ prepara_Nove

volta_Mostra

	POP {R1}
	CMP R1, #1
	BLEQ acende_7s1
	CMP R1, #0
	BLEQ acende_7s2

	POP {LR}
	BX LR


acende_7s1
	PUSH{LR}
	
	MOV R0, #0x10
	BL PortB_Output
	MOV R0, #1
	BL SysTick_Wait1ms
	MOV R0, #0
	BL PortB_Output
	BL SysTick_Wait1ms
	
	POP{LR}
	BX LR

acende_7s2
	PUSH{LR}
	
	MOV R0, #2_00100000
	BL PortB_Output
	MOV R0, #1
	BL SysTick_Wait1ms
	MOV R0, #0
	BL PortB_Output
	BL SysTick_Wait1ms
	
	POP{LR}
	BX LR

prepara_Zero
	PUSH{LR}
	
	MOV R0, #2_00001111
	BL PortQ_Output
	
	MOV R0, #2_00110000
	BL PortA_Output
	
	POP{LR}
	BX LR
	
prepara_Um
	PUSH{LR}
	
	MOV R0, #2_00000011
	BL PortQ_Output
	
	MOV R0, #2_00000000
	BL PortA_Output
	
	POP{LR}
	BX LR

prepara_Dois
	PUSH{LR}
	
	MOV R0, #2_00001011
	BL PortQ_Output
	
	MOV R0, #2_01010000
	BL PortA_Output
	
	POP{LR}
	BX LR

prepara_Tres
	PUSH{LR}
	
	MOV R0, #2_00001111
	BL PortQ_Output
	
	MOV R0, #2_01000000
	BL PortA_Output
	
	POP{LR}
	BX LR

prepara_Quatro
	PUSH{LR}
	
	MOV R0, #2_00000110
	BL PortQ_Output
	
	MOV R0, #2_01000000
	BL PortA_Output
	
	POP{LR}
	BX LR

prepara_Cinco
	PUSH{LR}
	
	MOV R0, #2_00001101
	BL PortQ_Output
	
	MOV R0, #2_01100000
	BL PortA_Output
	
	POP{LR}
	BX LR

prepara_Seis
	PUSH{LR}
	
	MOV R0, #2_00001101
	BL PortQ_Output
	
	MOV R0, #2_01110000
	BL PortA_Output
	
	POP{LR}
	BX LR

prepara_Sete
	PUSH{LR}
	
	MOV R0, #2_00000111
	BL PortQ_Output
	
	MOV R0, #2_00000000
	BL PortA_Output
	
	POP{LR}
	BX LR

prepara_Oito
	PUSH{LR}
	
	MOV R0, #2_00001111
	BL PortQ_Output
	
	MOV R0, #2_01110000
	BL PortA_Output
	
	POP{LR}
	BX LR

prepara_Nove
	PUSH{LR}
	
	MOV R0, #2_00001111
	BL PortQ_Output
	
	MOV R0, #2_01100000
	BL PortA_Output
	
	POP{LR}
	BX LR

	
	ALIGN
	END