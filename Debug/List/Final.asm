
;CodeVisionAVR C Compiler V3.38 Evaluation
;(C) Copyright 1998-2019 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Mode 2
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD2M
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _inputPc=R4
	.DEF _inputPc_msb=R5
	.DEF _id=R6
	.DEF _id_msb=R7
	.DEF _inputPc_2=R8
	.DEF _inputPc_2_msb=R9
	.DEF _x=R10
	.DEF _x_msb=R11
	.DEF __lcd_x=R13
	.DEF __lcd_y=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _exp0
	JMP  _ext1
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0

_0x3:
	.DB  0x6F,0x0,0x7E,0x0,0x80,0x0,0x82,0x0
	.DB  0x84
_0x0:
	.DB  0x45,0x6E,0x74,0x65,0x72,0x20,0x27,0x2A
	.DB  0x27,0x20,0x74,0x6F,0x20,0xA,0x20,0x73
	.DB  0x74,0x61,0x72,0x74,0x20,0x21,0x20,0x0
	.DB  0x45,0x6E,0x74,0x65,0x72,0x20,0x2A,0xA
	.DB  0x0,0x45,0x6E,0x74,0x65,0x72,0x20,0x79
	.DB  0x6F,0x75,0x72,0x20,0x49,0x44,0xA,0x0
	.DB  0x49,0x6E,0x76,0x61,0x6C,0x69,0x64,0x20
	.DB  0x49,0x44,0xA,0x20,0x45,0x6E,0x74,0x65
	.DB  0x72,0x20,0x2A,0x0,0x45,0x6E,0x74,0x65
	.DB  0x72,0x20,0x79,0x6F,0x75,0x72,0x20,0x50
	.DB  0x43,0xA,0x0,0x57,0x65,0x6C,0x63,0x6F
	.DB  0x6D,0x65,0x2C,0x20,0x50,0x72,0x6F,0x66
	.DB  0xA,0x0,0x57,0x65,0x6C,0x63,0x6F,0x6D
	.DB  0x65,0x2C,0xA,0x20,0x4D,0x6F,0x68,0x65
	.DB  0x6D,0x6D,0x65,0x64,0xA,0x0,0x57,0x65
	.DB  0x6C,0x63,0x6F,0x6D,0x65,0x2C,0x20,0x53
	.DB  0x68,0x65,0x72,0x69,0x66,0xA,0x0,0x57
	.DB  0x65,0x6C,0x63,0x6F,0x6D,0x65,0x2C,0x20
	.DB  0x41,0x68,0x6D,0x65,0x64,0xA,0x0,0x57
	.DB  0x65,0x6C,0x63,0x6F,0x6D,0x65,0x2C,0x20
	.DB  0x4A,0x6F,0x6A,0x6F,0xA,0x0,0x57,0x72
	.DB  0x6F,0x6E,0x67,0x20,0x70,0x61,0x73,0x73
	.DB  0x63,0x6F,0x64,0x65,0xA,0x20,0x45,0x6E
	.DB  0x74,0x65,0x72,0x20,0x2A,0x0,0x25,0x75
	.DB  0x0,0x45,0x6E,0x74,0x65,0x72,0x20,0x6F
	.DB  0x6C,0x64,0x20,0x50,0x43,0x0,0x45,0x6E
	.DB  0x74,0x65,0x72,0x20,0x6E,0x65,0x77,0x20
	.DB  0x50,0x43,0x0,0x52,0x65,0x2D,0x65,0x6E
	.DB  0x74,0x65,0x72,0x20,0x6E,0x65,0x77,0x20
	.DB  0x50,0x43,0x0,0x4E,0x65,0x77,0x20,0x50
	.DB  0x43,0x20,0x73,0x74,0x6F,0x72,0x65,0x64
	.DB  0x0,0x50,0x43,0x73,0x20,0x61,0x72,0x65
	.DB  0x20,0x6E,0x6F,0x74,0x20,0x49,0x64,0x65
	.DB  0x6E,0x74,0x69,0x63,0x61,0x6C,0x0,0x45
	.DB  0x6E,0x74,0x65,0x72,0x20,0x41,0x64,0x6D
	.DB  0x69,0x6E,0x20,0x50,0x43,0x0,0x45,0x6E
	.DB  0x74,0x65,0x72,0x20,0x73,0x74,0x75,0x64
	.DB  0x65,0x6E,0x74,0x20,0x49,0x44,0x0,0x50
	.DB  0x43,0x20,0x69,0x73,0x20,0x73,0x74,0x6F
	.DB  0x72,0x65,0x64,0x0,0x43,0x6F,0x6E,0x74
	.DB  0x61,0x63,0x74,0x20,0x41,0x64,0x6D,0x69
	.DB  0x6E,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  0x0A
	.DW  __REG_VARS*2

	.DW  0x09
	.DW  _validIDs
	.DW  _0x3*2

	.DW  0x18
	.DW  _0x8
	.DW  _0x0*2

	.DW  0x09
	.DW  _0x8+24
	.DW  _0x0*2+24

	.DW  0x0F
	.DW  _0x8+33
	.DW  _0x0*2+33

	.DW  0x14
	.DW  _0x8+48
	.DW  _0x0*2+48

	.DW  0x0F
	.DW  _0x8+68
	.DW  _0x0*2+68

	.DW  0x0F
	.DW  _0x8+83
	.DW  _0x0*2+83

	.DW  0x14
	.DW  _0x8+98
	.DW  _0x0*2+98

	.DW  0x11
	.DW  _0x8+118
	.DW  _0x0*2+118

	.DW  0x10
	.DW  _0x8+135
	.DW  _0x0*2+135

	.DW  0x0F
	.DW  _0x8+151
	.DW  _0x0*2+151

	.DW  0x18
	.DW  _0x8+166
	.DW  _0x0*2+166

	.DW  0x0F
	.DW  _0x8A
	.DW  _0x0*2+33

	.DW  0x14
	.DW  _0x8A+15
	.DW  _0x0*2+48

	.DW  0x0D
	.DW  _0x8A+35
	.DW  _0x0*2+193

	.DW  0x0D
	.DW  _0x8A+48
	.DW  _0x0*2+206

	.DW  0x10
	.DW  _0x8A+61
	.DW  _0x0*2+219

	.DW  0x0E
	.DW  _0x8A+77
	.DW  _0x0*2+235

	.DW  0x16
	.DW  _0x8A+91
	.DW  _0x0*2+249

	.DW  0x0F
	.DW  _0x8F
	.DW  _0x0*2+271

	.DW  0x11
	.DW  _0x8F+15
	.DW  _0x0*2+286

	.DW  0x0D
	.DW  _0x8F+32
	.DW  _0x0*2+206

	.DW  0x0D
	.DW  _0x8F+45
	.DW  _0x0*2+303

	.DW  0x0E
	.DW  _0x8F+58
	.DW  _0x0*2+316

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0x00

	.DSEG
	.ORG 0x160

	.CSEG
