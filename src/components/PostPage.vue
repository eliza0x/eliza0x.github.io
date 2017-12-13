<template lang="pug">
div.container
    section.row
        main#article.col.s12
            header
                h1 {{ currentPage.title }}
                div.chip.auther
                    img(:src="\"/static/images/\"+currentPage.auther+\".jpeg\"" alt="Auther ")
                    | auther: {{ currentPage.auther }}
                div(v-for="tag in currentPage.tags").chip 
                    a(:href="\"/#/tags/\"+tag").tag \#{{ tag }}
                p date: {{ currentPage.date }}

            article(id="html" v-html="html")
</template>

<script>
import axios from 'axios'
import materialize from 'materialize-css'
import articleInfo from '../../static/articles.json'

function comipleMarkdown (data) {
  var marked = require('marked')
  ;(function () {
    var renderer = new marked.Renderer()
    renderer.code = function (code, language) {
      // eslint-disable-next-line
      return '<pre class="card"><code class="card-content hljs">' + hljs.highlightAuto(code).value + '</code></pre>'
    }
    renderer.image = function (href, title, text) {
      return '<div class="card"><div class="card-image"><img src="' + href + '"></div></div>'
    }
    marked.setOptions({
      renderer: renderer
    })
  })()
  return marked(data)
}

export default {
  name: 'PostPage',
  data () {
    return {
      html: '',
      currentPage: ''
    }
  },
  computed: {
    currentURI () {
      return '/#/posts/' + this.$route.params.id
    }
  },
  watch: {
    currentURI () {
      this.updateCurrentPage()
    },
    currentPage () {
      this.updateArticle()
    }
  },
  mounted () {
    this.updateCurrentPage()
    this.updateArticle()
  },
  methods: {
    updateCurrentPage: function () {
      const self = this
      this.currentPage = articleInfo.find((element, index, array) => {
        return element.uri === self.currentURI
      })
    },
    updateArticle: function () {
      const self = this
      axios.get(this.currentPage.file)
        .then(function (response) {
          self.html = comipleMarkdown(response.data)
        })
        .catch(function (_) {
          this.toast()
        })
    },
    toast: function () {
      materialize.toast('記事の取得に失敗しました', 4000)
    }
  }
}
</script>
 
<style lang="stylus">
#article a
    color: #777;
    font-weight: 900;
</style>
