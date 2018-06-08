<template lang="pug">
  section
    ul(id="article-list")
      li(v-for="article in articleList").post
        div 
          h3 
            a(:href="article.uri") {{ article.title }}
        div tags:
          a(:href="\"/#/tags/\"+tag" v-for="tag in article.tags").tag \#{{ tag }}
        p {{ article.description }}
</template>

<script>
import articleInfo from '../../static/articles.json'

export default {
  props: ['count', 'tagFilter', 'tag'],
  name: 'PostList',
  data () {
    return {
    }
  },
  computed: {
    articleList () {
      var vm = this
      return articleInfo
        .slice(0, Math.min(vm.count, articleInfo.length))
        .filter((element, index, array) => { return !(vm.tagFilter) || element.tags.indexOf(vm.tag) >= 0 })
    }
  }
}
</script>

<style scoped>
.tag {
    display: inline;
    margin-left: 0.5rem;
}

ul {
    margin: 0px;
    padding: 0px;
}

li {
    list-style-type: none;
}

li:not(:first-child) {
    border-top: dotted 1px #222; 
}

h3 {
    margin-bottom: 1rem;
    margin-top: 3rem;
}
</style>
