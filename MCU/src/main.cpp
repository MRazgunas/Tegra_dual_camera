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

#include "ch.hpp"
#include "hal.h"
#include "node.hpp"

#include "shell.h"
#include "chprintf.h"

namespace app {
namespace {

class LedBlinkerThread : public chibios_rt::BaseStaticThread<256> {
private:

protected:
    virtual void main(void) {
        setName("BlinkerThread");
        while(true) {
            //chprintf((BaseSequentialStream*) &SD1, "Alive\n");
            chibios_rt::BaseThread::sleep(MS2ST(1000));
        }
    }
public:
    LedBlinkerThread(): BaseStaticThread<256>() {

    }
};

void init() {
    halInit();
    chibios_rt::System::init();
    //Node::init();


}

//static Node::uavcanNodeThread canNode;

}
}

static app::LedBlinkerThread blinker;

/*
 * ADC conversion group.
 * Mode:        Continuous, 16 samples of 8 channels, SW triggered.
 * Channels:    IN10, IN11, IN10, IN11, IN10, IN11, Sensor, VRef.
 */
static const ADCConversionGroup adccfg = {
  FALSE,
  4,
  NULL,
  NULL,
  0, ADC_CR2_TSVREFE,           /* CR1, CR2 */
  ADC_SMPR1_SMP_SENSOR(ADC_SAMPLE_41P5),
  ADC_SMPR2_SMP_AN0(ADC_SAMPLE_41P5) | ADC_SMPR2_SMP_AN1(ADC_SAMPLE_41P5) |
  ADC_SMPR2_SMP_AN2(ADC_SAMPLE_41P5), /* SMPR2 */                            /* SMPR2 */
  ADC_SQR1_NUM_CH(4),
  0,
  ADC_SQR3_SQ4_N(ADC_CHANNEL_SENSOR) | ADC_SQR3_SQ3_N(ADC_CHANNEL_IN2) |
  ADC_SQR3_SQ2_N(ADC_CHANNEL_IN1)   | ADC_SQR3_SQ1_N(ADC_CHANNEL_IN0)
};

enum Power_States {
    POWER_SHUTDOWN,
    POWER_WAITING_FOR_VALID_VDD,
    POWER_WAITING_FOR_CARRIER_POWER_ON,
    POWER_STARTING_5V_RAIL,
    POWER_STARTING_OTHER_RAILS,
    POWER_POWERED_ON,
    POWER_EMERGENCY_SHUTDOWN,
    POWER_REQUESTED_POWERDOWN,
    POWER_REQUESTED_RECOVERY,
};

uint8_t state = POWER_WAITING_FOR_VALID_VDD;

#define SHELL_WA_SIZE   THD_WORKING_AREA_SIZE(2048)

static void cmd_enter_recovery(BaseSequentialStream *chp, int argc, char *argv[]) {
    if(argc > 1) {
        chprintf(chp, "Usage: recovery\r\n");
        return;
    }
    if(state == POWER_POWERED_ON) {
        state = POWER_REQUESTED_RECOVERY;
        chprintf(chp, "Entering recovery\n");
    } else {
        chprintf(chp, "ERROR: Tegra still not powered up\n");
    }
}

static const ShellCommand commands[] = {
    {"recovery", cmd_enter_recovery},
    {NULL, NULL}
};

static const ShellConfig shell_cfg1 = {
  (BaseSequentialStream *)&SD3,
  commands
};

static const ShellConfig shell_cfg2 = {
  (BaseSequentialStream *)&SD1,
  commands
};

typedef struct {
    float volt_in;
    float volt_1v8;
    float volt_1v2;
    float tempeture;
} BRD_voltages;

BRD_voltages read_voltages() { //Function execution time ~86us
    adcsample_t samples[4];
    adcConvert(&ADCD1, &adccfg, samples, 1);

    BRD_voltages a;
    a.volt_in = (float)samples[0] * 8862.304688e-6;
    a.volt_1v2 = (float)samples[1] * 805.6640625e-6;
    a.volt_1v8 = (float)samples[2] * 805.6640625e-6;
    a.tempeture = samples[3];
    return a;
}