;#include <mega16.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <alcd.h>
;#include <delay.h>
;#include <stdbool.h>
;bool isValidId(int id); //to check the id entered stored
;int getInput(); //to change three digits to integer
;unsigned char keypad(); //the get number from keypad
;unsigned char EE_Read(unsigned int inputadd);// to get data from EEPROM
;void EE_Write(unsigned int inputadd, unsigned int PC); // to write data in address
;void Peep();
;int   inputPc , id , inputPc_2 ;
;int x = 0 ;
;int validIDs[5] = {111, 126, 128, 130, 132};

	.DSEG
;
;void main(void)
; 0000 0010 {

	.CSEG
_main:
; .FSTART _main
; 0000 0011 
; 0000 0012 	unsigned char passcode;
; 0000 0013 	DDRD = 0b11110011 ; // set port D as output all 1 for motor and buzzer
;	passcode -> R17
	LDI  R30,LOW(243)
	OUT  0x11,R30
; 0000 0014 	MCUCR = 1 << ISC01 | 1 << ISC00; //choosing the rising edge inttrupt
	LDI  R30,LOW(3)
	OUT  0x35,R30
; 0000 0015 	MCUCR = 1 << ISC01 | 1 << ISC00; // Trigger INT0 on rising edge
	OUT  0x35,R30
; 0000 0016 	GICR |= 1 << 6;     //Specific interrupt enable
	IN   R30,0x3B
	ORI  R30,0x40
	OUT  0x3B,R30
; 0000 0017 	MCUCR = 0 << ISC01 | 0 << ISC00; //choosing the low level trigger inttrupt
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 0018 	GICR |= 1 << 7;     //Specific interrupt enable
	IN   R30,0x3B
	ORI  R30,0x80
	OUT  0x3B,R30
; 0000 0019 	PORTD.1 = 1;
	SBI  0x12,1
; 0000 001A 	PORTD.2 = 1;
	SBI  0x12,2
; 0000 001B 	DDRB = 0b00000111; // Port B for Keypad
	LDI  R30,LOW(7)
	OUT  0x17,R30
; 0000 001C 	PORTB = 0b11111000;
	LDI  R30,LOW(248)
	OUT  0x18,R30
; 0000 001D 	////mapping the EEPROM
; 0000 001E 	EE_Write(validIDs[0], 203);
	RCALL SUBOPT_0x0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(203)
	LDI  R27,0
	RCALL _EE_Write
; 0000 001F 	EE_Write(validIDs[1], 129);
	__GETW1MN _validIDs,2
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(129)
	LDI  R27,0
	RCALL _EE_Write
; 0000 0020 	EE_Write(validIDs[2], 325);
	__GETW1MN _validIDs,4
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(325)
	LDI  R27,HIGH(325)
	RCALL _EE_Write
; 0000 0021 	EE_Write(validIDs[3], 426);
	__GETW1MN _validIDs,6
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(426)
	LDI  R27,HIGH(426)
	RCALL _EE_Write
; 0000 0022 	EE_Write(validIDs[4], 179);
	__GETW1MN _validIDs,8
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(179)
	LDI  R27,0
	RCALL _EE_Write
; 0000 0023 	lcd_init(16);  //16 chars/line
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 0024 	lcd_puts("Enter '*' to \n start ! ");
	__POINTW2MN _0x8,0
	RCALL _lcd_puts
; 0000 0025 
; 0000 0026 	while (1) //infinte loop
_0x9:
; 0000 0027 		{
; 0000 0028 		x = keypad();
	RCALL _keypad
	MOV  R10,R30
	CLR  R11
; 0000 0029 		if (x != '*')
	LDI  R30,LOW(42)
	LDI  R31,HIGH(42)
	CP   R30,R10
	CPC  R31,R11
	BREQ _0xC
; 0000 002A 			{
; 0000 002B 			lcd_clear();
	RCALL _lcd_clear
; 0000 002C 			lcd_puts("Enter *\n");
	__POINTW2MN _0x8,24
	RCALL _lcd_puts
; 0000 002D 			}
; 0000 002E 		else
	RJMP _0xD
_0xC:
; 0000 002F 			{
; 0000 0030 			lcd_clear();
	RCALL _lcd_clear
; 0000 0031 			lcd_puts("Enter your ID\n");
	__POINTW2MN _0x8,33
	RCALL SUBOPT_0x1
; 0000 0032 			id = getInput(); // Make sure it's a valid id
; 0000 0033 			if(!isValidId(id))
	BRNE _0xE
; 0000 0034 				{
; 0000 0035 				lcd_clear();
	RCALL _lcd_clear
; 0000 0036 				lcd_puts("Invalid ID\n Enter *");
	__POINTW2MN _0x8,48
	RCALL _lcd_puts
; 0000 0037 				continue;
	RJMP _0x9
; 0000 0038 				}
; 0000 0039 			lcd_clear();
_0xE:
	RCALL _lcd_clear
; 0000 003A 			lcd_puts("Enter your PC\n");
	__POINTW2MN _0x8,68
	RCALL SUBOPT_0x2
; 0000 003B 			inputPc = getInput();
; 0000 003C 
; 0000 003D 			lcd_clear();
; 0000 003E 			passcode = EE_Read(id);
	MOV  R17,R30
; 0000 003F 			if (inputPc == passcode)
	MOVW R26,R4
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	BRNE _0xF
; 0000 0040 				{
; 0000 0041 				switch (id)
	MOVW R30,R6
; 0000 0042 					{
; 0000 0043 					case 111:
	CPI  R30,LOW(0x6F)
	LDI  R26,HIGH(0x6F)
	CPC  R31,R26
	BRNE _0x13
; 0000 0044 						lcd_clear();
	RCALL _lcd_clear
; 0000 0045 						lcd_puts("Welcome, Prof\n");
	__POINTW2MN _0x8,83
	RJMP _0x92
; 0000 0046 						break;
; 0000 0047 					case 126:
_0x13:
	CPI  R30,LOW(0x7E)
	LDI  R26,HIGH(0x7E)
	CPC  R31,R26
	BRNE _0x14
; 0000 0048 						lcd_clear();
	RCALL _lcd_clear
; 0000 0049 						lcd_puts("Welcome,\n Mohemmed\n");
	__POINTW2MN _0x8,98
	RJMP _0x92
; 0000 004A 						break;
; 0000 004B 					case 128:
_0x14:
	CPI  R30,LOW(0x80)
	LDI  R26,HIGH(0x80)
	CPC  R31,R26
	BRNE _0x15
; 0000 004C 						lcd_clear();
	RCALL _lcd_clear
; 0000 004D 						lcd_puts("Welcome, Sherif\n");
	__POINTW2MN _0x8,118
	RJMP _0x92
; 0000 004E 						break;
; 0000 004F 					case 130:
_0x15:
	CPI  R30,LOW(0x82)
	LDI  R26,HIGH(0x82)
	CPC  R31,R26
	BRNE _0x16
; 0000 0050 						lcd_clear();
	RCALL _lcd_clear
; 0000 0051 						lcd_puts("Welcome, Ahmed\n");
	__POINTW2MN _0x8,135
	RJMP _0x92
; 0000 0052 						break;
; 0000 0053 					case 132:
_0x16:
	CPI  R30,LOW(0x84)
	LDI  R26,HIGH(0x84)
	CPC  R31,R26
	BRNE _0x12
; 0000 0054 						lcd_clear();
	RCALL _lcd_clear
; 0000 0055 						lcd_puts("Welcome, Jojo\n");
	__POINTW2MN _0x8,151
_0x92:
	RCALL _lcd_puts
; 0000 0056 						break;
; 0000 0057 
; 0000 0058 					}
_0x12:
; 0000 0059 
; 0000 005A 				PORTD.1 = 1;
	SBI  0x12,1
; 0000 005B 				delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	RCALL _delay_ms
; 0000 005C 				PORTD.1 = 0;
	CBI  0x12,1
; 0000 005D 				lcd_clear();
	RCALL _lcd_clear
; 0000 005E 				continue;
	RJMP _0x9
; 0000 005F 				}
; 0000 0060 			else
_0xF:
; 0000 0061 				{
; 0000 0062 				lcd_clear();
	RCALL _lcd_clear
; 0000 0063 				lcd_puts("Wrong passcode\n Enter *");
	__POINTW2MN _0x8,166
	RCALL _lcd_puts
; 0000 0064 				Peep();
	RCALL _Peep
; 0000 0065 				continue;
	RJMP _0x9
; 0000 0066 				}
; 0000 0067 			}
_0xD:
; 0000 0068 
; 0000 0069 		};
	RJMP _0x9
; 0000 006A }
_0x1D:
	RJMP _0x1D
