<template>
    <img :src="getImageUrl(src)" :class="{'disabled': disabled}">
</template>

<script setup>
import { ref} from 'vue';

const props = defineProps({
    src: String,
    disabled: Boolean
})

function getImageUrl(name) {
    return new URL(`../assets/hsr1st/${name}.png`, import.meta.url).href
}

</script>

<style scoped>
.disabled {
    opacity: 0.2;
}
</style>