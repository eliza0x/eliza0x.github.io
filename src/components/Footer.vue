<template lang="pug">
    footer.page-footer.orange.darken-3
        .container
            .row
                .col.s9
                    h4.white-text About me
                    p.white-text.text-lighten-4 大学一年生のプログラマです。Haskellが好きです、ここ最近はコンパイラやCPUを作っています。楽しいものを見つけていきたいと思っています。Kosen14s, Hxs, CSL, oit-compに所属しています。
                    p.white-text.text-lighten-4 このブログはVue.jsで生成して、Github Pagesで運用しています。
                .col.s3
                    h4.white-text Links
                    ul
                        li
                            a(href="https://github.com/eliza0x").white-text
                                | Github
                        li
                            a(href="https://twitter.com/Eliza_0x").white-text
                                | Twitter
                        li
                            a(href="https://www.facebook.com/profile.php?id=100023006521490").white-text
                                | Facebook
                        li
                            a(href="mailto:me@eliza.link").white-text
                                | Mail

        .footer-copyright.orange.darken-4
            .container © 2017 Copyright Text
</template>

<script>
export default {
  name: 'FooterComponents'
}
</script>
