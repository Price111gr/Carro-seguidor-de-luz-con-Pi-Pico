/**
 * @file main.h
 * @brief Header file for the example
 */
 
// Avoid duplication in code
#ifndef _MAIN_H_
#define _MAIN_H_

// Definitions and prototypes
#define DELAY               200
#define ADC_GPIO_CH0        26
#define ADC_GPIO_CH1        27
#define ADC_MIN_READVALUE   30
#define PWM_GPIO_CHA1       16
#define PWM_GPIO_CHA2       14


void main_asm();
void loop();
void gpio_init_asm();

uint32_t gpio_put_asm (uint32_t, bool);

uint16_t project_adc_read_asm(uint32_t);
void project_pwm_set_chan_level_ASM(uint32_t, uint16_t);

#endif