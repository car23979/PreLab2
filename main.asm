/*
* Laboratorio1.asm
*
* Created: 14-Feb-25 12:00:08 PM
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

// Loop infinito
MAIN:
	IN R16, TIFR0		// Leer registros de interrupción en TIMER0
	SBRS R16, TOV0		// Salta si el bit 0 no está "set" (TOV0 bit)
    RJMP MAIN		// Reiniciar loop si no hay overflow

	SBI TIFR0, TOV0		// Limpiar bandera de "overflow"
    LDI R16, 100
    OUT TCNT0, R16      // Volver a cargar valor inicial en TCNT0
    
    INC OVERFLOW_COUNT    // Contar el número de overflows
    CPI OVERFLOW_COUNT, 10 // ¿Llegamos a 100ms?
    BRNE MAIN        // Si no, seguir esperando más overflows
    
    CLR OVERFLOW_COUNT    // Reiniciar contador de overflows

    INC COUNTER           // Incrementar el contador binario
    ANDI COUNTER, 0x0F    // Mantener solo los 4 bits menos significativos
    OUT PORTD, COUNTER    // Mostrar el valor en los LEDs
    
    RJMP MAIN        // Repetir el ciclo

/****************************************/
// NON-Interrupt subroutines
INIT_TMR0:
    LDI R16, (1<<CS01) | (1<<CS00)  // Prescaler = 64
    OUT TCCR0B, R16
    LDI R16, 100   // Cargar TCNT0 para generar overflows cada 10ms
    OUT TCNT0, R16
    RET

