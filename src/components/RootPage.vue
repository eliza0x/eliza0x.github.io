<template lang="pug">
main 
    div
      postlist-components(:count=5, :tagFilter=false)
      a(href="/#/posts") もっと読む
</template>

<script>
import Vue from 'vue'
import PostList from './PostList.vue'
import SlideList from './SlideList.vue'
Vue.component('postlist-components', PostList)
Vue.component('slidelist-components', SlideList)

export default {
  name: 'RootPage'
}
</script>