; .FEND

	.DSEG
_0x8:
	.BYTE 0xBE
;
;
;//////////////////////////////////////////////////////////////////////////////
;bool isValidId(int id) //to check id is stored in EEPROM
; 0000 006F {

	.CSEG
_isValidId:
; .FSTART _isValidId
; 0000 0070 	int i;
; 0000 0071 	for( i = 0; i < 5; i++)
	RCALL __SAVELOCR4
	MOVW R18,R26
;	id -> R18,R19
;	i -> R16,R17
	__GETWRN 16,17,0
_0x1F:
	__CPWRN 16,17,5
	BRGE _0x20
; 0000 0072 		{
; 0000 0073 		if (id == validIDs[i])
	MOVW R30,R16
	LDI  R26,LOW(_validIDs)
	LDI  R27,HIGH(_validIDs)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETW1P
	CP   R30,R18
	CPC  R31,R19
	BRNE _0x21
; 0000 0074 			return true;
	LDI  R30,LOW(1)
	RJMP _0x2080002
; 0000 0075 		}
_0x21:
	__ADDWRN 16,17,1
	RJMP _0x1F
_0x20:
; 0000 0076 	return false;
	LDI  R30,LOW(0)
	RJMP _0x2080002
; 0000 0077 }
; .FEND
;//////////////////////////////////////////////////////////////////////////////
;int getInput()
; 0000 007A {
_getInput:
; .FSTART _getInput
; 0000 007B 	int code = 0;
; 0000 007C 	int i, r;
; 0000 007D 	for (i = 0; i < 3; i++)   // get the ID from user
	RCALL __SAVELOCR6
;	code -> R16,R17
;	i -> R18,R19
;	r -> R20,R21
	__GETWRN 16,17,0
	__GETWRN 18,19,0
_0x23:
	__CPWRN 18,19,3
	BRGE _0x24
; 0000 007E 		{
; 0000 007F 		code *= 10;
	MOVW R30,R16
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	RCALL __MULW12
	MOVW R16,R30
; 0000 0080 		r = keypad();
	RCALL _keypad
	MOV  R20,R30
	CLR  R21
; 0000 0081 		lcd_printf("%u", r);
	__POINTW1FN _0x0,190
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R20
	RCALL __CWD1
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _lcd_printf
	ADIW R28,6
; 0000 0082 		code += r;
	__ADDWRR 16,17,20,21
; 0000 0083 		}
	__ADDWRN 18,19,1
	RJMP _0x23
_0x24:
; 0000 0084 	return code;
	MOVW R30,R16
	RCALL __LOADLOCR6
	RJMP _0x2080003
; 0000 0085 }
; .FEND
;
;//////////////////////////////////////////////////////////////////////////////////////////////Declaring keypad
;unsigned char keypad()
; 0000 0089 {
_keypad:
; .FSTART _keypad
; 0000 008A 	while (1)
_0x25:
; 0000 008B 		{
; 0000 008C 		PORTB.0 = 0; //C0 is on
	CBI  0x18,0
; 0000 008D 		PORTB.1 = 1; //C1 is off
	SBI  0x18,1
; 0000 008E 		PORTB.2 = 1; //C2 is off
	SBI  0x18,2
; 0000 008F 		switch (PINB)
	IN   R30,0x16
; 0000 0090 			{
; 0000 0091 			case 0b11110110:
	CPI  R30,LOW(0xF6)
	BRNE _0x31
; 0000 0092 				while(PINB.3 == 0); //while the button is pressed
_0x32:
	SBIS 0x16,3
	RJMP _0x32
; 0000 0093 				return 1;
	LDI  R30,LOW(1)
	RET
; 0000 0094 				break;
	RJMP _0x30
; 0000 0095 
; 0000 0096 			case 0b11101110:
_0x31:
	CPI  R30,LOW(0xEE)
	BRNE _0x35
; 0000 0097 				while(PINB.4 == 0); //while the button is pressed
_0x36:
	SBIS 0x16,4
	RJMP _0x36
; 0000 0098 				return 4;
	LDI  R30,LOW(4)
	RET
; 0000 0099 				break;
	RJMP _0x30
; 0000 009A 
; 0000 009B 			case 0b11011110:
_0x35:
	CPI  R30,LOW(0xDE)
	BRNE _0x39
; 0000 009C 				while(PINB.5 == 0); //while the button is pressed
_0x3A:
	SBIS 0x16,5
	RJMP _0x3A
; 0000 009D 				return 7;
	LDI  R30,LOW(7)
	RET
; 0000 009E 				break;
	RJMP _0x30
; 0000 009F 
; 0000 00A0 			case 0b10111110:
_0x39:
	CPI  R30,LOW(0xBE)
	BRNE _0x30
; 0000 00A1 				while(PINB.6 == 0); //while the button is pressed
_0x3E:
	SBIS 0x16,6
	RJMP _0x3E
; 0000 00A2 				return '*';
	LDI  R30,LOW(42)
	RET
; 0000 00A3 				break;
; 0000 00A4 			}
_0x30:
; 0000 00A5 		PORTB.0 = 1; //C0 is off
	SBI  0x18,0
; 0000 00A6 		PORTB.1 = 0; //C1 is on
	CBI  0x18,1
; 0000 00A7 		PORTB.2 = 1; //C2 is off
	SBI  0x18,2
; 0000 00A8 		switch (PINB)
	IN   R30,0x16
; 0000 00A9 			{
; 0000 00AA 			case 0b11110101:
	CPI  R30,LOW(0xF5)
	BRNE _0x4A
; 0000 00AB 				while(PINB.3 == 0); //while the button is pressed
_0x4B:
	SBIS 0x16,3
	RJMP _0x4B
; 0000 00AC 				return 2;
	LDI  R30,LOW(2)
	RET
; 0000 00AD 				break;
	RJMP _0x49
; 0000 00AE 
; 0000 00AF 			case 0b11101101:
_0x4A:
	CPI  R30,LOW(0xED)
	BRNE _0x4E
; 0000 00B0 				while(PINB.4 == 0); //while the button is pressed
_0x4F:
	SBIS 0x16,4
	RJMP _0x4F
; 0000 00B1 				return 5;
	LDI  R30,LOW(5)
	RET
; 0000 00B2 				break;
	RJMP _0x49
; 0000 00B3 
; 0000 00B4 			case 0b11011101:
_0x4E:
	CPI  R30,LOW(0xDD)
	BRNE _0x52
; 0000 00B5 				while(PINB.5 == 0); //while the button is pressed
_0x53:
	SBIS 0x16,5
	RJMP _0x53
; 0000 00B6 				return 8;
	LDI  R30,LOW(8)
	RET
; 0000 00B7 				break;
	RJMP _0x49
; 0000 00B8 
; 0000 00B9 			case 0b10111101:
_0x52:
	CPI  R30,LOW(0xBD)
	BRNE _0x49
; 0000 00BA 				while(PINB.6 == 0); //while the button is pressed
_0x57:
	SBIS 0x16,6
	RJMP _0x57
; 0000 00BB 				return 0;
	LDI  R30,LOW(0)
	RET
; 0000 00BC 				break;
; 0000 00BD 			}
_0x49:
; 0000 00BE 		PORTB.0 = 1; //C0 is off
	SBI  0x18,0
; 0000 00BF 		PORTB.1 = 1; //C1 is off
	SBI  0x18,1
; 0000 00C0 		PORTB.2 = 0; //C2 is on
	CBI  0x18,2
; 0000 00C1 		switch (PINB)
	IN   R30,0x16
; 0000 00C2 			{
; 0000 00C3 			case 0b11110011:
	CPI  R30,LOW(0xF3)
	BRNE _0x63
; 0000 00C4 				while(PINB.3 == 0); //while the button is pressed
_0x64:
	SBIS 0x16,3
	RJMP _0x64
; 0000 00C5 				return 3;
	LDI  R30,LOW(3)
	RET
; 0000 00C6 				break;
	RJMP _0x62
; 0000 00C7 
; 0000 00C8 			case 0b11101011:
_0x63:
	CPI  R30,LOW(0xEB)
	BRNE _0x67
; 0000 00C9 				while(PINB.4 == 0); //while the button is pressed
_0x68:
	SBIS 0x16,4
	RJMP _0x68
; 0000 00CA 				return 6;
	LDI  R30,LOW(6)
	RET
; 0000 00CB 				break;
	RJMP _0x62
; 0000 00CC 
; 0000 00CD 			case 0b11011011:
_0x67:
	CPI  R30,LOW(0xDB)
	BRNE _0x6B
; 0000 00CE 				while(PINB.5 == 0); //while the button is pressed
_0x6C:
	SBIS 0x16,5
	RJMP _0x6C
; 0000 00CF 				return 9;
	LDI  R30,LOW(9)
	RET
; 0000 00D0 				break;
	RJMP _0x62
; 0000 00D1 
; 0000 00D2 			case 0b10111011:
_0x6B:
	CPI  R30,LOW(0xBB)
	BRNE _0x62
; 0000 00D3 				while(PINB.6 == 0); //while the button is pressed
_0x70:
	SBIS 0x16,6
	RJMP _0x70
; 0000 00D4 				return '#';
	LDI  R30,LOW(35)
	RET
; 0000 00D5 				break;
; 0000 00D6 			}
_0x62:
; 0000 00D7 		}
	RJMP _0x25
; 0000 00D8 
; 0000 00D9 }
; .FEND
;/////////////////////////////////////////////////////////////////////////Address EEPROM
;void EE_Write(unsigned int inputadd, unsigned int PC)
; 0000 00DC {
_EE_Write:
; .FSTART _EE_Write
; 0000 00DD 	while(EECR.1 == 1);  //Wait till the EEPROM is ready for new operation
	RCALL __SAVELOCR4
	MOVW R16,R26
	__GETWRS 18,19,4
;	inputadd -> R18,R19
;	PC -> R16,R17
_0x73:
	SBIC 0x1C,1
	RJMP _0x73
; 0000 00DE 	EEAR = inputadd; //ADRESS REGEISTER
	__OUTWR 18,19,30
; 0000 00DF 	EEDR = PC;      //DATA regiester
	OUT  0x1D,R16
; 0000 00E0 	EECR.2 = 1;    //EE Master Write Enable
	SBI  0x1C,2
; 0000 00E1 	EECR.1 = 1;    //EEWrite Enable
	SBI  0x1C,1
; 0000 00E2 }
	RCALL __LOADLOCR4
