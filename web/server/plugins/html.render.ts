export default defineNitroPlugin((nitroApp) => {
    nitroApp.hooks.hook('render:html', (html) => {
        html.head.push(`<!-- Google tag (gtag.js) -->
      <script async src="https://www.googletagmanager.com/gtag/js?id=G-BQEDMEYJFB"></script>
      <script>
        window.dataLayer = window.dataLayer || [];
        function gtag(){dataLayer.push(arguments);}
        gtag('js', new Date());
    
        gtag('config', 'G-BQEDMEYJFB');
      </script>`)
    })
})
