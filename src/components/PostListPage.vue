<template lang="pug">
main 
    postlist-components(:count=100000, :tagFilter=false)
</template>

<script>
import Vue from 'vue'
import PostList from './PostList.vue'
Vue.component('postlist-components', PostList)

export default {
  name: 'RootPage'
}
</script>

