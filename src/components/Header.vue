<template lang="pug">
nav.orange.darken-4
  .nav-wrapper
    .container
      a(href="/#/").blog-title のばなしうさぎ
      ul(id="mobile-demo").right.hide-on-med-and-down
        li
          a(href="/#/").link Home
        li
          a(href="/#/Posts").link Posts
        li
          a(href="/#/Slides").link Slides
</template>

<script>
export default {
  name: 'Header'
}
</script>

<style scoped lang="stylus">
.blog-title
  font-size 1.9rem
  margin 0rem 1rem

.link
  font-size 1.3rem
</style>
