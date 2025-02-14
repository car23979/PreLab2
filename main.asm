/*
* Laboratorio1.asm
*
* Created: 14-Feb-25 12:00:00 PM
* Author : David Carranza
* Descripci�n: Implementaci�n de un Timer0 y dos botones
*/
// Encabezado
.include "M328PDEF.inc"

.cseg
.org	0x0000

// Configuraci�n de pila
LDI		R16, LOW(RAMEND)
OUT		SPL, R16
LDI		R16, HIGH(RAMEND)
OUT		SPL, R16
