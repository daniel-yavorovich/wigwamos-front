<template>
  <div>
    <v-container>
      <v-row class="mb-6" no-gutters>
        <v-col xs="12" sm="12" md="4" lg="3" xl="3">
          <v-card class="mx-0" max-width="400" min-height="500">
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
                <v-checkbox
                    v-model="manualMode"
                    label="Manual mode"
                    required
                ></v-checkbox>
              </v-form>
            </v-card-text>
            <v-card-actions>
              <v-btn color="orange" text @click="saveConfig">Save</v-btn>
              <v-btn color="orange" text @click="reset">Reset</v-btn>
            </v-card-actions>
          </v-card>

        </v-col>
        <v-col xs="12" sm="12" md="4" lg="3" xl="3">
          <v-card class="mx-0" max-width="400" min-height="500" v-if="manualMode">
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
                    v-model="manualMode"
                    label="Manual mode"
                    required
                ></v-checkbox>
              </v-form>
            </v-card-text>

            <v-card-subtitle class="pb-0">
              Please note: switching on the manual fan control mode can lead to an uncontrolled temperature change
            </v-card-subtitle>

            <v-card-actions>
              <v-btn color="orange" text @click="saveConfig">Save</v-btn>
              <v-btn color="orange" text @click="reset">Reset</v-btn>
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
    manualMode: false,
    growingInfo: {},
    configNames: []
  }),

  methods: {
    async reset() {
      await this.$refs.form.reset()
      await this.loadFormData()
    },
    async loadGrowingInfo() {
      let response = await fetch(process.env.VUE_APP_BASEURL + '/api/growing')
      return await response.json()
    },
    async getConfigNames() {
      let response = await fetch(process.env.VUE_APP_BASEURL + '/api/growing/configs')
      let result = await response.json()
      return result.names
    },
    async loadFormData() {
      this.configNames = await this.getConfigNames()
      this.growingInfo = await this.loadGrowingInfo()
      this.configName = this.growingInfo.config
      this.dayCount = this.growingInfo.day_count
      this.manualMode = this.growingInfo.manual_mode
    },
    async saveConfig() {
      let data = {
        config: this.configName,
        day_count: this.dayCount,
        manual_mode: this.manualMode,
      }
      let response = await fetch(process.env.VUE_APP_BASEURL + '/api/growing', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify(data)
      })
      console.log(await response.json())
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
