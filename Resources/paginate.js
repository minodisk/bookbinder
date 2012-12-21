(function (window, document) {
  'use strict';

  Deferred
    .next(function () {
    })
    .error(function (err) {
      window.print(err.stack);
    });

})(window, document);