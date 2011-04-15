(function ($) {
  
  MMCMS.pageApp = $.sammy(function () {
    element_selector = '#pages'

    this.get('#/', function () {
      // nope
    });
    
    this.get('#/:path', function () {
      this.load('?path='+this.params['path'])
        .then(function (result) {
            $('#main').html(result);
            return;
        })
        /*.then(function(item) {
          this.log(item); //=> {title: ...}
          return item.title;
        })
        .then(function(title) {
          this.log(title); //=> "The Door"
        });*/
    });

    this.bind('navigateTo', function (e, data) {
      var path = data['path']
      if (path) {
        this.redirect(path); 
      }
    });

  });
  
  
  $(function () {  
    MMCMS.pageApp.run('#/');
    
    $('#pages a.page').live('click', function (e) {
      e.preventDefault();
      //var has_children = $(this).attr('data-children');
      var path = $(this).attr('data-path');
      if (path) {
        MMCMS.pageApp.trigger('navigateTo', {path: '#/' + path}); 
      }
    });
  });
  
})(jQuery)