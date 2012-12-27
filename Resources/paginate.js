(function (window, document) {
  'use strict';

  var DOM_CONTENT_LOADED = 'DOMContentLoaded'

    , userAgent = window.navigator.userAgent
    , isMobile = /(iPhone|iPod|iPad)/.test(userAgent)
    , webkitVersion = parseFloat(userAgent.match(/AppleWebKit\/([0-9\.]+)/)[1] || -1)
    , exceptRuby = isMobile && webkitVersion < 536

    , stageWidth, stageHeight
    , bottomNodes

    , appendBoundingBox = function (rect, color) {
      var div = document.createElement('div')
        ;
      div.style.position = 'absolute';
      div.style.boxSizing = 'border-box';
      div.style.left = rect.left - document.documentElement.scrollWidth + stageWidth + 'px';
      div.style.top = rect.top + 'px';
      div.style.width = rect.width + 'px';
      div.style.height = rect.height + 'px';
      div.style.border = '1px solid ' + colorToString(color);
      document.body.appendChild(div);
    }
    ;

  document.addEventListener(DOM_CONTENT_LOADED, ready, false);

  function ready() {
    document.removeEventListener(DOM_CONTENT_LOADED, ready, false);

    bottomNodes = findBottomNodes(document.body);
    print(bottomNodes.length);

    window.addEventListener('resize', resize, false);
    window.addEventListener('orientationchange', resize, false);
    resize();
  }

  /**
   * 最下層のノードを取得する
   * @param context {HTMLElement} 走査を開始する上層ノード
   * @return {Array} 最下層のノードのリスト
   */
  function findBottomNodes(context) {
    var storage = []
      ;

    function scan(node) {
      // ルビは有効なバウンディングボックスの対象としない
      if (node.nodeName === 'RT') {
        return;
      }
      if (exceptRuby && node.parentNode.nodeName === 'RUBY') {
        return;
      }
      if (!node.hasChildNodes()) {
        // テキストノードの場合、句読点で分割する
        if (node instanceof Text) {
          var parent = node.parentNode
            , i, len, text, textNode
            ;
          var tmp = node.data.split(/((?:[a-zA-Z0-9]+)|(?:.*?[、。]))/);
          node.data = '';
          for (i = 0, len = tmp.length; i < len; i++) {
            text = tmp[i];

            // 空白文字は削除
            if (text === '') {
              continue;
            }

            textNode = document.createTextNode(text);
            parent.insertBefore(textNode, node);

            // 改行文字のみから成るテキストノードはbody直下の改行文字を含むことになり、
            // バウンディングボックスの算出に都合が悪い為最下層ノードとしない
            if (!/\s+/.test(text)) {
              storage.push(textNode);
            }
          }
        }
        /* else {
         storage.push(node);
         }*/
      } else {
        var children = Array.prototype.slice.call(node.childNodes)
          , i, len, child
          ;
        for (i = 0, len = children.length; i < len; i++) {
          child = children[i];
          scan(child);
        }
      }
    }

    scan(context);

    return storage;
  }

  function resize() {
    stageWidth = window.innerWidth;
    stageHeight = window.innerHeight;

    detectEdge();
  }

  function detectEdge() {
    var i, len, node
      , range = document.createRange()
      , rect
      , lineLefts = []
      ;

    for (i = 0, len = bottomNodes.length; i < len; i++) {
      node = bottomNodes[i];
      range.setStartBefore(node);
      range.setEndAfter(node);
      rect = range.getBoundingClientRect();
//      appendBoundingBox(rect, 0x7fff0000)
      if (lineLefts.indexOf(rect.left) === -1) {
        lineLefts.push(rect.left);
//        appendBoundingBox({
//          left  : rect.left,
//          top   : 0,
//          width : 0,
//          height: 100
//        }, 0x7f0000ff);
      }
    }
    lineLefts.sort();
    print(lineLefts);
  }

  function colorToString(color) {
    return 'rgba(' + [
      color >> 16 & 0xff,
      color >> 8 & 0xff,
      color & 0xff,
      (color >> 24 & 0xff) / 0xff
    ].join(',') + ')';
  }

})(window, document);