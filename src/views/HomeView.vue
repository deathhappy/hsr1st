<template>
    <div>
        <div class="title" style="flex-direction: column;">
            <!-- <div class="title">
                <div class="title_text">總數: 29 未收集：{{ disabledCount }} 已收集：{{29 - disabledCount}}</div>
            </div>-->
            <div class="title">
                <div class="title_text">單排數量: </div>
                <el-select v-model="rowNum" placeholder="Select" style="width: 80px" @change="rowNumChange">
                    <el-option
                        v-for="item in 29"
                        :key="item"
                        :label="item"
                        :value="item"
                    />
                </el-select>
                <el-button type="primary" @click="resetCookie">清除紀錄</el-button>
                <el-button type="primary" @click="takeScreenshot">輸出截圖</el-button>
                <el-switch v-model="isEnableDisplay" /><div class="title_text">不顯示半透明</div>
            </div>            
        </div>        
        <div id="image_block" class="image_block">
            <div class="image-row" v-for="(chunk, index) in imageChunks" :key="index">
                <imageCard v-for="(img, i) in chunk" :src="img.name" :status="img.status"
                    :key="i" @click="clickCard(img, i)" :class="{'display_none': isEnableDisplay&&img.status==0}" />
            </div>
            
        </div>
    </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue';
import html2canvas from 'html2canvas'
import imageCard from '@/components/imageCard.vue'
const images = ref([]);
const rowNum = ref(10);
const disabledArray = ref([])
const statusArray = ref([[],[],[],[]])
const isEnableDisplay = ref(false)

onMounted(() => {
    loadImages()
})

const loadImages = () => {
    images.value = []
    const requireImages = import.meta.glob('../assets/hsr1st/*.png');
    //console.log(requireImages);
    statusArray.value = getArrayFromCookie('statusArray');
    console.log(statusArray.value);
    rowNum.value = Number(getCookie('rowNum')!= undefined ? getCookie('rowNum') : 8)
    for (const key in requireImages) {
        // console.log(key);
        const match = key.match(/([^\/]+)\.\w+$/);

        const partyName = match ? match[1] : null;
        //console.log('Party Name:', partyName);
        images.value.push({name: partyName, path: key, status: getStatus(partyName)})
    }

    for (let index = 0; index < images.value.length; index++) {
        const element = images.value[index];        
    }
    console.log(images.value)
};

function getStatus(key) {
    for (let index = 0; index < statusArray.value.length; index++) {
        const element = statusArray.value[index];
        if(element.includes(key))
            return index        
    }
    return -1
}

const dynamicWidth = computed(() => {
    return `width: calc(100% / ${rowNum.value} - 16px);`;
});

const disabledCount = computed(() => {
    return 29 - images.value.filter(element => element.disabled).length
})

function clickCard(img, index) {
    img.status += 1
    if(img.status > 3) {
        img.status = -1
    }
    for (let index = 0; index < 4; index++) {
        statusArray.value[index] = images.value.filter(item => item.status === index).map(item => item.name)
    }
    
    setArrayToCookie('statusArray', statusArray.value)
    // img.disabled=!img.disabled
    // setArrayToCookie('disabledArray', images.value.filter(item => item.disabled === true).map(item => item.name))
}

function resetCookie() {
    setArrayToCookie('statusArray', [])
    loadImages()
}

function takeScreenshot() {   
    const element = document.getElementById('image_block');
    html2canvas(element).then(canvas => {
        const imgURL = canvas.toDataURL();

        const downloadLink = document.createElement('a');
        downloadLink.href = imgURL;

        downloadLink.download = 'screenshot.png';

        document.body.appendChild(downloadLink);
        downloadLink.click();

        document.body.removeChild(downloadLink);
    });
}

function rowNumChange() {
    setCookie('rowNum', rowNum.value)
}

const imageChunks = computed(() => {
    const displayImagge = isEnableDisplay.value ? images.value.filter(item => item.status !== 0) : images.value
    const chunks = [];
    for (let i = 0; i < displayImagge.length; i += rowNum.value) {
        chunks.push(displayImagge.slice(i, i + rowNum.value));
    }
    return chunks;
});

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
    justify-content: center;
    align-items: center;
}

.title_text {
    font-size: 24px;
}

.image_block {
    width: 100%;
    display: flex;
    flex-direction: column;
}

.image-row {
    width: 100%;
    display: flex;
    flex-wrap: nowrap;
    flex-direction: row;
}
  
.image-row img {
    
}

.display_none {
    display: none;
}
</style>