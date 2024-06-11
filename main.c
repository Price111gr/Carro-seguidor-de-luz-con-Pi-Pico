/**
 * @file main.c
 * @brief This example takes a sample using the ADC channel 0 (GPIO26) and writes it
 * to the PWM slice 0 channel A (GPIO16).
 * 
 * To carry out the example, the user must connect a potentiometer to GND, GPIO26 and VCC33 pins,
 * and a LED in series with a 470-ohm resistor between GPIO16 and GND.
 */

// Standard libraries
#include <stdio.h>
#include "pico/stdlib.h"
#include "hardware/adc.h"

// The header files
#include "main.h"
#include "pwm.h"

// Definiciones de pines
#define LEFT_MOTOR_PWM_PIN 14
#define RIGHT_MOTOR_PWM_PIN 16
#define ADC_GPIO_CH0 26
#define ADC_GPIO_CH1 27
#define LEFT_LED_PIN 18
#define RIGHT_LED_PIN 19

// Definición del umbral de luz ambiente
#define AMBIENT_LIGHT_THRESHOLD 1000

void ASMadc_init() {
    adc_init();
}

void ASMadc_gpio_init(uint32_t pin) {
    adc_gpio_init(pin);
}
void ASMadc_select_input(uint32_t canal) {
    adc_select_input(canal);
}
uint16_t ASMadc_read() {
    return adc_read();
}

// Función para inicializar PWM en un pin


// Función para establecer el nivel de PWM
void project_pwm_set_chan_level(uint pin, uint level) {
    uint slice_num = saca_sliceASM(pin);
    select_canalASM(slice_num, saca_channel(pin), level);
}


int main() {
    // Inicialización de los GPIOs
    stdio_init_all();
    
     main_asm();

    while (1) {
        uint16_t adcSample;
        uint16_t adcSample2;
        // Read ADC sample (12-bit: 0 to 4095)
        adcSample = project_adc_read_asm(ADC_GPIO_CH0);
        adcSample2 = project_adc_read_asm(ADC_GPIO_CH1);

        // Diferenciar entre luz ambiente y luz artificial
        if (adcSample > AMBIENT_LIGHT_THRESHOLD || adcSample2 > AMBIENT_LIGHT_THRESHOLD) {
            if (adcSample > adcSample2) {
                // Gira a la izquierda
                project_pwm_set_chan_level(LEFT_MOTOR_PWM_PIN, 0);  // Detener motor izquierdo
                project_pwm_set_chan_level(RIGHT_MOTOR_PWM_PIN, adcSample2);  // Motor derecho a velocidad proporcional a la luz
                gpio_put_asm(LEFT_LED_PIN, 1);
                gpio_put_asm(RIGHT_LED_PIN, 0);
            } else if (adcSample2 > adcSample) {
                // Gira a la derecha
                project_pwm_set_chan_level(LEFT_MOTOR_PWM_PIN, adcSample);  // Motor izquierdo a velocidad proporcional a la luz
                project_pwm_set_chan_level(RIGHT_MOTOR_PWM_PIN, 0);  // Detener motor derecho
                gpio_put_asm(LEFT_LED_PIN, 0);
                gpio_put_asm(RIGHT_LED_PIN, 1);
            } else {
                // Sigue recto
                project_pwm_set_chan_level(LEFT_MOTOR_PWM_PIN, adcSample);
                project_pwm_set_chan_level(RIGHT_MOTOR_PWM_PIN, adcSample2);
                gpio_put_asm(LEFT_LED_PIN, 0);
                gpio_put_asm(RIGHT_LED_PIN, 0);
            }
        } else {
            // Luz ambiente detectada, detener motores
            project_pwm_set_chan_level(LEFT_MOTOR_PWM_PIN, 0);
            project_pwm_set_chan_level(RIGHT_MOTOR_PWM_PIN, 0);
            gpio_put_asm(LEFT_LED_PIN, 0);
            gpio_put_asm(RIGHT_LED_PIN, 0);
        }

        sleep_ms(100);
    }

 return 0;
}

