<template>
  <div>
    <v-container>
      <v-row class="mb-6" no-gutters>
        <v-col xs="12" sm="6" md="6" lg="4" xl="3">
          <v-card class="mx-0" max-width="400" min-height="550">
            <v-img class="white--text align-end" height="220px"
                   :src="require('../assets/growing-plants.jpg')">
              <v-card-title>Growing configuration</v-card-title>
            </v-img>

            <v-card-text class="text--primary">
              <v-form ref="form">
                <v-select
                    v-model="configName"
                    :items="configNames"
                    label="Config"
                    required
                ></v-select>
                <v-slider
                    v-model="dayCount"
                    :label="`Day [${dayCountLabel}]`"
                    min="1"
                    :max="growingInfo.total_days"
                >
                </v-slider>
              </v-form>
            </v-card-text>
            <v-card-actions>
              <v-btn color="orange" text @click="saveConfig">Save</v-btn>
              <v-btn color="orange" text @click="loadFormData">Reset</v-btn>
            </v-card-actions>
          </v-card>

        </v-col>
        <!--        <v-col xs="12" sm="6" md="6" lg="4" xl="3">-->
        <!--          <v-card class="mx-0" max-width="400" min-height="500">-->
        <!--            <v-img class="white&#45;&#45;text align-end" height="220px"-->
        <!--                   :src="require('../assets/light.jpg')">-->
        <!--              <v-card-title>Light</v-card-title>-->
        <!--            </v-img>-->

        <!--            <v-card-text class="text&#45;&#45;primary">-->
        <!--              <v-form ref="form">-->
        <!--                <v-checkbox-->
        <!--                    v-model="lightManualMode"-->
        <!--                    label="Manual mode"-->
        <!--                    required-->
        <!--                ></v-checkbox>-->
        <!--              </v-form>-->
        <!--            </v-card-text>-->

        <!--            <v-card-subtitle class="pb-0">-->
        <!--              Please note: switching on the manual fan control mode can lead to an uncontrolled temperature change-->
        <!--            </v-card-subtitle>-->

        <!--            <v-card-actions>-->
        <!--              <v-btn color="orange" text @click="saveFanConfig">Save</v-btn>-->
        <!--              <v-btn color="orange" text @click="loadFanFormData">Reset</v-btn>-->
        <!--            </v-card-actions>-->
        <!--          </v-card>-->

        <!--        </v-col>-->
        <v-col xs="12" sm="6" md="6" lg="4" xl="3">
          <v-card class="mx-0" max-width="400" min-height="550">
            <v-img class="white--text align-end" height="220px"
                   :src="require('../assets/fan.jpg')">
              <v-card-title>Fan control</v-card-title>
            </v-img>

            <v-card-text class="text--primary">
              <v-form ref="form">
                <v-slider
                    v-model="fanSpeed"
                    :label="`Fan speed [${fanSpeed}%]`"
                    min="50"
                    max="100"
                >
                </v-slider>
                <v-checkbox
                    v-model="fanManualMode"
                    label="Manual mode"
                    required
                ></v-checkbox>
              </v-form>
            </v-card-text>

            <v-card-subtitle class="pb-0">
              Please note: switching on the manual fan control mode can lead to an uncontrolled temperature change
            </v-card-subtitle>

            <v-card-actions>
              <v-btn color="orange" text @click="saveFanConfig">Save</v-btn>
              <v-btn color="orange" text @click="loadFanFormData">Reset</v-btn>
            </v-card-actions>
          </v-card>

        </v-col>
        <v-col xs="12" sm="6" md="6" lg="4" xl="3">
          <v-card class="mx-0" max-width="400" min-height="550">
            <v-img class="white--text align-end" height="220px"
                   :src="require('../assets/humidifier.jpeg')">
              <v-card-title>Humidify</v-card-title>
            </v-img>

            <v-card-text class="text--primary">
              <v-form ref="form">
                <v-checkbox
                    v-model="humidifyManualMode"
                    label="Manual mode"
                    required
                ></v-checkbox>
                <v-checkbox
                    v-model="humidifyDisabled"
                    label="Disabled"
                    required
                ></v-checkbox>
                <v-slider
                    v-model="humidifyPumpUsageInterval"
                    :label="`Pump usage interval [${humidifyPumpUsageInterval} sec]`"
                    min="10"
                    max="300"
                >
                </v-slider>
                <v-slider
                    v-model="humidifyPumpDuration"
                    :label="`Pump duration [${humidifyPumpDuration} sec]`"
                    min="1"
                    max="20"
                >
                </v-slider>
                <v-slider
                    v-if="humidifyManualMode"
                    v-model="humidifyManualValue"
                    :label="`Humidity [${humidifyManualValue}%]`"
                    min="35"
                    max="100"
                >
                </v-slider>
              </v-form>
            </v-card-text>

            <v-card-actions>
              <v-btn color="orange" text @click="saveHumidifyConfig">Save</v-btn>
              <v-btn color="orange" text @click="loadFanFormData">Reset</v-btn>
            </v-card-actions>
          </v-card>

        </v-col>
      </v-row>
    </v-container>
  </div>
