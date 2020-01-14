<template lang="pug">
footer
  p 情報系大学生です。プログラミング言語, コンパイラ, CPUに感心があります。楽しいものを見つけていきたいと思っています。
  nav
    a(href="https://github.com/eliza0x") Github
    a(href="https://twitter.com/Eliza_0x") Twitter
    a(href="mailto:me@eliza.link") Mail
</template>

<script>
export default {
  name: 'FooterComponents'
}
</script>

<style scoped>
footer {
    font-family: sans-serif;
    // border-top: solid 1px #222;
    font-size: 80%;
    margin-top: 7rem;
}

nav a {
    margin-right: 2rem;
}
</style>
