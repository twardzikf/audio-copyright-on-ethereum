<template>
  <div class="properties">
    <div class="section md-layout">
      <md-field class="md-layout-item md-size-70">
        <label>Choose audio file</label>
        <md-file name="song" id="song-input" v-on:change="getFileBytesArray" />
      </md-field>
      <md-button
        class="md-raised md-primary md-layout-item md-size-10"
        v-on:click="calculateFingerprint"
      >Upload</md-button>
    </div>
    <div class="section">
      <span class="title">My properties</span>
    </div>
    <div class="section">
      <span class="title">Properties for sell</span>
    </div>
  </div>
</template>
<script>
export default {
  name: 'Properties',
  props: {
  },
  data: function() {
    return {
      file: null
    };
  },
  methods: {
    calculateFingerprint: function() {
      const baseURI = "http://localhost:3000/";
      var formData = new FormData();
      formData.append("song", this.file);
      this.$http.post(baseURI, formData, {
        headers: {
          "Content-Type": "multipart/form-data"
        }
      });
    },
    getFileBytesArray: function(event) {
      this.file = event.target.files[0];
    },
  }
}
</script>
<style scoped>
.section {
  padding: 0.5rem 0;
  border-bottom: 1px solid #00C0F5;
}
.title {
  font-size: 1.25rem;
  color: black;
}


input {
  appearance: none;
  border: none;
  min-width: 0;
  font-family: sans-serif;
  line-height: 1;
  background: transparent;
}
</style>