_0x2080003:
	ADIW R28,6
	RET
; .FEND
;//////////////////////////////////////////////////////////////Read EEPROM
;unsigned char EE_Read(unsigned int inputadd)
; 0000 00E5 {
_EE_Read:
; .FSTART _EE_Read
; 0000 00E6 	while(EECR.1 == 1);  //Wait till the EEPROM is ready for new operation
	ST   -Y,R17
	ST   -Y,R16
	MOVW R16,R26
;	inputadd -> R16,R17
_0x7A:
	SBIC 0x1C,1
	RJMP _0x7A
; 0000 00E7 	EEAR = inputadd;
	__OUTWR 16,17,30
; 0000 00E8 	EECR.0 = 1;          //Read Enable (EERE)
	SBI  0x1C,0
; 0000 00E9 	return EEDR;
	IN   R30,0x1D
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0000 00EA }
; .FEND
;////////////////////////////////////////////////////////////Change the user PC
;void EE_WriteChange(unsigned int inputadd, unsigned int inputCh_1)
; 0000 00ED {
; 0000 00EE 	while(EECR.1 == 1);  //Wait till the EEPROM is ready for new operation
;	inputadd -> R18,R19
;	inputCh_1 -> R16,R17
; 0000 00EF 	EEAR = inputadd;
; 0000 00F0 	EEDR = inputCh_1;
; 0000 00F1 	EECR.2 = 1;    //EEMWE
; 0000 00F2 	EECR.1 = 1;    //EEWE
; 0000 00F3 }
;///////////////////////////////////////////////////////// Buzzer function
;void Peep()
; 0000 00F6 {
_Peep:
; .FSTART _Peep
; 0000 00F7 	PORTD.5 = 1;
	SBI  0x12,5
; 0000 00F8 	delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
; 0000 00F9 	PORTD.5 = 0;
	CBI  0x12,5
; 0000 00FA 	delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _delay_ms
; 0000 00FB }
	RET
