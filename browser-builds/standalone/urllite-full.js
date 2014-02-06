!function(e){if("object"==typeof exports)module.exports=e();else if("function"==typeof define&&define.amd)define(e);else{var f;"undefined"!=typeof window?f=window:"undefined"!=typeof global?f=global:"undefined"!=typeof self&&(f=self),f.urllite=e()}}(function(){var define,module,exports;return (function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(_dereq_,module,exports){
(function() {
  var urllite;

  urllite = _dereq_('./core');

  module.exports = urllite;

}).call(this);

},{"./core":2}],2:[function(_dereq_,module,exports){
(function() {
  var URL, URL_PATTERN, urllite;

  URL_PATTERN = /^(?:(?:([^:\/?\#]+:)\/+|(\/\/))(?:([a-z0-9-\._~%]+)(?::([a-z0-9-\._~%]+))?@)?(([a-z0-9-\._~%!$&'()*+,;=]+)(?::([0-9]+))?)?)?([^?\#]*?)(\?[^\#]*)?(\#.*)?$/;

  urllite = function(raw) {
    return new urllite.URL(raw);
  };

  urllite.URL = URL = (function() {
    function URL(raw) {
      var m, pathname;
      m = raw.toString().match(URL_PATTERN);
      this.protocol = m[1] || '';
      this.isSchemeRelative = m[2] != null;
      this.username = m[3] || '';
      this.password = m[4] || '';
      this.host = m[5] || '';
      this.hostname = m[6] || '';
      this.port = m[7] || '';
      pathname = m[8] || '';
      this.pathname = this.protocol && pathname.charAt(0) !== '/' ? "/" + pathname : pathname;
      this.search = m[9] || '';
      this.hash = m[10] || '';
      this.origin = this.protocol ? "" + this.protocol + "//" + this.host : '';
    }

    URL.prototype.toString = function() {
      var authority, prefix, userinfo;
      prefix = this.isSchemeRelative ? '//' : this.protocol === 'file:' ? "" + this.protocol + "///" : this.protocol ? "" + this.protocol + "//" : '';
      userinfo = this.password ? "" + this.username + ":" + this.password : this.username ? "" + this.username : '';
      authority = userinfo ? "" + userinfo + "@" + this.host : this.host ? "" + this.host : '';
      return "" + prefix + authority + this.pathname + this.search + this.hash;
    };

    return URL;

  })();

  module.exports = urllite;

}).call(this);

},{}]},{},[1])
(1)
});