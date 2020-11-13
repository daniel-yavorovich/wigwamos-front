<template>
  <div>
    <v-container>
      <v-row class="mb-6" no-gutters>
        <v-col xs="12" sm="12" md="12" lg="6" xl=6 class="mb-3">
          <v-card
              class="mx-3"
              outlined
              v-if="image"
          >
            <v-list-item>
              <v-list-item-content>
                <div class="overline mb-4">Webcam</div>
                <v-list-item-content>
                  <img :src="image">
                </v-list-item-content>
              </v-list-item-content>
            </v-list-item>
          </v-card>
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>

<script>
export default {
  data() {
    return {
      image: undefined
    }
  },
  methods: {
    async fillData() {
      let response = await fetch(process.env.VUE_APP_BASEURL + '/api/photo/latest.png')
      let image = await response.blob()
      this.image = URL.createObjectURL(image)
    }
  },
  created() {
    this.fillData();
    this.timer = setInterval(this.fillData, 60 * 1000)
  },
  beforeDestroy() {
    clearInterval(this.timer)
  }
}
</script>
