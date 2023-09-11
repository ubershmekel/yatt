<template>
  <img class="logo" src="/yatt-logo.png">
  <h1>You Are The Translator</h1>
  <!-- Minified version -->
  <link rel="stylesheet" href="https://cdn.simplecss.org/simple.min.css">
  <link rel='icon' type='image/png' href='/favicon.png'>

  <p>
    Hands-free language learning.
  </p>

  <p>
    Select your native language, then select a language to learn. The game will then give you a sentence to translate from
    one language to the other. Please be safe - but in theory - it's kind of like a Duolingo you can use while driving.
  </p>

  <p>Learn English, Arabic, German, Greek, French, Hebrew, Italian, Japanese, Korean, Portuguese, Russian, or Spanish.
  </p>

  <h3>Download</h3>
  <a class="download" href='https://apps.apple.com/us/app/you-are-the-translator/id6463097357'><img
      alt='Download on the App Store' src='/appstore.svg' preserveAspectRatio="none" /></a>

  <a class="download" href='https://play.google.com/store/apps/details?id=com.andluck.yatt&utm_source=web'><img
      alt='Get it on Google Play' src='/googleplay.svg' /></a>

  <h3>Other links</h3>
  <p>Check out the open source code at <a
      href="https://github.com/ubershmekel/yatt">https://github.com/ubershmekel/yatt</a></p>
  <p>Please tweet YATT feedback at <a href="https://twitter.com/ubershmekel">ubershmekel@</a></p>
</template>


<style>
.download img {
  display: block;
  width: 400px;
  height: 120px;
  margin: 10px;
}

.logo {
  width: 100px;
  /* center the image */
  display: block;
  margin-left: auto;
  margin-right: auto;
}
</style>

<script>
useHead({
  title: 'YATT - You Are The Translator',
  viewport: 'width=device-width, initial-scale=1, maximum-scale=1',
  charset: 'utf-8',
  meta: [{ name: 'description', content: 'Learn a language by listening and speaking' }],
  link: [{ rel: 'icon', type: 'image/png', href: '/favicon.png' }],
})
</script>