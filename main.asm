/*
* Laboratorio1.asm
*
* Created: 14-Feb-25 12:00:00 PM
* Author : David Carranza
* Descripción: Implementación de un Timer0 y dos botones
*/
// Encabezado
.include "M328PDEF.inc"

.cseg
.org	0x0000
.def	COUNTER = R20 // Contador de 4bits
.def	OVERFLOW_COUNT = R21	// Contador de overflows

// Configuración de pila
LDI		R16, LOW(RAMEND)
OUT		SPL, R16
LDI		R16, HIGH(RAMEND)
OUT		SPH, R16

// Configurar el MCU
SETUP:
	// Configurar Prescaler
	LDI R16, (1 << CLKPCE)
    STS CLKPR, R16    // Habilitar cambio de PRESCALER
    LDI R16, 0b00000100
    STS CLKPR, R16    // Configurar Prescaler a 16 F_CPU = 1MHz

	// Inicializar Timer0
	Call INIT_TMR0

	// Configurar los 4 primeros bits de PORTD como salida (LEDs)
    LDI R16, 0x0F
    OUT DDRD, R16  // PD0-PD3 como salida
    LDI R16, 0x00
    OUT PORTD, R16 // Apagar LEDs inicialmente

	// Inicializar contadores
    LDI COUNTER, 0x00
    LDI OVERFLOW_COUNT, 0x00
