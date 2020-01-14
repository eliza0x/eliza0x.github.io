<template lang="pug">
section#app
    header-components#head
    router-view#main
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
body a
  color: #4a4a4a;
  text-decoration: underline;
  &:hover
    color: #DF3A01;
    text-decoration: none;
    border-bottom: none;

#main
  font-family serif

for i in (1..5)
  #main h{i}
    font-family sans-serif
    &::before
      content "# "
</style>
