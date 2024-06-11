/**
 * @file pwm.h
 * @brief Header file for the pwm.c file
 */

#include <stdint.h>

// Avoid duplication in code
#ifndef _PWM_H_
#define _PWM_H_

// Definitions and prototypes

#define PWM_CHA             0
#define PWM_DIV_INTEGER     128
#define PWM_DIV_FRAC        0
#define PWM_TOP_VALUE       4095
#define PWM_DUTY_ZERO       0

void project_pwm_init(uint);
void project_pwm_set_chan_level(uint, uint);

void pwm_init_asm(uint32_t);
uint saca_sliceASM(uint32_t);
uint saca_channel(uint32_t);
void ASMconfig_freq_PWM(uint, uint32_t, uint32_t);
void config_topASM(uint, uint32_t);
void select_canalASM(uint, bool, uint32_t);
void enablePWMASM(uint, bool);

#endif