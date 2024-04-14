<template>
    <div>
        <div class="title">Total: {{ disabledCount }} / 29</div>
        <div class="image-row">
            <imageCard v-for="(img, i) in images" :src="img.name" :disabled="img.disabled" 
                :key="i" @click="img.disabled=!img.disabled" />
            
        </div>
    </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue';
import imageCard from '@/components/imageCard.vue'
const images = ref([]);

const loadImages = () => {
    images.value = []
    const requireImages = import.meta.glob('../assets/hsr1st/*.png');
    console.log(requireImages);
    for (const key in requireImages) {
        // console.log(key);
        const match = key.match(/([^\/]+)\.\w+$/);

        const partyName = match ? match[1] : null;
        //console.log('Party Name:', partyName);

        images.value.push({name: partyName, path: key, disabled: false})

    }
    console.log(images.value)
};

// Split images into chunks of 6
const imageChunks = computed(() => {
    const chunkSize = 6;
    const chunks = [];
    for (let i = 0; i < images.value.length; i += chunkSize) {
        chunks.push(images.value.slice(i, i + chunkSize));
    }
    return chunks;
});

const disabledCount = computed(() => {
    return 29 - images.value.filter(element => element.disabled).length
})

onMounted(loadImages);

</script>

<style scoped>
.title {
    font-size: 24px;
}

.image-row {
    width: 100%;
    display: flex;
    flex-wrap: wrap;
}
  
.image-row img {
    //width: calc(100% / 12);
}
</style>