; .FEND
;//////////////////////////////////////////////////////////////////////////Interrupt definition
;interrupt [3] void ext1(void)
; 0000 00FE {
_ext1:
; .FSTART _ext1
	RCALL SUBOPT_0x3
; 0000 00FF 	int pc ;
; 0000 0100 
; 0000 0101 
; 0000 0102 	lcd_puts("Enter your ID\n");
;	pc -> R16,R17
	__POINTW2MN _0x8A,0
	RCALL SUBOPT_0x1
; 0000 0103 	id = getInput(); // Make sure it's a valid id
; 0000 0104 	if(!isValidId(id))
	BRNE _0x8B
; 0000 0105 		{
; 0000 0106 		lcd_clear();
	RCALL _lcd_clear
; 0000 0107 		lcd_puts("Invalid ID\n Enter *");
	__POINTW2MN _0x8A,15
	RCALL _lcd_puts
; 0000 0108 		}
; 0000 0109 	lcd_clear();
_0x8B:
	RCALL _lcd_clear
; 0000 010A 	lcd_puts("Enter old PC");
	__POINTW2MN _0x8A,35
	RCALL SUBOPT_0x2
; 0000 010B 	inputPc = getInput();
; 0000 010C 	lcd_clear();
; 0000 010D 	pc = EE_Read(id);
	MOV  R16,R30
	CLR  R17
; 0000 010E 	if (pc == inputPc )
	__CPWRR 4,5,16,17
	BRNE _0x8C
; 0000 010F 		{
; 0000 0110 
; 0000 0111 		lcd_puts("Enter new PC");
	__POINTW2MN _0x8A,48
	RCALL _lcd_puts
; 0000 0112 		inputPc = getInput();
	RCALL _getInput
	MOVW R4,R30
; 0000 0113 		lcd_clear();
	RCALL _lcd_clear
; 0000 0114 		lcd_puts("Re-enter new PC");
	__POINTW2MN _0x8A,61
	RCALL _lcd_puts
; 0000 0115 		inputPc_2 = getInput();
	RCALL _getInput
	MOVW R8,R30
; 0000 0116 		if (inputPc == inputPc_2)
	__CPWRR 8,9,4,5
	BRNE _0x8D
; 0000 0117 			{
; 0000 0118 			EE_Write(id, inputPc_2 );
	ST   -Y,R7
	ST   -Y,R6
	MOVW R26,R8
	RCALL _EE_Write
; 0000 0119 			lcd_clear();
	RCALL _lcd_clear
; 0000 011A 			lcd_puts("New PC stored");
	__POINTW2MN _0x8A,77
	RJMP _0x93
; 0000 011B 			}
; 0000 011C 		else
_0x8D:
; 0000 011D 			{
; 0000 011E 			lcd_clear();
	RCALL _lcd_clear
; 0000 011F 			lcd_puts("PCs are not Identical");
	__POINTW2MN _0x8A,91
_0x93:
	RCALL _lcd_puts
; 0000 0120 			}
; 0000 0121 		}
; 0000 0122 
; 0000 0123 
; 0000 0124 }
_0x8C:
	RJMP _0x94
