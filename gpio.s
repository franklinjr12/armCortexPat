; gpio.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; Ver 1 19/03/2018
; Ver 2 26/08/2018

; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declarações EQU - Defines
; ========================
; Definições de Valores
BIT0	EQU 2_0001
BIT1	EQU 2_0010
; ========================
; Definições dos Registradores Gerais
SYSCTL_RCGCGPIO_R	 EQU	0x400FE608
SYSCTL_PRGPIO_R		 EQU    0x400FEA08
; ========================
; Definições dos Ports
; PORT A
GPIO_PORTA_AHB_AMSEL_R   	EQU    0x40058528
GPIO_PORTA_AHB_PCTL_R    	EQU    0x4005852C
GPIO_PORTA_AHB_DIR_R     	EQU    0x40058400
GPIO_PORTA_AHB_AFSEL_R   	EQU    0x40058420
GPIO_PORTA_AHB_DEN_R     	EQU    0x4005851C	
GPIO_PORTA_AHB_DATA_R    	EQU    0x400583FC
; PORT B
GPIO_PORTB_AHB_AMSEL_R   	EQU    0x40059528
GPIO_PORTB_AHB_PCTL_R    	EQU    0x4005952C
GPIO_PORTB_AHB_DIR_R     	EQU    0x40059400
GPIO_PORTB_AHB_AFSEL_R   	EQU    0x40059420
GPIO_PORTB_AHB_DEN_R     	EQU    0x4005951C	
GPIO_PORTB_AHB_DATA_R    	EQU    0x400593FC	
; PORT J
GPIO_PORTJ_AHB_LOCK_R    	EQU    0x40060520
GPIO_PORTJ_AHB_CR_R      	EQU    0x40060524
GPIO_PORTJ_AHB_AMSEL_R   	EQU    0x40060528
GPIO_PORTJ_AHB_PCTL_R    	EQU    0x4006052C
GPIO_PORTJ_AHB_DIR_R     	EQU    0x40060400
GPIO_PORTJ_AHB_AFSEL_R   	EQU    0x40060420
GPIO_PORTJ_AHB_DEN_R     	EQU    0x4006051C
GPIO_PORTJ_AHB_PUR_R     	EQU    0x40060510	
GPIO_PORTJ_AHB_DATA_R    	EQU    0x400603FC
GPIO_PORTJ               	EQU    2_000000100000000
; PORT N
GPIO_PORTN_AHB_LOCK_R    	EQU    0x40064520
GPIO_PORTN_AHB_CR_R      	EQU    0x40064524
GPIO_PORTN_AHB_AMSEL_R   	EQU    0x40064528
GPIO_PORTN_AHB_PCTL_R    	EQU    0x4006452C
GPIO_PORTN_AHB_DIR_R     	EQU    0x40064400
GPIO_PORTN_AHB_AFSEL_R   	EQU    0x40064420
GPIO_PORTN_AHB_DEN_R     	EQU    0x4006451C
GPIO_PORTN_AHB_PUR_R     	EQU    0x40064510	
GPIO_PORTN_AHB_DATA_R    	EQU    0x400643FC
GPIO_PORTN               	EQU    2_001000000000000	
; PORT P
GPIO_PORTP_AHB_AMSEL_R   	EQU    0x40065528
GPIO_PORTP_AHB_PCTL_R    	EQU    0x4006552C
GPIO_PORTP_AHB_DIR_R     	EQU    0x40065400
GPIO_PORTP_AHB_AFSEL_R   	EQU    0x40065420
GPIO_PORTP_AHB_DEN_R     	EQU    0x4006551C
GPIO_PORTP_AHB_DATA_R    	EQU    0x400653FC	
; PORT Q
GPIO_PORTQ_AHB_AMSEL_R   	EQU    0x40066528
GPIO_PORTQ_AHB_PCTL_R    	EQU    0x4006652C
GPIO_PORTQ_AHB_DIR_R     	EQU    0x40066400
GPIO_PORTQ_AHB_AFSEL_R   	EQU    0x40066420
GPIO_PORTQ_AHB_DEN_R     	EQU    0x4006651C
GPIO_PORTQ_AHB_DATA_R    	EQU    0x400663FC	

; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma função do arquivo for chamada em outro arquivo	
        EXPORT GPIO_Init            ; Permite chamar GPIO_Init de outro arquivo
		EXPORT PortA_Output			; Permite chamar PortN_Output de outro arquivo
		EXPORT PortB_Output	
		EXPORT PortJ_Input          ; Permite chamar PortJ_Input de outro arquivo
		EXPORT PortN_Output
		EXPORT PortQ_Output

;--------------------------------------------------------------------------------
; Função GPIO_Init
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
GPIO_Init
;=====================
; ****************************************
; Escrever função de inicialização dos GPIO
; Inicializar as portas J e N
; ****************************************

	PUSH {LR}

	;set o clock para A, B, J, P e Q
	LDR R4, =SYSCTL_RCGCGPIO_R
	LDR R6, =2_110000100000011
	LDR R5, [R4]
	ORR R5, R6
	STR R5, [R4]

	;verificar no PRGPIO se a porta está pronta para uso
	LDR R4, =SYSCTL_PRGPIO_R
	LDR R7, =2_110000100000011
wait_PRGPIO						
	LDR R5, [R4]
	CMP R5, R7
	BNE	wait_PRGPIO
	
	;Desabilitar a funcionalidade analógica, limpando os bits no registrador
	LDR R4, =GPIO_PORTA_AHB_AMSEL_R
	MOV R5, #0
	STR R5, [R4]

	LDR R4, =GPIO_PORTB_AHB_AMSEL_R
	MOV R5, #0
	STR R5, [R4]

	LDR R4, =GPIO_PORTJ_AHB_AMSEL_R
	MOV R5, #0
	STR R5, [R4]

	LDR R4, =GPIO_PORTP_AHB_AMSEL_R
	MOV R5, #0
	STR R5, [R4]

	LDR R4, =GPIO_PORTQ_AHB_AMSEL_R
	MOV R5, #0
	STR R5, [R4]

	;Selecionar a funcionalidade de GPIO limpando os bits no registrador 
	
	LDR R4, =GPIO_PORTA_AHB_PCTL_R
	MOV R5, #0
	STR R5, [R4]	

	LDR R4, =GPIO_PORTB_AHB_PCTL_R
	MOV R5, #0
	STR R5, [R4]	


	LDR R4, =GPIO_PORTJ_AHB_PCTL_R
	MOV R5, #0
	STR R5, [R4]

	LDR R4, =GPIO_PORTP_AHB_PCTL_R
	MOV R5, #0
	STR R5, [R4]

	LDR R4, =GPIO_PORTQ_AHB_PCTL_R
	MOV R5, #0
	STR R5, [R4]
	
	;Especificar se o pino é de entrada ou saída limpando ou setando, respectivamente os bits no registrador
	
	LDR R4, =GPIO_PORTA_AHB_DIR_R
	MOV R5, #2_11110000
	STR R5, [R4]	

	LDR R4, =GPIO_PORTB_AHB_DIR_R
	MOV R5, #2_00110000
	STR R5, [R4]

	LDR R4, =GPIO_PORTJ_AHB_DIR_R
	MOV R5, #2_00
	STR R5, [R4]	

	LDR R4, =GPIO_PORTP_AHB_DIR_R
	MOV R5, #2_00100000
	STR R5, [R4]	

	LDR R4, =GPIO_PORTQ_AHB_DIR_R
	MOV R5, #2_00001111
	STR R5, [R4]	

	;Como o objetivo é utilizar os pinos como GPIO e não função alternativa limpar os bits correspondentes no registrador
	
	LDR R4, =GPIO_PORTA_AHB_AFSEL_R
	MOV R5, #0
	STR R5, [R4]	

	LDR R4, =GPIO_PORTB_AHB_AFSEL_R
	MOV R5, #0
	STR R5, [R4]	

	LDR R4, =GPIO_PORTJ_AHB_AFSEL_R
	MOV R5, #0
	STR R5, [R4]	

	LDR R4, =GPIO_PORTP_AHB_AFSEL_R
	MOV R5, #0
	STR R5, [R4]	


	LDR R4, =GPIO_PORTQ_AHB_AFSEL_R
	MOV R5, #0
	STR R5, [R4]	

	;Habilitar a funcionalidade de entrada e saída digital no registrador
	
	LDR R4, =GPIO_PORTA_AHB_DEN_R
	LDR R5, [R4]
	ORR R5, #2_11110000
	STR R5, [R4]		
	
	LDR R4, =GPIO_PORTB_AHB_DEN_R
	LDR R5, [R4]
	ORR R5, #2_00110000
	STR R5, [R4]		

	LDR R4, =GPIO_PORTJ_AHB_DEN_R
	LDR R5, [R4]
	ORR R5, #2_00000011
	STR R5, [R4]	

	LDR R4, =GPIO_PORTP_AHB_DEN_R
	LDR R5, [R4]
	ORR R5, #2_00100000
	STR R5, [R4]	

	LDR R4, =GPIO_PORTQ_AHB_DEN_R
	LDR R5, [R4]
	ORR R5, #2_00001111
	STR R5, [R4]	

	;Habilitar um resistor de pull-uppara entrada importante para operação com chaves no registrador
	LDR R4, =GPIO_PORTJ_AHB_PUR_R
	LDR R5, [R4]
	ORR R5, #2_00000011
	STR R5, [R4]	

	POP{LR}
	BX LR


