<template lang="pug">
  section
    ul
      li(id="slides-list" v-for="slide in slidesList")
        h3 
          a(:href="slide.uri") {{ slide.title }}
        p {{ slide.description }}
</template>

<script>
import slidesInfo from '../../static/slides.json'

export default {
  props: ['count'],
  name: 'SlideList',
  computed: {
    slidesList () {
      var vm = this
      return slidesInfo
        .slice(0, Math.min(vm.count, slidesInfo.length))
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
