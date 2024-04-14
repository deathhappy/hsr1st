<template>
    <div>
        <div class="title" style="flex-direction: column;">
            <div class="title">
                <div class="title_text">總數: 29 已收集：{{ disabledCount }} 未收集：{{29 - disabledCount}}</div>
                <el-button type="primary" @click="resetDisabled">清除紀錄</el-button>
            </div>            
            <div class="title">
                <div class="title_text">單排數量: </div>
                <el-select v-model="rowNum" placeholder="Select" style="width: 240px">
                    <el-option
                        v-for="item in 29"
                        :key="item"
                        :label="item"
                        :value="item"
                    />
                </el-select>
            </div>            
        </div>        
        <div class="image-row">
            <imageCard v-for="(img, i) in images" :src="img.name" :disabled="img.disabled" 
                :key="i" @click="clickCard(img, i)" :style="dynamicWidth" />
        </div>
    </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue';
import imageCard from '@/components/imageCard.vue'
const images = ref([]);
const rowNum = ref(8);
const disabledArray = ref([])

onMounted(() => {
    loadImages()
})

const loadImages = () => {
    images.value = []
    const requireImages = import.meta.glob('../assets/hsr1st/*.png');
    //console.log(requireImages);
    disabledArray.value = getArrayFromCookie('disabledArray')
    for (const key in requireImages) {
        // console.log(key);
        const match = key.match(/([^\/]+)\.\w+$/);

        const partyName = match ? match[1] : null;
        //console.log('Party Name:', partyName);
        let isDisabled = disabledArray.value.includes(partyName)
        images.value.push({name: partyName, path: key, disabled: isDisabled})
    }

    
    for (let index = 0; index < images.value.length; index++) {
        const element = images.value[index];        
    }
    //console.log(images.value)
};

const dynamicWidth = computed(() => {
    return `width: calc(100% / ${rowNum.value})`;
});

const disabledCount = computed(() => {
    return 29 - images.value.filter(element => element.disabled).length
})

function clickCard(img, index) {
    img.disabled=!img.disabled
    setArrayToCookie('disabledArray', images.value.filter(item => item.disabled === true).map(item => item.name))
}

function resetDisabled() {
    setArrayToCookie('disabledArray', [])
    loadImages()
}

function getCookie(name) {
  const cookieString = document.cookie;
  const cookies = cookieString.split('; ');

  for (const cookie of cookies) {
    const [cookieName, cookieValue] = cookie.split('=');
    if (cookieName === name) {
      return decodeURIComponent(cookieValue);
    }
  }

  return null;
}

function setCookie(name, value, daysToExpire=365) {
  const expirationDate = new Date();
  expirationDate.setDate(expirationDate.getDate() + daysToExpire);

  const cookieString = `${encodeURIComponent(name)}=${encodeURIComponent(value)}; expires=${expirationDate.toUTCString()}; path=/`;
  document.cookie = cookieString;
}

function setArrayToCookie(name, array, daysToExpire) {
  const arrayString = JSON.stringify(array);
  setCookie(name, arrayString, daysToExpire);
}

function getArrayFromCookie(name) {
  const arrayString = getCookie(name);
  return arrayString ? JSON.parse(arrayString) : [];
}


</script>

<style scoped>
.title {
    display: flex;
    gap: 8px;
}

.title_text {
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