; .FEND

	.DSEG
_0x8A:
	.BYTE 0x71
;interrupt [2]void exp0 (void)
; 0000 0126 {

	.CSEG
_exp0:
; .FSTART _exp0
	RCALL SUBOPT_0x3
; 0000 0127 	int pc;
; 0000 0128 	lcd_puts("Enter Admin PC");
;	pc -> R16,R17
	__POINTW2MN _0x8F,0
	RCALL _lcd_puts
; 0000 0129 	id =   getInput();
	RCALL _getInput
	MOVW R6,R30
; 0000 012A 	if (id == validIDs[0] )
	RCALL SUBOPT_0x0
	CP   R30,R6
	CPC  R31,R7
	BRNE _0x90
; 0000 012B 		{
; 0000 012C 		lcd_clear();
	RCALL _lcd_clear
; 0000 012D 		lcd_puts("Enter student ID");
	__POINTW2MN _0x8F,15
	RCALL _lcd_puts
; 0000 012E 		id =  getInput();
	RCALL _getInput
	MOVW R6,R30
; 0000 012F 		lcd_clear();
	RCALL _lcd_clear
; 0000 0130 		lcd_puts("Enter new PC");
	__POINTW2MN _0x8F,32
	RCALL _lcd_puts
; 0000 0131 		pc =  getInput();
	RCALL _getInput
	MOVW R16,R30
; 0000 0132 		EE_Write(id, pc);
	ST   -Y,R7
	ST   -Y,R6
	MOVW R26,R16
	RCALL _EE_Write
; 0000 0133 		lcd_clear();
	RCALL _lcd_clear
; 0000 0134 		lcd_puts("PC is stored");
	__POINTW2MN _0x8F,45
	RCALL _lcd_puts
; 0000 0135 		}
; 0000 0136 	else
	RJMP _0x91
_0x90:
; 0000 0137 		{
; 0000 0138 		lcd_clear();
	RCALL _lcd_clear
; 0000 0139 		lcd_puts("Contact Admin");
	__POINTW2MN _0x8F,58
	RCALL _lcd_puts
; 0000 013A 		Peep();
	RCALL _Peep
; 0000 013B 		Peep();
	RCALL _Peep
; 0000 013C 		}
_0x91:
; 0000 013D 
; 0000 013E 
; 0000 013F }
_0x94:
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND

	.DSEG
