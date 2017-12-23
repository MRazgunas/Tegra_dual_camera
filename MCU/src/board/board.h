/*
    ChibiOS - Copyright (C) 2006..2016 Giovanni Di Sirio

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*/

#ifndef _BOARD_H_
#define _BOARD_H_

/*
 * Board identifier.
 */
#define BOARD_TEGRA_DUAL_CAM_REV_A
#define BOARD_NAME              "Dual camera Tegra Rev.A"

/*
 * Board frequencies.
 */
#define STM32_LSECLK            0
#define STM32_HSECLK            16000000

/*
 * MCU type, supported types are defined in ./os/hal/platforms/hal_lld.h.
 */
#define STM32F105xC

/*
 * IO pins assignments.
 */
#define GPIOB_CARRIER_PWR_ON    0
#define GPIOB_5V_PG             1
#define GPIOB_VIN_PWR_BAD       2
#define GPIOB_3V3_EN            3
#define GPIOB_3V3_PG            4
#define GPIOB_1V8_EN            5
#define GPIOB_2V5_EN            6
#define GPIOB_2V5_PG            7
#define GPIOB_1V2_EN            8
#define GPIOB_RAIL_DISCHARGE    9
#define GPIOB_5V_EN             14
#define GPIOB_FORCE_RECOV       15

#define GPIOC_RESET_OUT         0
#define GPIOC_RESET_IN          1
#define GPIOC_POWER_BTN         4
#define GPIOC_SLEEP             6
#define GPIOC_SER_CONVERTER_OE  12

/*
 * I/O ports initial setup, this configuration is established soon after reset
 * in the initialization code.
 *
 * The digits have the following meaning:
 *   0 - Analog input.
 *   1 - Push Pull output 10MHz.
 *   2 - Push Pull output 2MHz.
 *   3 - Push Pull output 50MHz.
 *   4 - Digital input.
 *   5 - Open Drain output 10MHz.
 *   6 - Open Drain output 2MHz.
 *   7 - Open Drain output 50MHz.
 *   8 - Digital input with PullUp or PullDown resistor depending on ODR.
 *   9 - Alternate Push Pull output 10MHz.
 *   A - Alternate Push Pull output 2MHz.
 *   B - Alternate Push Pull output 50MHz.
 *   C - Reserved.
 *   D - Alternate Open Drain output 10MHz.
 *   E - Alternate Open Drain output 2MHz.
 *   F - Alternate Open Drain output 50MHz.
 * Please refer to the STM32 Reference Manual for details.
 */

/*
 * Port A setup.
 * Everything input with pull-up except:
 * PA0  - Analog input      (VIN_MEAS).
 * PA1  - Analog input      (1V2_MEAS).
 * PA2  - Analog input      (1V8_MEAS).
 * PA9  - Alternate P.P     (USART1_TX).
 * PA10 - Digital input     (USART1_RX).
 * PA11 - Digital input     (CAN1_RX).
 * PA12 - Alternate P.P     (CAN1_TX).
 * PA13 - Digital input     (SWDIO).
 * PA14 - Digital input     (SWCLK).
 */
#define VAL_GPIOACRL            0x88888000      /*  PA7...PA0 */
#define VAL_GPIOACRH            0x844B48B8      /* PA15...PA8 */
#define VAL_GPIOAODR            0xFFFFFFFF

/*
 * Port B setup:
 * Everything input with pull-up except:
 * PB0  - Input with PU     (CARRIER_PWR_ON).
 * PB1  - Digital input     (5V_PG).
 * PB2  - P. P output       (VIN_PWR_BAD).
 * PB3  - P. P output       (3V3_EN).
 * PB4  - Digital input     (3V3_PG).
 * PB5  - P. P output       (1V8_EN).
 * PB6  - P. P output       (2V5_EN).
 * PB7  - Digital input     (2V5_PG).
 * PB8  - P. P output       (1V2_EN).
 * PB9  - P. P output       (RAIL_DISCHARGE).
 * PB10 - Alternate P.P     (RGB_CFG_TX).
 * PB11 - Digital input     (RGB_CFG_RX).
 * PB12 - Digital input     (CAN2_RX).
 * PB13 - Alternate P.P     (CAN2_TX).
 * PB14 - P.P output        (5V_EN).
 * PB15 - Open drain output (FORCE_RECOV).
 */
#define VAL_GPIOBCRL            0x42242648      /*  PB7...PB0 */
#define VAL_GPIOBCRH            0x62B44B22      /* PB15...PB8 */
#define VAL_GPIOBODR            0xFFFF8201

/*
 * Port C setup:
 * Everything input with pull-up except:
 * PC0  - Open Drain output (RESET_OUT).
 * PC1  - Open Drain output (RESET_IN).
 * PC4  - Open Drain output (POWER_BTN).
 * PC6  - Open Drain output (SLEEP).
 * PC10 - Alternate output  (LWIR_UART_TX).
 * PC11 - Input with PU     (LWIR_UART_RX).
 * PC12 - P.P output        (SER_CONVERTER_OE).
 */
#define VAL_GPIOCCRL            0x86868866      /*  PC7...PC0 */
#define VAL_GPIOCCRH            0x88828B88      /* PC15...PC8 */
#define VAL_GPIOCODR            0xFFFF1852

/*
 * Port D setup:
 * Everything input with pull-up except:

 */
#define VAL_GPIODCRL            0x88888888      /*  PD7...PD0 */
#define VAL_GPIODCRH            0x88888888      /* PD15...PD8 */
#define VAL_GPIODODR            0xFFFFFFFF

/*
 * Port E setup.
 * Everything input with pull-up except:
 */
#define VAL_GPIOECRL            0x88888888      /*  PE7...PE0 */
#define VAL_GPIOECRH            0x88888888      /* PE15...PE8 */
#define VAL_GPIOEODR            0xFFFFFFFF

#if !defined(_FROM_ASM_)
#ifdef __cplusplus
extern "C" {
#endif
  void boardInit(void);
#ifdef __cplusplus
}
#endif
#endif /* _FROM_ASM_ */

#endif /* _BOARD_H_ */
