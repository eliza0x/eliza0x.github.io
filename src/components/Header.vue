<template lang="pug">
nav
  div.logo
    a(href="/#/").logo のばなしうさぎ
  div.nav
    a(href="/#/") Home
    a(href="/#/Posts") Posts
    a(href="/#/Slides") Slides
</template>

<script>
export default {
  name: 'Header'
}
</script>

<style scoped>
.nav {
    text-align: right;
}
.nav a {
    margin-right: 3rem;
}
.logo {
    text-align: left;
    color: #222;
}

nav {
    // border-bottom: solid 1px #222;
    margin-bottom: 5rem;
    display: flex;
    justify-content: space-between;
    font-family: sans-serif;
}

nav a {
    margin-right: 2rem;
}
</style>
