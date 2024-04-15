<template>
    <img :src="getImageUrl(src)" class="standard"
        :class="{
            'disabled': disabled||status==0, 
            'red_border': status==1,
            'green_border': status==2,
            'blue_border': status==3,
        }"
    />
</template>

<script setup>
import { ref} from 'vue';

const props = defineProps({
    src: String,
    disabled: Boolean,
    status: Number
})

function getImageUrl(name) {
    return new URL(`../assets/hsr1st/${name}.png`, import.meta.url).href
}

</script>

<style scoped>
.standard {
    border: 8px solid white;
}

.disabled {
    opacity: 0.2;
}

.red_border {
    border: 8px solid red;
}

.green_border {
    border: 8px solid lawngreen;
}

.blue_border {
    border: 8px solid blue;
}
</style>