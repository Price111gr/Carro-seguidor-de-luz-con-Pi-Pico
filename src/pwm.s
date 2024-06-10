// General definitions
.equ    ATOMIC_XOR, 0x1000
.equ    ATOMIC_SET, 0x2000
.equ    ATOMIC_CLR, 0x3000

/**
 * @brief gpio_init_asm.
 *
 * This function initializes the GPIO module
 * Parameters:
 *  R0: GPIO_NUM
 */
.global pwm_init_asm                   // To allow this function to be called from another file
pwm_init_asm:
        push {r0, lr}
        bl releaseResetPWM
        pop {r0}
        bl setFunctionPWM
        pop {pc}

/**
 * @brief releaseResetIOBank0
 *
 * This function releases the Reset for IO_Bank0
 * Parameters: None
 */
.equ    RESETS_BASE, 0x4000c000         // See RP2040 datasheet: 2.14.3 (Subsystem Resets)
.equ    RESET_DONE_OFFSET, 8
.equ    PWM_BITMASK,  0x4000 // esto setea el bit 14 
releaseResetPWM:
    ldr r0, =(RESETS_BASE+ATOMIC_CLR)	// Address for reset controller atomic clr register
	ldr r1, =PWM_BITMASK           // Load a '1' into bit 5: IO_Bank0
	str r1, [r0]    	                // Request to clear reset IOBank0
    ldr r0, =RESETS_BASE                // Base address for reset controller
rstPWMdone:     
	ldr r1, [r0, #RESET_DONE_OFFSET]    // Read reset done register
	ldr r2, =PWM_BITMASK           // Load a '1' into bit 5: IO_Bank0
	and r1, r1, r2		                // Check bit IO_Bank0 (0: reset has not been released yet)
	beq rstPWMdone
    bx  lr


/**
 * @brief setFunctionGPIO.
 *
 * This function selects function SIO for GPIOx
 * Parameters:
 *  R0: GPIO_NUM
 */
.equ    IO_BANK0_BASE, 0x40014000       // See RP2040 datasheet: 2.19.6 (GPIO)
.equ    GPIO0_CTRL_OFFSET, 4
.equ    GPIO_PWM_FUNCTION, 4            // el 4 infiere para cargar como pwm un pin
setFunctionPWM:
	ldr r2, =(IO_BANK0_BASE+GPIO0_CTRL_OFFSET)  // Address for GPIO0_CTRL register
	mov r1, #GPIO_PWM_FUNCTION          // Select SIO for GPIO. See RP2040 datasheet: 2.19.2
    lsl r0, r0, #3                      // Prepare register offset for GPIOx (GPIO_NUM * 8)
	str r1, [r2, r0]	                // Store selected function (SIO) in GPIOx control register
    bx  lr

.global saca_sliceASM

saca_sliceASM:  // calcula el slice del gpio x

    lsr r0, r0, #1  // se realiza esto para poder extraer el slice del gpio

    mov r1, #7

    and r0, r0, r1  // se hace un and para poder dejar los bits que necesitamos del slice

    bx lr

.global ASMconfig_freq_PWM

.equ PWM_base, 0x40050000 // esta es la base del registro de pwm

ASMconfig_freq_PWM:

    push {r4}

    ldr r3, =PWM_base

    mov r4, #20  // cada slice tiene 5 registros y cada registro es de 4bytes

    mul r0, r0, r4 // con esto calculanmos el slice

    add r0, r0, #4 // sumamos el offset

    add r0, r0, r3 // sumamos la base para ya obtener el CH que modificaremos

    lsl r1, r1, #4  // aqui desplazamos los 4 primeros bits para la fraccion
    // queda la parte enter
    mov r4, #15

    and r2, r2, r4 // asegura que la fraccion quede de 4 bits 

    orr r1, r1, r2 // juntamos el entero con la fraccion 

    str r1, [r0] // guardar en la direccion 

    pop {r4}

    bx lr // esto para retornar a la declaracion 

.global config_topASM

config_topASM:

    ldr r2, =PWM_base

    mov r3, #20  // cada slice tiene 5 registros y cada registro es de 4bytes

    mul r0, r0, r3 // con esto calculanmos el slice

    add r0, r0, #16 // sumamos el offset de la ubicacion

    add r0, r0, r2 // sumamos la base para ya obtener el CH que modificaremos
    
    str r1, [r0] // guardamos el top 

    bx lr 

.global select_canalASM

select_canalASM: // toma el canal y da un valor a este

    
    push {r4}

    ldr r3, =PWM_base

    mov r4, #20  // cada slice tiene 5 registros y cada registro es de 4bytes

    mul r0, r0, r4 // con esto calculanmos el slice

    add r0, r0, #12 // sumamos el offset

    add r0, r0, r3 // sumamos la base para ya obtener el CH que modificaremos

    lsl r1, r1, #4 // 

    lsl r2, r2, r1 // 

    str r2, [r0] //

    pop {r4}    

    bx lr

.global enablePWMASM

enablePWMASM:

    
    ldr r2, =PWM_base

    mov r3, #20  // cada slice tiene 5 registros y cada registro es de 4bytes

    mul r0, r0, r3 // con esto calculanmos el slice

    add r0, r0, #0 // sumamos el offset de la ubicacion

    add r0, r0, r2 // sumamos la base para ya obtener el CH que modificaremos

    str r1, [r0] // 

    bx lr    

.global saca_channel

saca_channel: //calculamos el canal que se va a escribir

    mov r1, #1 // verificamos haciendo una and si es par o impar

    and r0, r0, r1 

    bx lr