; -------------------------------------------------------------------------------
; Função PortA_Output
; Parâmetro de entrada: R0
; Parâmetro de saída: Não tem
PortA_Output
; ****************************************
; Escrever função que acende ou apaga o LED
; ****************************************
	LDR R4, =GPIO_PORTA_AHB_DATA_R
	STR R0, [R4]
	
	BX LR

; -------------------------------------------------------------------------------
; Função PortB_Output
; Parâmetro de entrada: R0
; Parâmetro de saída: Não tem
PortB_Output
; ****************************************
; Escrever função que acende ou apaga o LED
; ****************************************
	LDR R4, =0x400593FC;GPIO_PORTB_AHB_DATA_R
	STR R0, [R4]
	
	BX LR


; -------------------------------------------------------------------------------
; Função PortN_Output
; Parâmetro de entrada: 
; Parâmetro de saída: Não tem
PortN_Output
; ****************************************
; Escrever função que acende ou apaga o LED
; ****************************************
	LDR R4, =GPIO_PORTN_AHB_DATA_R
	MOV R5, #1
	STR R5, [R4]
	
	BX LR
; -------------------------------------------------------------------------------
; Função PortJ_Input
; Parâmetro de entrada: Não tem
; Parâmetro de saída: R0 --> o valor da leitura
PortJ_Input
; ****************************************
; Escrever função que lê a chave e retorna 
; um registrador se está ativada ou não
; ****************************************
	LDR R4, =GPIO_PORTJ_AHB_DATA_R
	LDR R0, [R4]

	BX LR

; -------------------------------------------------------------------------------
; Função PortP_Output
; Parâmetro de entrada: R0
; Parâmetro de saída: Não tem
PortP_Output
; ****************************************
; Escrever função que acende ou apaga o LED
; ****************************************
	LDR R4, =GPIO_PORTP_AHB_DATA_R
	STR R0, [R4]
	
	BX LR

; -------------------------------------------------------------------------------
; Função PortQ_Output
; Parâmetro de entrada: R0
; Parâmetro de saída: Não tem
PortQ_Output
; ****************************************
; Escrever função que acende ou apaga o LED
; ****************************************
	LDR R4, =GPIO_PORTQ_AHB_DATA_R
	STR R0, [R4]
	
	BX LR


    ALIGN                           ; garante que o fim da seção está alinhada 
    END                             ; fim do arquivo