</template>

<script>
export default {
  data: () => ({
    configName: '',
    dayCount: 0,
    fanSpeed: 0,
    fanManualMode: false,
    humidifyManualMode: false,
    humidifyManualValue: 0,
    humidifyDisabled: false,
    humidifyPumpUsageInterval: 0,
    humidifyPumpDuration: 0,
    lightManualMode: false,
    growingInfo: {},
    fanConfig: {},
    configNames: []
  }),

  methods: {
    async loadGrowingInfo() {
      let response = await fetch(process.env.VUE_APP_BASEURL + '/api/growing')
      return await response.json()
    },
    async getConfigNames() {
      let response = await fetch(process.env.VUE_APP_BASEURL + '/api/growing/configs')
      let result = await response.json()
      return result.names
    },
    async getFanConfig() {
      let response = await fetch(process.env.VUE_APP_BASEURL + '/api/fan')
      return await response.json()
    },
    async getHumidifyConfig() {
      let response = await fetch(process.env.VUE_APP_BASEURL + '/api/humidify')
      return await response.json()
    },
    async loadFanFormData() {
      this.fanConfig = await this.getFanConfig()
      this.fanSpeed = this.fanConfig.fan_speed
      this.fanManualMode = this.fanConfig.manual_mode
    },
    async loadHumidifyFormData() {
      this.humidifyConfig = await this.getHumidifyConfig()
      this.humidifyManualMode = this.humidifyConfig.manual_mode
      this.humidifyManualValue = this.humidifyConfig.manual_humidity
      this.humidifyDisabled = this.humidifyConfig.is_disabled
      this.humidifyPumpUsageInterval = this.humidifyConfig.pump_usage_interval
      this.humidifyPumpDuration = this.humidifyConfig.pump_duration
    },
    async loadFormData() {
      this.configNames = await this.getConfigNames()
      this.growingInfo = await this.loadGrowingInfo()

      this.configName = this.growingInfo.config
      this.dayCount = this.growingInfo.day_count

      await this.loadFanFormData()
      await this.loadHumidifyFormData()
    },
    async saveConfig() {
      let data = {
        config: this.configName,
        day_count: this.dayCount,
      }
      await fetch(process.env.VUE_APP_BASEURL + '/api/growing', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(data)
      })
    },
    async saveFanConfig() {
      let data = {
        fan_speed: this.fanSpeed,
        manual_mode: this.fanManualMode,
      }
      await fetch(process.env.VUE_APP_BASEURL + '/api/fan', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(data)
      })
    },
    async saveHumidifyConfig() {
      let data = {
        manual_humidity: this.humidifyManualValue,
        manual_mode: this.humidifyManualMode,
        is_disabled: this.humidifyDisabled,
        pump_usage_interval: this.humidifyPumpUsageInterval,
        pump_duration: this.humidifyPumpDuration,
      }
      await fetch(process.env.VUE_APP_BASEURL + '/api/humidify', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(data)
      })
    }
  },
  async created() {
    await this.loadFormData()
  },
  computed: {
    dayCountLabel: function () {
      return this.dayCount.toString()
    }
  }
}
</script>
