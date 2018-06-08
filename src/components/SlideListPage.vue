<template lang="pug">
main 
    slidelist-components(:count=100000)
</template>

<script>
import Vue from 'vue'
import PostList from './SlideList.vue'
Vue.component('slidelist-components', PostList)

export default {
  name: 'SlideList'
}
</script>

