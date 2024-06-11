.global project_adc_init_asm
project_adc_init_asm:
    push    {r0, lr}
    bl      ASMadc_init

    pop     {r0}
    bl      ASMadc_gpio_init


    pop     {pc}

.global project_adc_read_asm
project_adc_read_asm:
    push    {lr}
    sub     r0, r0, #26
    bl      ASMadc_select_input

    bl      ASMadc_read
    pop     {pc}