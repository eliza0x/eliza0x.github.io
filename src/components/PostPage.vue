<template lang="pug">
main
  header
    h1 {{ currentPage.title }}
    nav
      | tags: 
      a(v-for="tag in currentPage.tags" :href="\"/#/tags/\"+tag") \#{{ tag }}
      time date: {{ currentPage.date }}
  
  article(id="html" v-html="html")
</template>

<script>
import axios from 'axios'
import articleInfo from '../../static/articles.json'

function compileMarkdown (data) {
  var marked = require('marked')
  ;(function () {
    var renderer = new marked.Renderer()
    renderer.code = function (code, language) {
      // eslint-disable-next-line
      return '<code class="hljs">' + hljs.highlightAuto(code).value + '</code>'
    }
    renderer.image = function (href, title, text) {
      return '<img src="' + href + '">'
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
      html: '<div class="loader">Loading...</div>',
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
          self.html = compileMarkdown(response.data)
        })
        .catch(function (_) {
          this.toast()
        })
    },
    toast: function () {
      console.log('記事の取得に失敗しました。')
    }
  }
}
</script>
 
<style scoped>
nav a {
  margin-right: 1rem;   
}

time {
  display: block;
}

.loader,
.loader:before,
.loader:after {
  border-radius: 50%;
  width: 2.5em;
  height: 2.5em;
  -webkit-animation-fill-mode: both;
  animation-fill-mode: both;
  -webkit-animation: load7 1.8s infinite ease-in-out;
  animation: load7 1.8s infinite ease-in-out;
}
.loader {
  color: #585858;
  font-size: 10px;
  margin: 80px auto;
  position: relative;
  text-indent: -9999em;
  -webkit-transform: translateZ(0);
  -ms-transform: translateZ(0);
  transform: translateZ(0);
  -webkit-animation-delay: -0.16s;
  animation-delay: -0.16s;
}
.loader:before,
.loader:after {
  content: '';
  position: absolute;
  top: 0;
}
.loader:before {
  left: -3.5em;
  -webkit-animation-delay: -0.32s;
  animation-delay: -0.32s;
}
.loader:after {
  left: 3.5em;
}
@-webkit-keyframes load7 {
  0%,
  80%,
  100% {
    box-shadow: 0 2.5em 0 -1.3em;
  }
  40% {
    box-shadow: 0 2.5em 0 0;
  }
}
@keyframes load7 {
  0%,
  80%,
  100% {
    box-shadow: 0 2.5em 0 -1.3em;
  }
  40% {
    box-shadow: 0 2.5em 0 0;
  }
}
</style>
