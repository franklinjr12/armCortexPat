; main.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; Ver 1 19/03/2018
; Ver 2 26/08/2018
; Este programa deve esperar o usuário pressionar uma chave.
; Caso o usuário pressione uma chave, um LED deve piscar a cada 1 segundo.

; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
		
; Declarações EQU - Defines
;<NOME>         EQU <VALOR>
; ========================
; Definições de Valores
BIT0	EQU 2_0001
BIT1	EQU 2_0010

; -------------------------------------------------------------------------------
; Área de Dados - Declarações de variáveis
		AREA  DATA, ALIGN=2
		; Se alguma variável for chamada em outro arquivo
		;EXPORT  <var> [DATA,SIZE=<tam>]   ; Permite chamar a variável <var> a 
		                                   ; partir de outro arquivo
;<var>	SPACE <tam>                        ; Declara uma variável de nome <var>
                                           ; de <tam> bytes a partir da primeira 
                                           ; posição da RAM	
										   
contador SPACE 1
velocidadeContagem SPACE 1
controleLeds SPACE 1
posicaoLeds SPACE 1


; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma função do arquivo for chamada em outro arquivo	
        EXPORT Start                ; Permite chamar a função Start a partir de 
			                        ; outro arquivo. No caso startup.s
									
		; Se chamar alguma função externa	
        ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma 
									; função <func>
		IMPORT  PLL_Init
		IMPORT  SysTick_Init
		IMPORT  SysTick_Wait1ms
		IMPORT  SysTick_Wait1us
		IMPORT  GPIO_Init
        IMPORT  PortA_Output
		IMPORT  PortB_Output
		IMPORT  PortQ_Output
        IMPORT  PortJ_Input
		IMPORT  mostra_Num


; -------------------------------------------------------------------------------
; Função main()
Start  		
	BL PLL_Init                  ;Chama a subrotina para alterar o clock do microcontrolador para 80MHz
	BL SysTick_Init              ;Chama a subrotina para inicializar o SysTick
	BL GPIO_Init                 ;Chama a subrotina que inicializa os GPIO

	;valores iniciais das variaveis
	LDR R4, =contador
	LDRB R5, [R4]
	MOV R5, #0
	STRB R5, [R4]
	
	LDR R4, =velocidadeContagem
	LDRB R5, [R4]
	MOV R5, #1
	STRB R5, [R4]

	LDR R4, =controleLeds
	LDRB R5, [R4]
	MOV R5, #1
	STRB R5, [R4]

	LDR R4, =posicaoLeds
	LDRB R5, [R4]
	MOV R5, #0
	STRB R5, [R4]


MainLoop
; ****************************************
; Escrever código que lê o estado da chave, se ela estiver desativada apaga o LED
; Se estivar ativada chama a subrotina Pisca_LED
; ****************************************

	MOV R0, #16
	BL SysTick_Wait1ms

	; -------------------------------------------------------------------------------
	;1-
	;verifica chave
	BL PortJ_Input
	PUSH{R0}
	
	;sw1 pressionada
	CMP R0, #2_00000010
	BLEQ aumenta_Vel_Contagem

	;sw2 pressionada
	POP{R0}
	CMP R0, #2_00000001
	BLEQ diminui_Vel_Contagem
	
	;verificar contagem
	LDR R4, =contador
	LDRB R5, [R4]
	PUSH{R5}
	CMP R5, #99
	BLLT aumenta_Contagem
	POP{R5}
	CMP R5, #99
	BLGE zera_Contagem
	
	;mostrar contagem no display
	BL separa_Digitos
	LDR R8, =100
mostra_Loop	
	CMP R8, #0
	BEQ acaba_mostra_loop
	PUSH{R1}
	MOV R1, #0
	BL mostra_Num
	POP{R1}
	MOV R0, R1
	MOV R1, #1
	BL mostra_Num
	SUB R8, #1
	B mostra_Loop
acaba_mostra_loop
	B MainLoop
	
	; -------------------------------------------------------------------------------
	
	; -------------------------------------------------------------------------------
	;2-

	;acendendo do menor para o maior
	LDR R4, =controleLeds
	LDR R5, [R4]
	CMP R5, #1
	BLEQ acender_Menor_Maior
	
	;apagando do menor para o maior
	LDR R4, =controleLeds
	LDR R5, [R4]
	CMP R5, #2
	BLEQ apagar_Menor_Maior
	
	;acendendo do maior para o menor
	LDR R4, =controleLeds
	LDR R5, [R4]
	CMP R5, #3
	BLEQ acender_Maior_Menor

	;acendendo do menor para o maior
	LDR R4, =controleLeds
	LDR R5, [R4]
	CMP R5, #4
	BLEQ apagar_Maior_Menor

	; -------------------------------------------------------------------------------

	
	B MainLoop

; -------------------------------------------------------------------------------
;controle dos LEDs
acender_Menor_Maior

	LDR R4, =posicaoLeds
	LDR R5, [R4]
	;verifica se todos os LEDs estao acesos
	CMP R5, #7
	

	BX LR
	
apagar_Menor_Maior

	LDR R4, =posicaoLeds
	LDR R5, [R4]
	;verifica se todos os LEDs estao acesos
	CMP R5, #7
	

	BX LR	

acender_Maior_Menor

	LDR R4, =posicaoLeds
	LDR R5, [R4]
	;verifica se todos os LEDs estao acesos
	CMP R5, #7
	

	BX LR

apagar_Maior_Menor

	LDR R4, =posicaoLeds
	LDR R5, [R4]
	;verifica se todos os LEDs estao acesos
	CMP R5, #7
	

	BX LR


; -------------------------------------------------------------------------------


; -------------------------------------------------------------------------------
;retorna a dezena em R1 e a unidade em R0
separa_Digitos

	PUSH{LR}

	LDR R5, =contador
	LDRB R6, [R5]
	MOV R7, #10
loop_Separa
	CMP R6, R7
	ITE GT
		ADDGT R7, #10
		BLLE separacao
	B loop_Separa
fim_Loop_Separa
	POP{LR}
	BX LR

;usa R7 e R6
separacao

	SUB R7, #10
	MOV R1, R7
	SUB R0, R7, R6

	B fim_Loop_Separa
; -------------------------------------------------------------------------------


; -------------------------------------------------------------------------------
;controle de contagem

aumenta_Contagem

	LDR R4, =contador
	LDRB R5, [R4]
	ADD R5, #1
	STRB R5, [R4]

	BX LR

zera_Contagem

	LDR R4, =contador
	MOV R5, #0
	STRB R5, [R4]	

	BX LR

aumenta_Vel_Contagem
	
	LDR R4, =velocidadeContagem
	LDRB R5, [R4]
	CMP R5, #9
	IT LT
		ADDLT R5, #1
	STRB R5, [R4]
	
	BX LR

diminui_Vel_Contagem
	
	LDR R4, =velocidadeContagem
	LDRB R5, [R4]
	CMP R5, #1
	IT GT
		SUBGT R5, #1
	STRB R5, [R4]
	
	BX LR
; -------------------------------------------------------------------------------



; -------------------------------------------------------------------------------------------------------------------------
; Fim do Arquivo
; -------------------------------------------------------------------------------------------------------------------------	
    ALIGN                        ;Garante que o fim da seção está alinhada 
    END                          ;Fim do arquivo