_0x8F:
	.BYTE 0x48
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
; .FSTART __lcd_write_nibble_G100
	ST   -Y,R17
	MOV  R17,R26
	IN   R30,0x1B
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	MOV  R30,R17
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x1B,R30
	__DELAY_USB 13
	SBI  0x1B,2
	__DELAY_USB 13
	CBI  0x1B,2
	__DELAY_USB 13
	RJMP _0x2080001
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 133
	ADIW R28,1
	RET
; .FEND
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R17
	ST   -Y,R16
	MOV  R17,R26
	LDD  R16,Y+2
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	ADD  R30,R16
	MOV  R26,R30
	RCALL __lcd_write_data
	MOV  R13,R16
	MOV  R12,R17
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,3
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	LDI  R26,LOW(2)
	RCALL SUBOPT_0x4
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x4
	LDI  R30,LOW(0)
	MOV  R12,R30
	MOV  R13,R30
	RET
; .FEND
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R17
	MOV  R17,R26
	CPI  R17,10
	BREQ _0x2000005
	LDS  R30,__lcd_maxx
	CP   R13,R30
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R12
	MOV  R26,R12
	RCALL _lcd_gotoxy
	CPI  R17,10
	BRNE _0x2000007
	RJMP _0x2080001
_0x2000007:
_0x2000004:
	INC  R13
	SBI  0x1B,0
	MOV  R26,R17
	RCALL __lcd_write_data
	CBI  0x1B,0
	RJMP _0x2080001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	RCALL __SAVELOCR4
	MOVW R18,R26
_0x2000008:
	MOVW R26,R18
	__ADDWRN 18,19,1
	LD   R30,X
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000008
_0x200000A:
_0x2080002:
	RCALL __LOADLOCR4
	ADIW R28,4
	RET
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R17
	MOV  R17,R26
	IN   R30,0x1A
	ORI  R30,LOW(0xF0)
	OUT  0x1A,R30
	SBI  0x1A,2
	SBI  0x1A,0
	SBI  0x1A,1
	CBI  0x1B,2
	CBI  0x1B,0
	CBI  0x1B,1
	STS  __lcd_maxx,R17
	MOV  R30,R17
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	MOV  R30,R17
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	RCALL _delay_ms
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x5
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x2080001:
	LD   R17,Y+
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
__print_G101:
; .FSTART __print_G101
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	RCALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2020016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2020018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x202001C
	CPI  R18,37
	BRNE _0x202001D
	LDI  R17,LOW(1)
	RJMP _0x202001E
_0x202001D:
	RCALL SUBOPT_0x6
_0x202001E:
	RJMP _0x202001B
_0x202001C:
	CPI  R30,LOW(0x1)
	BRNE _0x202001F
	CPI  R18,37
	BRNE _0x2020020
	RCALL SUBOPT_0x6
	RJMP _0x20200CC
_0x2020020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2020021
	LDI  R16,LOW(1)
	RJMP _0x202001B
_0x2020021:
	CPI  R18,43
	BRNE _0x2020022
	LDI  R20,LOW(43)
	RJMP _0x202001B
_0x2020022:
	CPI  R18,32
	BRNE _0x2020023
	LDI  R20,LOW(32)
	RJMP _0x202001B
_0x2020023:
	RJMP _0x2020024
_0x202001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2020025
_0x2020024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2020026
	ORI  R16,LOW(128)
	RJMP _0x202001B
_0x2020026:
	RJMP _0x2020027
_0x2020025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x202001B
_0x2020027:
	CPI  R18,48
	BRLO _0x202002A
	CPI  R18,58
	BRLO _0x202002B
_0x202002A:
	RJMP _0x2020029
_0x202002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x202001B
_0x2020029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x202002F
	RCALL SUBOPT_0x7
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x8
	RJMP _0x2020030
_0x202002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2020032
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x9
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2020033
_0x2020032:
	CPI  R30,LOW(0x70)
	BRNE _0x2020035
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x9
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2020033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2020036
_0x2020035:
	CPI  R30,LOW(0x64)
	BREQ _0x2020039
	CPI  R30,LOW(0x69)
	BRNE _0x202003A
_0x2020039:
	ORI  R16,LOW(4)
	RJMP _0x202003B
