export default ({ app: { router } }) => {
  let ready = false
  router.onReady(() => {
    // Mark when the router has completed the initial navigation.
    ready = true
  })

  function create() {
    router.afterEach((to, from) => {
      if (!ready) {
        // Don't record a duplicate hit for the initial navigation.
        return
      }
      var _rutarget = window._rutarget || [];
      _rutarget.push({ 'event': 'otherPage' });
    })
  }

  if (window._rtgParams) {
    create()
  }
}


