<script setup>
// import HelloWorld from './components/HelloWorld.vue'
import { ref } from 'vue'

const msg = ref('Vite + Vue')
</script>

<template>
  <div style="display: flex; flex-direction: column;">
    <router-view class="content"></router-view>
  </div>
  <!-- <HelloWorld :msg /> -->
</template>

<style scoped>
.logo {
  height: 6em;
  padding: 1.5em;
  will-change: filter;
  transition: filter 300ms;
}
.logo:hover {
  filter: drop-shadow(0 0 2em #646cffaa);
}
.logo.vue:hover {
  filter: drop-shadow(0 0 2em #42b883aa);
}

.content {
  height: 100%;
  width: 100%;
}
</style>
