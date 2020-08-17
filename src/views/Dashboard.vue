<template>
  <div>
    <v-container>
      <v-row class="mb-6" no-gutters>
        <v-col xs="12" sm="6" md="4" lg="3" xl="3">
          <v-card
              class="mx-3"
              outlined
              v-if="growingInfo.period && growingInfo.day_count"
          >
            <v-list-item>
              <v-list-item-content>
                <div class="overline mb-4">Growing</div>
                <v-list-item-title class="headline mb-1">{{ growingInfo.config }}</v-list-item-title>
                <v-list-item-subtitle class="headline mb-1">
                  {{ growingInfo.period }},
                  {{ growingInfo.day_count }} day
                </v-list-item-subtitle>
              </v-list-item-content>

              <v-list-item-avatar
                  tile
                  size="100">
                <v-img :src="getConfigImage(growingInfo.config)"></v-img>
              </v-list-item-avatar>
            </v-list-item>
          </v-card>
        </v-col>
        <v-col xs="12" sm="6" md="6" lg="3" xl="3">
          <v-card
              class="mx-3"
              outlined
              v-if="airTemperatureMetricData.avgValue && airHumidityMetricData.avgValue"
          >
            <v-list-item>
              <v-list-item-content>
                <div class="overline mb-4">Microclimate</div>
                <v-list-item-title class="headline mb-1">
                  Temperature: {{ airTemperatureMetricData.avgValue }} ℃
                </v-list-item-title>
                <v-list-item-subtitle class="headline mb-1">
                  Humidity: {{ airHumidityMetricData.avgValue }} %
                </v-list-item-subtitle>
              </v-list-item-content>

              <v-list-item-avatar
                  tile
                  size="100">
                <v-img :src="microclimateImage"></v-img>
              </v-list-item-avatar>
            </v-list-item>
          </v-card>
        </v-col>
        <v-col xs="12" sm="6" md="6" lg="3" xl="3">
          <v-card
              class="mx-3"
              outlined
              v-if="growingInfo.sunrise_start && growingInfo.sunset_stop"
          >
            <v-list-item>
              <v-list-item-content>
                <div class="overline mb-4">Sun</div>
                <v-list-item-title class="headline mb-1">
                  Sunrise: {{ growingInfo.sunrise_start }} - {{ growingInfo.sunrise_stop}}
                </v-list-item-title>
                <v-list-item-subtitle class="headline mb-1">
                  Sunset: {{ growingInfo.sunset_start }} - {{ growingInfo.sunset_stop}}
                </v-list-item-subtitle>
              </v-list-item-content>

              <v-list-item-avatar
                  tile
                  size="100">
                <v-img :src="require('../assets/sun.png')"></v-img>
              </v-list-item-avatar>
            </v-list-item>
          </v-card>
        </v-col>
        <v-col xs="12" sm="6" md="6" lg="3" xl="3">
          <v-card
              class="mx-3"
              outlined
              v-if="wateringStatus"
          >
            <v-list-item>
              <v-list-item-content>
                <div class="overline mb-4">Watering</div>
                <v-list-item-title class="headline mb-1">{{ wateringStatus }}</v-list-item-title>
                <v-list-item-subtitle class="headline mb-1">Water level: {{ waterLevelMetricData.avgValue }}%
                </v-list-item-subtitle>
              </v-list-item-content>

              <v-list-item-avatar
                  tile
                  size="100">
                <v-img :src="wateringImage"></v-img>
              </v-list-item-avatar>
            </v-list-item>
          </v-card>
        </v-col>
      </v-row>
      <v-row class="mb-6" no-gutters>
        <v-col xs="12" sm="6" md="6" lg="4" xl="4">
          <v-card
              class="mx-3"
              :min-height="chartOptions.height"
              outlined
          >
            <metric-chart :chart-data="airTemperatureMetricData" :options="chartOptions"
                          :height="chartOptions.height"></metric-chart>
          </v-card>
        </v-col>
        <v-col xs="12" sm="6" md="6" lg="4" xl="4">
          <v-card
              class="mx-3"
              :min-height="chartOptions.height"
              outlined
          >
            <metric-chart :chart-data="airHumidityMetricData" :options="chartOptions"
                          :height="chartOptions.height"></metric-chart>
          </v-card>
        </v-col>
        <v-col xs="12" sm="6" md="6" lg="4" xl="4">
          <v-card
              class="mx-3"
              :min-height="chartOptions.height"
              outlined
          >
            <metric-chart :chart-data="fanSpeedMetricData" :options="chartOptions"
                          :height="chartOptions.height"></metric-chart>
          </v-card>
        </v-col>
      </v-row>
      <v-row class="mb-6" no-gutters>
        <v-col xs="12" sm="6" md="6" lg="4" xl="4">
          <v-card
              class="mx-3"
              :min-height="chartOptions.height"
              outlined
          >
            <metric-chart :chart-data="lightBrightnessMetricData" :options="chartOptions"
                          :height="chartOptions.height"></metric-chart>
          </v-card>
        </v-col>
        <v-col xs="12" sm="6" md="6" lg="4" xl="4">
          <v-card
              class="mx-3"
              :min-height="chartOptions.height"
              outlined
          >
            <metric-chart :chart-data="waterLevelMetricData" :options="chartOptions"
                          :height="chartOptions.height"></metric-chart>
          </v-card>
        </v-col>
        <v-col xs="12" sm="6" md="6" lg="4" xl="4">
          <v-card
              class="mx-3"
              :min-height="chartOptions.height"
          >
            <metric-chart :chart-data="CPUTemperatureMetricData" :options="chartOptions"
                          :height="chartOptions.height"></metric-chart>
          </v-card>
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>