int main(void) {

  app::init();

  sdStart(&SD1, NULL);

  sdStart(&SD3, NULL);

  adcStart(&ADCD1, NULL);

  thread_t *shelltp = chThdCreateFromHeap(NULL, SHELL_WA_SIZE,
      "shell", NORMALPRIO + 1, shellThread, (void *)&shell_cfg1);

  thread_t *shelltp2 = chThdCreateFromHeap(NULL, SHELL_WA_SIZE,
       "shell", NORMALPRIO + 1, shellThread, (void *)&shell_cfg2);


  BRD_voltages board_volt;
  BRD_voltages previous_reading;
  float stable_vin_value;
  blinker.start(NORMALPRIO);
//  app::canNode.start(LOWPRIO);

  systime_t time_since_recov_req = 0;

  while (true) {
      board_volt = read_voltages();
      if(state > POWER_WAITING_FOR_VALID_VDD) {
          if(board_volt.volt_in < 6.0f) {
              state = POWER_EMERGENCY_SHUTDOWN;
          }
      }
      if(state > POWER_WAITING_FOR_CARRIER_POWER_ON && palReadPad(GPIOB, GPIOB_CARRIER_PWR_ON) == 0) {
          state = POWER_REQUESTED_POWERDOWN;
      }
      if(board_volt.volt_1v8 < 1.6f) {
          palClearPad(GPIOC, GPIOC_RESET_OUT);
      }

      if(chVTGetSystemTime() > time_since_recov_req + MS2ST(2000) && time_since_recov_req != 0) {
          palSetPad(GPIOB, GPIOB_FORCE_RECOV);
          time_since_recov_req = 0;
      }

      switch(state) {
      case POWER_WAITING_FOR_VALID_VDD:
          if(board_volt.volt_in > 5.5f) {
              if(fabs(board_volt.volt_in - previous_reading.volt_in) < 0.1f){
                  stable_vin_value = board_volt.volt_in;
                  palSetPad(GPIOB, GPIOB_VIN_PWR_BAD);
                  palClearPad(GPIOC, GPIOC_POWER_BTN);
                  chibios_rt::BaseThread::sleep(MS2ST(100));
                  palSetPad(GPIOC, GPIOC_POWER_BTN);
                  state = POWER_WAITING_FOR_CARRIER_POWER_ON;
              }
          }
          break;
      case POWER_WAITING_FOR_CARRIER_POWER_ON:
          if(palReadPad(GPIOB, GPIOB_CARRIER_PWR_ON)) {
              state = POWER_STARTING_5V_RAIL;
          }
          break;
      case POWER_STARTING_5V_RAIL:
          palClearPad(GPIOB, GPIOB_RAIL_DISCHARGE);
          palSetPad(GPIOB, GPIOB_5V_EN);
          if(palReadPad(GPIOB, GPIOB_5V_PG)) state = POWER_STARTING_OTHER_RAILS;
          break;
      case POWER_STARTING_OTHER_RAILS:
          palSetPad(GPIOB, GPIOB_3V3_EN);
          palSetPad(GPIOB, GPIOB_2V5_EN);
          palSetPad(GPIOB, GPIOB_1V8_EN);
          palSetPad(GPIOB, GPIOB_1V2_EN);
          if(board_volt.volt_1v8 > 1.65f) {
              palSetPad(GPIOC, GPIOC_RESET_OUT);
              state = POWER_POWERED_ON;
          }
          break;
      case POWER_POWERED_ON:
          break;
      case POWER_EMERGENCY_SHUTDOWN:
          palClearPad(GPIOB, GPIOB_VIN_PWR_BAD);
          if(palReadPad(GPIOB, GPIOB_CARRIER_PWR_ON) == 0) {
              //palClearPad(GPIOC, GPIOC_RESET_OUT);
              palClearPad(GPIOB, GPIOB_1V8_EN);
              palClearPad(GPIOB, GPIOB_5V_EN);
              palClearPad(GPIOB, GPIOB_3V3_EN);
              palClearPad(GPIOB, GPIOB_2V5_EN);
              palClearPad(GPIOB, GPIOB_1V2_EN);
              palSetPad(GPIOB, GPIOB_RAIL_DISCHARGE);
          }
      case POWER_REQUESTED_POWERDOWN:
        //palClearPad(GPIOC, GPIOC_RESET_OUT);
        palClearPad(GPIOB, GPIOB_1V8_EN);
        palClearPad(GPIOB, GPIOB_5V_EN);
        palClearPad(GPIOB, GPIOB_3V3_EN);
        palClearPad(GPIOB, GPIOB_2V5_EN);
        palClearPad(GPIOB, GPIOB_1V2_EN);
        palSetPad(GPIOB, GPIOB_RAIL_DISCHARGE);
        state = POWER_WAITING_FOR_CARRIER_POWER_ON;
        break;
      case POWER_REQUESTED_RECOVERY:
          palClearPad(GPIOB, GPIOB_FORCE_RECOV);
          palClearPad(GPIOC, GPIOC_RESET_IN);
          chibios_rt::BaseThread::sleep(MS2ST(200));
          palSetPad(GPIOC, GPIOC_RESET_IN);
          state = POWER_REQUESTED_POWERDOWN;
          time_since_recov_req = chVTGetSystemTime();
          break;
      }

      previous_reading = board_volt;


      chibios_rt::BaseThread::sleep(US2ST(500));
  }
}
