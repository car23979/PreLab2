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

// Configuración de pila
LDI		R16, LOW(RAMEND)
OUT		SPL, R16
LDI		R16, HIGH(RAMEND)
OUT		SPL, R16
