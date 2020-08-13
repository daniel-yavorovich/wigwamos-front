<template>
  <div>
    <v-container>
      <v-row class="mb-12">
        <v-col class="md4">
          <v-card
              class="mx-3"
              max-width="500"
              min-height="220"
              outlined
          >
            <v-list-item>
              <v-list-item-content>
                <div class="overline mb-4">Grow config</div>
                <v-list-item-title class="headline mb-1">{{ config.name }}</v-list-item-title>
              </v-list-item-content>

              <v-list-item-avatar
                  tile
                  size="110">
                <v-img :src="getConfigImage(config.id)"></v-img>
              </v-list-item-avatar>
            </v-list-item>

            <v-card-text>{{ config.description }}</v-card-text>
          </v-card>
        </v-col>
        <v-col class="md4">
          <v-card
              class="mx-3"
              max-width="500"
              min-height="220"
              outlined
          >
            <v-list-item>
              <v-list-item-content>
                <div class="overline mb-4">Grow period</div>
                <v-list-item-title class="headline mb-1">{{ period.name }}</v-list-item-title>
                <v-list-item-subtitle class="headline mb-1">{{ period.day }} day</v-list-item-subtitle>
              </v-list-item-content>

              <v-list-item-avatar
                  tile
                  size="110">
                <v-img :src="getPeriodImage(period.id)"></v-img>
              </v-list-item-avatar>
            </v-list-item>

            <v-card-text>{{ period.description }}</v-card-text>
          </v-card>
        </v-col>
        <v-col class="md4">
          <v-card
              class="mx-3"
              max-width="500"
              min-height="220"
              outlined
          >
            <v-list-item>
              <v-list-item-content>
                <div class="overline mb-4">Watering</div>
                <v-list-item-title class="headline mb-1">Soil is wet</v-list-item-title>
                <v-list-item-subtitle class="headline mb-1">Water level: 18%</v-list-item-subtitle>
              </v-list-item-content>

              <v-list-item-avatar
                  tile
                  size="110">
                <v-img :src="wateringImage"></v-img>
              </v-list-item-avatar>
            </v-list-item>

            <v-card-text>
              Keep an eye on the water level to keep your plants happy
            </v-card-text>
          </v-card>
        </v-col>
      </v-row>
      <v-row class="mb-12">
        <v-col class="mb- 4">
          <v-card
              class="mx-3"
              :min-height="chartOptions.height"
              outlined
          >
            <metric-chart :chart-data="airTemperatureMetricData" :options="chartOptions" :height="chartOptions.height"></metric-chart>
          </v-card>
        </v-col>
        <v-col class="mb-4">
          <v-card
              class="mx-3"
              :min-height="chartOptions.height"
              outlined
          >
            <metric-chart :chart-data="airHumidityMetricData" :options="chartOptions" :height="chartOptions.height"></metric-chart>
          </v-card>
        </v-col>
        <v-col class="mb-4">
          <v-card
              class="mx-3"
              :min-height="chartOptions.height"
              outlined
          >
            <metric-chart :chart-data="fanSpeedMetricData" :options="chartOptions" :height="chartOptions.height"></metric-chart>
          </v-card>
        </v-col>
      </v-row>
      <v-row class="mb-12">
        <v-col>
          <v-card
              class="mx-3"
              :min-height="chartOptions.height"
              outlined
          >
            <metric-chart :chart-data="lightBrightnessMetricData" :options="chartOptions" :height="chartOptions.height"></metric-chart>
          </v-card>
        </v-col>
        <v-col>
          <v-card
              class="mx-3"
              :min-height="chartOptions.height"
              outlined
          >
            <metric-chart :chart-data="waterLevelMetricData" :options="chartOptions" :height="chartOptions.height"></metric-chart>
          </v-card>
        </v-col>
        <v-col>
          <v-card
              class="mx-3"
              :min-height="chartOptions.height"
          >
            <metric-chart :chart-data="CPUTemperatureMetricData" :options="chartOptions" :height="chartOptions.height"></metric-chart>
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
      config: {
        'id': 'autoflowering',
        'name': 'Autoflowering',
        'description': 'Autoflowering cannabis varieties automatically switch from vegetative growth to the flowering stage based on age',
      },
      period: {
        'id': 'vegetative',
        'name': 'Vegetative',
        'description': 'The vegetative stage of cannabis is where the plant’s growth truly takes off',
        'day': 17
      },
      wateringImage: require(`../assets/watering.png`),
      chartOptions: {
        height: 200,
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
    }
  },
  methods: {
    getConfigImage(id) {
      return require(`../assets/${id}.png`)
    },
    getPeriodImage(id) {
      return require(`../assets/${id}.png`)
    },
    async loadMetricsData(metricName, title, color) {
      let response = await fetch(`http://192.168.2.110:5000/api/metrics/${metricName}`)
      let data = await response.json()
      return {
        labels: data.labels,
        datasets: [
          {
            label: title,
            borderColor: color,
            pointBorderColor: color,
            data: data.data,
            fill: false
          }
        ]
      }
    },
    async fillData () {
      this.airTemperatureMetricData = await this.loadMetricsData('air_temperature', 'Air Temperature', '#ff3434')
      this.airHumidityMetricData = await this.loadMetricsData('air_humidity', 'Air Humidity', '#bdd4ff')
      this.fanSpeedMetricData = await this.loadMetricsData('fan_speed', 'Fan speed', '#97ecc1')
      this.lightBrightnessMetricData = await this.loadMetricsData('light_brightness', 'Light brightness', '#ffeb67')
      this.waterLevelMetricData = await this.loadMetricsData('water_level', 'Water level', '#7fa7ff')
      this.CPUTemperatureMetricData = await this.loadMetricsData('pi_temperature', 'CPU temperature', '#ff0000')
    }
  },
  async mounted() {
    await this.fillData()
  }
}
</script>
