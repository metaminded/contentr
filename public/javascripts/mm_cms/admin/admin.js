(function($) {
  
  $(function() {
    // init main navigation
    $('ul.sf-menu').superfish({
      delay: 500,
      animation: {height: 'show'},
      speed: 100,
      dropShadows: false // we use css3 shadows
    });
  });
  
})(jQuery)