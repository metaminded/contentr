(function($) {

  var settings = {
    width: '90%',
    height: '90%',
    close: function() {}
  };

  var _showOverlay = function(url) {
    // build the overlay elements
    $('#contentr-overlay').remove();
    var overlay     = $('<div id="contentr-overlay"></div>').appendTo('body');
    var mask        = $('<div id="contentr-overlay-mask"></div>').appendTo(overlay);
    var wrapper     = $('<div id="contentr-overlay-wrapper"></div>').appendTo(overlay);
    var iframe      = $('<iframe id="contentr-overlay-iframe"></iframe>').appendTo(wrapper);
    var closeButton = $('<div id="contentr-overlay-close"></div>').appendTo(wrapper);

    // configure the iframe
    iframe.attr('src', url);
    iframe.attr('name', 'contentr-overlay-' + new Date().getTime());
    iframe.attr('frameborder', '0');
    iframe.attr('hspace', '0');
    iframe.attr('scrolling', 'auto');

    // fit overlay wrapper
    _fitOverlayWrapper(mask, wrapper);
    $(window).unbind('resize');
    $(window).bind('resize', function(e) {
      _fitOverlayWrapper(mask, wrapper);
    });

    // listen for click events on the close button
    closeButton.bind('click', function(e) {
      _closeOverlay();
    });
  };

  var _closeOverlay = function() {
    $(window).unbind('resize');
    $('#contentr-overlay').remove();
    settings.close();
  };

  var _fitOverlayWrapper = function(mask, wrapper) {
    wrapper.css('width', settings.width);
    wrapper.css('height', settings.height);
    wrapper.css('left', (mask.width() / 2) - (wrapper.width() / 2));
    wrapper.css('top', (mask.height() / 2) - (wrapper.height() / 2));
  };


  var publicMethods = {
    init: function(options) {
      // setup settings
      if (options) {
        $.extend(settings, options);
      }

      // listen for click events on matched elements
      this.click(function(e) {
        e.preventDefault();
        _showOverlay(this.href);
      });

      // be nice
      return this;
    },

    close: function(options) {
      _closeOverlay();
    }
  };


  $.fn.contentr_overlay = function(method) {
    if (publicMethods[method]) {
      return publicMethods[method].apply(this, Array.prototype.slice.call(arguments, 1));
    } else if (typeof method === 'object' || ! method) {
      return publicMethods.init.apply(this, arguments);
    } else {
      $.error('Method ' +  method + ' does not exist on jQuery.contentr_overlay');
    }
  };

})(jQuery);