_0x202003A:
	CPI  R30,LOW(0x75)
	BRNE _0x202003C
_0x202003B:
	LDI  R30,LOW(_tbl10_G101*2)
	LDI  R31,HIGH(_tbl10_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x202003D
_0x202003C:
	CPI  R30,LOW(0x58)
	BRNE _0x202003F
	ORI  R16,LOW(8)
	RJMP _0x2020040
_0x202003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2020071
_0x2020040:
	LDI  R30,LOW(_tbl16_G101*2)
	LDI  R31,HIGH(_tbl16_G101*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x202003D:
	SBRS R16,2
	RJMP _0x2020042
	RCALL SUBOPT_0x7
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	LD   R30,X+
	LD   R31,X+
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2020043
	RCALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2020043:
	CPI  R20,0
	BREQ _0x2020044
	SUBI R17,-LOW(1)
	RJMP _0x2020045
_0x2020044:
	ANDI R16,LOW(251)
_0x2020045:
	RJMP _0x2020046
_0x2020042:
	RCALL SUBOPT_0x7
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	RCALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
_0x2020046:
_0x2020036:
	SBRC R16,0
	RJMP _0x2020047
_0x2020048:
	CP   R17,R21
	BRSH _0x202004A
	SBRS R16,7
	RJMP _0x202004B
	SBRS R16,2
	RJMP _0x202004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x202004D
_0x202004C:
	LDI  R18,LOW(48)
_0x202004D:
	RJMP _0x202004E
_0x202004B:
	LDI  R18,LOW(32)
_0x202004E:
	RCALL SUBOPT_0x6
	SUBI R21,LOW(1)
	RJMP _0x2020048
_0x202004A:
_0x2020047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x202004F
_0x2020050:
	CPI  R19,0
	BREQ _0x2020052
	SBRS R16,3
	RJMP _0x2020053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2020054
_0x2020053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2020054:
	RCALL SUBOPT_0x6
	CPI  R21,0
	BREQ _0x2020055
	SUBI R21,LOW(1)
_0x2020055:
	SUBI R19,LOW(1)
	RJMP _0x2020050
_0x2020052:
	RJMP _0x2020056
_0x202004F:
_0x2020058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x202005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x202005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x202005A
_0x202005C:
	CPI  R18,58
	BRLO _0x202005D
	SBRS R16,3
	RJMP _0x202005E
	SUBI R18,-LOW(7)
	RJMP _0x202005F
_0x202005E:
	SUBI R18,-LOW(39)
_0x202005F:
_0x202005D:
	SBRC R16,4
	RJMP _0x2020061
	CPI  R18,49
	BRSH _0x2020063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2020062
_0x2020063:
	RJMP _0x20200CD
_0x2020062:
	CP   R21,R19
	BRLO _0x2020067
	SBRS R16,0
	RJMP _0x2020068
_0x2020067:
	RJMP _0x2020066
_0x2020068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2020069
	LDI  R18,LOW(48)
_0x20200CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x202006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	RCALL SUBOPT_0x8
	CPI  R21,0
	BREQ _0x202006B
	SUBI R21,LOW(1)
_0x202006B:
_0x202006A:
_0x2020069:
_0x2020061:
	RCALL SUBOPT_0x6
	CPI  R21,0
	BREQ _0x202006C
	SUBI R21,LOW(1)
_0x202006C:
_0x2020066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2020059
	RJMP _0x2020058
_0x2020059:
_0x2020056:
	SBRS R16,0
	RJMP _0x202006D
_0x202006E:
	CPI  R21,0
	BREQ _0x2020070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0x8
	RJMP _0x202006E
_0x2020070:
_0x202006D:
_0x2020071:
_0x2020030:
_0x20200CC:
	LDI  R17,LOW(0)
_0x202001B:
	RJMP _0x2020016
_0x2020018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LD   R30,X+
	LD   R31,X+
	RCALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_put_lcd_G101:
; .FSTART _put_lcd_G101
	RCALL __SAVELOCR4
	MOVW R16,R26
	LDD  R19,Y+4
	MOV  R26,R19
	RCALL _lcd_putchar
	MOVW R26,R16
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RCALL __LOADLOCR4
	ADIW R28,5
	RET
; .FEND
_lcd_printf:
; .FSTART _lcd_printf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,4
	RCALL __ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	MOVW R26,R28
	ADIW R26,8
	RCALL __ADDW2R15
	LD   R30,X+
	LD   R31,X+
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_lcd_G101)
	LDI  R31,HIGH(_put_lcd_G101)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,8
	RCALL __print_G101
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	POP  R15
	RET
; .FEND

	.CSEG

	.CSEG
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.DSEG
_validIDs:
	.BYTE 0xA
__base_y_G100:
	.BYTE 0x4
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LDS  R30,_validIDs
	LDS  R31,_validIDs+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	RCALL _lcd_puts
	RCALL _getInput
	MOVW R6,R30
	MOVW R26,R6
	RCALL _isValidId
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	RCALL _lcd_puts
	RCALL _getInput
	MOVW R4,R30
	RCALL _lcd_clear
	MOVW R26,R6
	RJMP _EE_Read

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x3:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x5:
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x6:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x7:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x8:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x9:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	LD   R30,X+
	LD   R31,X+
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;RUNTIME LIBRARY

	.CSEG
__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	NEG  R27
	NEG  R26
	SBCI R27,0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0x7D0
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
