<template lang="pug">
main 
    div
      postlist-components(:count=5, :tagFilter=false)
      div
        a(href="/#/posts") And more ...
</template>

<script>
import $ from 'jquery'
import Vue from 'vue'
import PostList from './PostList.vue'
import SlideList from './SlideList.vue'
Vue.component('postlist-components', PostList)
Vue.component('slidelist-components', SlideList)

export default {
  name: 'RootPage',
  created () {
    $(document).ready(function () {
      $('.parallax').parallax()
    })
  }
}
</script>