<script>
import MetricChart from "@/components/MetricChart";

export default {
  components: {
    MetricChart
  },
  data() {
    return {
      timer: '',
      wateringImage: require(`../assets/watering.png`),
      microclimateImage: require(`../assets/microclimate.png`),
      wateringStatus: '',
      chartOptions: {
        height: 230,
        scales: {
          yAxes: [
            {
              ticks: {
                beginAtZero: true,
                maxTicksLimit: 4
              }
            }]
        },
        legend: {
          labels: {
            fontColor: 'white',
            fontSize: 12,
            fontFamily: '"Roboto", sans-serif !important'
          }
        },
        responsive: true,
        maintainAspectRatio: true,
      },
      // Init charts data variables
      airTemperatureMetricData: {},
      airHumidityMetricData: {},
      fanSpeedMetricData: {},
      lightBrightnessMetricData: {},
      waterLevelMetricData: {},
      CPUTemperatureMetricData: {},
      // Init growing data var
      growingInfo: {}
    }
  },
  methods: {
    getConfigImage(id) {
      return require(`../assets/${id}.png`)
    },
    async loadGrowingInfo() {
      let response = await fetch(process.env.VUE_APP_BASEURL + '/api/growing')
      return await response.json()
    },
    async loadMetricsData(metricName, title, color) {
      let response = await fetch(process.env.VUE_APP_BASEURL + `/api/metrics/${metricName}`)
      let data = await response.json()
      let avgValue = Math.round(data.avg)
      return {
        labels: data.labels,
        avgValue: avgValue,
        datasets: [
          {
            label: `${title}`,
            borderColor: color,
            pointBorderColor: color,
            data: data.data,
            fill: false
          }
        ]
      }
    },
    async fillData() {
      // Growing info
      this.growingInfo = await this.loadGrowingInfo()

      // Metrics
      this.airTemperatureMetricData = await this.loadMetricsData('air_temperature', 'Air Temperature', '#ff3434')
      this.airHumidityMetricData = await this.loadMetricsData('air_humidity', 'Air Humidity', '#bdd4ff')
      this.fanSpeedMetricData = await this.loadMetricsData('fan_speed', 'Fan speed', '#97ecc1')
      this.lightBrightnessMetricData = await this.loadMetricsData('light_brightness', 'Light brightness', '#ffeb67')
      this.waterLevelMetricData = await this.loadMetricsData('water_level', 'Water level', '#7fa7ff')
      this.CPUTemperatureMetricData = await this.loadMetricsData('pi_temperature', 'CPU temperature', '#ff0000')

      if (this.waterLevelMetricData.avgValue <= 10) {
        this.wateringStatus = 'Need watering'
      } else {
        this.wateringStatus = 'Soil is wet'
      }
    }
  },
  created() {
    this.fillData();
    this.timer = setInterval(this.fillData, 10 * 1000)
  },
  beforeDestroy() {
    clearInterval(this.timer)
  }
}
</script>
