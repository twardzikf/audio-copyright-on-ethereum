<template>
  <div class="properties">
    <div class="section">
      <input type="file" id="audio-input" @change="getFileBytesArray" />
      <button
        class="upload-button"
        @click="calculateFingerprint"
      >Upload your audio file</button>
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
  methods: {
    getFileBytesArray() {
      return ''
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