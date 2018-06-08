<template lang="pug">
main 
    h3 Tag: {{ tag }} のついているページ
    postlist-components(:count="100000", :tagFilter="true", :tag="tag")
</template>

<script>
import Vue from 'vue'
import PostList from './PostList.vue'
Vue.component('postlist-components', PostList)

export default {
  name: 'TagPageListPage',
  computed: {
    tag () {
      return this.$route.params.id
    }
  }
}
</script>

