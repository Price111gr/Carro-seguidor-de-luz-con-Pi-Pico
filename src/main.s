.global main_asm

.equ   ADC_derecho_CH0, 26
.equ   ADC_izquierdo_CH1, 27

.equ   PWM_derecho_CH1, 14
.equ   PWM_izquierdo_CH2, 16

.equ   PWM_DIV_INTEGER, 128
.equ   PWM_DIV_FRAC, 0

.equ   PWM_TOP_VALUE, 4095

.equ   PWM_CHA, 0

.equ   PWM_DUTY_ZERO, 0

.equ ADC_MIN_READVALUE, 30

main_asm:

    push {lr}

    ldr r0, =ADC_derecho_CH0

    bl project_adc_init_asm

    ldr r0, =ADC_izquierdo_CH1

    bl project_adc_init_asm

    ldr r0, =PWM_izquierdo_CH2

    bl project_pwm_init_asm

    ldr r0, =PWM_derecho_CH1

    bl project_pwm_init_asm

    pop {pc}


.global loop

loop:

    push {lr}

    ldr r0, =ADC_derecho_CH0
    
    bl project_adc_read_asm

    push {r0}

    ldr r0, =ADC_izquierdo_CH1

    bl project_adc_read_asm

    mov r3, r0 // guardamos el dato del canal izquierdo en r3

    pop {r2} // al liberar dejamos el derecho en r0

    ldr R0, =ADC_MIN_READVALUE

    cmp r2, r0

    blt apagar_led

    b compare2


apagar_led:

    push {r0, r3}

    mov r1, #0

    ldr r0, =PWM_derecho_CH1

    bl project_pwm_set_chan_level_ASM

    pop {r0, r3}

compare2:

    cmp r3, r0

    blt apagar_led2

    b continue

apagar_led2:

    mov r1, #0

    ldr r0, =PWM_izquierdo_CH2

    bl project_pwm_set_chan_level_ASM

    b end_func

continue:

    ldr r0, =PWM_izquierdo_CH2

    mov r1, r2
    
    push    {r3}

    bl project_pwm_set_chan_level_ASM

    pop {r3}

    ldr r0, =PWM_derecho_CH1

    mov r1, r3

    bl project_pwm_set_chan_level_ASM

end_func:

    pop {pc}


project_pwm_init_asm:

    push {r0, lr}

    bl pwm_init_asm

    pop {r0}

    push {r0}

    bl saca_channel

    mov r1, r0

    pop {r0}
    
    push {r1}

    bl saca_sliceASM

    pop {r1}

    push {r0, r1}

    ldr r1, =PWM_DIV_INTEGER

    ldr r2, =PWM_DIV_FRAC

    bl ASMconfig_freq_PWM

    pop {r0, r1}

    push {r0, r1}

    ldr r1, =PWM_TOP_VALUE

    bl config_topASM

    pop {r0, r1}

    push {r0}

    ldr r2, =PWM_DUTY_ZERO

    bl select_canalASM

    pop {r0}

    mov r1, #1

    bl enablePWMASM

    pop {pc}

.global project_pwm_set_chan_level_ASM
project_pwm_set_chan_level_ASM:

    push {r0, r1, lr}

   bl saca_channel

   mov r1, r0

   pop {r0, r2}

   push {r1, r2}

   bl saca_sliceASM

    pop {r1, r2}

    bl select_canalASM


    pop {pc}


















