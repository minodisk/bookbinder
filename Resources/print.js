(function (window, document) {
  'use strict';

  var PROTOCOL = 'print:'
    , output = function () {
      var message = Array.prototype.join.call(arguments, ', ')
        , iframe = document.createElement('iframe')
        ;

      iframe.setAttribute('src', PROTOCOL + message);
      document.documentElement.appendChild(iframe);
      iframe.parentNode.removeChild(iframe);
      iframe = null;
    }
    ;

  window.print = function () {
    console.log.apply(console, arguments);
    output.apply(window, arguments);
  };

})(window, document);