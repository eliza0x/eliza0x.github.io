<template lang="pug">
section#app
    header-components#head
    router-view
    footer-components
</template>

<script>
import Vue from 'vue'
import Header from './components/Header.vue'
import Footer from './components/Footer.vue'

export default {
  name: 'app'
}

Vue.component('header-components', Header)
Vue.component('footer-components', Footer)
</script>

<style lang="stylus">
for i in (1..5)
  .h{i}
    &::before
      content "# "
      color   #e65100
</style>
