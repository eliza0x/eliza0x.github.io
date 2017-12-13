<template lang="pug">
main 
  .section.white
    .container.row
      .col.s12
        main
          h3 最近の投稿 
          postlist-components(:count=5, :tagFilter=false)
          .card
            h5.card-content.center.grey.lighten-4
                a(href="/#/posts")
                    .grey-text.text-darken-2 And more ...
</template>

<script>
import $ from 'jquery'
import Vue from 'vue'
import PostList from './PostList.vue'
Vue.component('postlist-components', PostList)

export default {
  name: 'RootPage',
  created () {
    $(document).ready(function () {
      $('.parallax').parallax()
    })
  }
}
</script>

<style lang="stylus">
p
  margin 1rem 0rem
  font-size 1.1rem

.parallax-container img
  object-fix cover
  @media (max-width: 1000px)
    width 1000px
  @media (max-width: 600px)
    width 600px

.parallax-height-top
  height 200px
  @media (min-width: 600px)
    height 400px

.parallax-height-bottom
  height 100px
  @media (min-width: 600px)
    height 200px
</style>

