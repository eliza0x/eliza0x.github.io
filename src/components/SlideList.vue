<template lang="pug">
  section
    ul
      li(id="slides-list" v-for="slide in slidesList")
        a(:href="slide.uri").clear-color
          .card.grey.lighten-4
            .card-content
              span.card-title.article-title {{ slide.title }}
              div.chip.auther
                img(:src="\"/static/images/\"+slide.auther+\".jpeg\"" alt="Auther")
                | auther: {{ slide.auther }}
              p.description {{ slide.description }}
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

<style lang="stylus">
p
  margin 1rem 0rem
  font-size 1.1rem
.clear-color
  color #222

.description
  margin 0.6rem 0.2rem !important
</style>

