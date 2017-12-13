<template lang="pug">
main 
  .container
    .row
      .col.s12
        main
          h3 スライド一覧
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

<style lang="stylus">
p
  margin 1rem 0rem
  font-size 1.1rem
</style>

