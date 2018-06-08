<template lang="pug">
footer
  p 情報系大学生です。Haskellが好きです、ここ最近はコンパイラやCPUを作っています。楽しいものを見つけていきたいと思っています。Kosen14s, Hxs, CSL, oit-compに所属しています。
  p このブログはVue.jsで生成して、Github Pagesで運用しています。
  section
  nav
    a(href="https://github.com/eliza0x") Github
    a(href="https://twitter.com/Eliza_0x") Twitter
    a(href="https://www.facebook.com/profile.php?id=100023006521490") Facebook
    a(href="mailto:me@eliza.link") Mail
  p section © 2017 Copyright Text
</template>

<script>
export default {
  name: 'FooterComponents'
}
</script>

<style scoped>
footer {
    border-top: solid 1px #222;
    font-size: 80%;
    margin-top: 5rem;
}

nav a {
    margin-right: 2rem;
}
</style>
