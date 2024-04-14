<template>
    <img :src="getImageUrl(src)" :class="{'disabled': disabled}">
</template>

<script setup>
import { ref} from 'vue';

const props = defineProps({
    src: String,
    disabled: Boolean
})

function getImageUrl(path) {
    return new URL(`${path}`, import.meta.url).href
}

</script>

<style scoped>
.disabled {
    opacity: 0.2;
}
</style>