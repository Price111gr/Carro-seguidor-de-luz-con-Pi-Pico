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

/**
 * @brief Main program.
 *
 * This function initializes the MCU and does an infinite cycle.
 */

void project_adc_init_asm(uint32_t);
uint16_t project_adc_read_asm(uint32_t);


void ASMadc_init();
void ASMadc_gpio_init(uint32_t);
void ASMadc_select_input(uint32_t);
uint16_t ASMadc_read();

int main() {
	// STDIO initialization
    stdio_init_all();

    main_asm();
	
	// ADC Initialization
   /* project_adc_init_asm(ADC_GPIO_CH0);

    project_adc_init_asm(ADC_GPIO_CH1);

    // PWM Initialization
    project_pwm_init(PWM_GPIO_CHA2);

    project_pwm_init(PWM_GPIO_CHA1);*/
    
	// Infinite loop to take samples and send them to PWM channel
    while (1) {
        uint16_t adcSample;
        uint16_t adcSample2;
        // Read ADC sample (12-bit: 0 to 4095)
        adcSample = project_adc_read_asm(ADC_GPIO_CH0);
        adcSample2 = project_adc_read_asm(ADC_GPIO_CH1);
        printf("*** Value read from ADC channel 0: %d ***\n", adcSample);
        printf("*** Value read from ADC channel 1: %d ***\n", adcSample2);
        // Send value to PWM channel A (level: 0 to 4095)
        // But, first guarantee 0% duty for values near zero
        if (adcSample < ADC_MIN_READVALUE)
            adcSample = 0;  
        if (adcSample2 < ADC_MIN_READVALUE)
            adcSample2 = 0; 
        project_pwm_set_chan_level(PWM_GPIO_CHA1, adcSample);
        project_pwm_set_chan_level(PWM_GPIO_CHA2, adcSample2);
        // Wait for DELAY milliseconds
        sleep_ms(DELAY);
    }
	
    return 0;
}

// Initializes ADC
	void ASMadc_init(){

        adc_init();

    }
    // Disable Input and pullups
    void ASMadc_gpio_init(uint32_t PIN){

        adc_gpio_init(PIN);

    }

    // Select channel for ADC conversion
    void ASMadc_select_input(uint32_t CHAN){

        adc_select_input(CHAN);

    }

    uint16_t ASMadc_read() {
        // Read 12-bit sample
        return adc_read();
    }

