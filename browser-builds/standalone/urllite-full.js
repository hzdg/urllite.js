!function(e){if("object"==typeof exports)module.exports=e();else if("function"==typeof define&&define.amd)define(e);else{var f;"undefined"!=typeof window?f=window:"undefined"!=typeof global?f=global:"undefined"!=typeof self&&(f=self),f.urllite=e()}}(function(){var define,module,exports;return (function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(_dereq_,module,exports){
(function() {
  var urllite;

  urllite = _dereq_('./core');

  _dereq_('./extensions/resolve');

  _dereq_('./extensions/relativize');

  _dereq_('./extensions/normalize');

  module.exports = urllite;

}).call(this);

},{"./core":2,"./extensions/normalize":3,"./extensions/relativize":4,"./extensions/resolve":5}],2:[function(_dereq_,module,exports){
(function() {
  var URL, URL_PATTERN, defaults, urllite,
    __slice = [].slice,
    __hasProp = {}.hasOwnProperty;

  URL_PATTERN = /^(?:(?:([^:\/?\#]+:)\/+|(\/\/))(?:([a-z0-9-\._~%]+)(?::([a-z0-9-\._~%]+))?@)?(([a-z0-9-\._~%!$&'()*+,;=]+)(?::([0-9]+))?)?)?([^?\#]*?)(\?[^\#]*)?(\#.*)?$/;

  urllite = function(raw, opts) {
    return urllite.URL.parse(raw, opts);
  };

  defaults = {
    protocol: '',
    username: '',
    password: '',
    host: '',
    hostname: '',
    port: '',
    pathname: '',
    search: '',
    hash: '',
    origin: '',
    isSchemeRelative: false,
    isAbsolutePathRelative: false,
    isPathRelative: false,
    isRelative: false,
    isAbsolute: false
  };

  urllite._createURL = function() {
    var base, bases, k, props, v, _i, _len, _ref, _ref1;
    bases = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    props = {};
    for (_i = 0, _len = bases.length; _i < _len; _i++) {
      base = bases[_i];
      for (k in defaults) {
        if (!__hasProp.call(defaults, k)) continue;
        v = defaults[k];
        props[k] = (_ref = (_ref1 = base[k]) != null ? _ref1 : props[k]) != null ? _ref : v;
      }
    }
    props.host = props.hostname && props.port ? "" + props.hostname + ":" + props.port : props.hostname ? props.hostname : '';
    props.origin = props.protocol ? "" + props.protocol + "//" + props.host : '';
    props.isAbsolutePathRelative = !props.host && props.pathname.charAt(0) === '/';
    props.isPathRelative = !props.host && props.pathname.charAt(0) !== '/';
    props.isRelative = props.isSchemeRelative || props.isAbsolutePathRelative || props.isPathRelative;
    props.isAbsolute = !props.isRelative;
    return new urllite.URL(props);
  };

  urllite.URL = URL = (function() {
    function URL(props) {
      var k, v;
      for (k in props) {
        if (!__hasProp.call(props, k)) continue;
        v = props[k];
        this[k] = v;
      }
    }

    URL.parse = function(raw) {
      var m, pathname, protocol;
      m = raw.toString().match(URL_PATTERN);
      pathname = m[8] || '';
      protocol = m[1];
      return urllite._createURL({
        protocol: protocol,
        username: m[3],
        password: m[4],
        hostname: m[6],
        port: m[7],
        pathname: protocol && pathname.charAt(0) !== '/' ? "/" + pathname : pathname,
        search: m[9],
        hash: m[10],
        isSchemeRelative: m[2] != null
      });
    };

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

},{}],3:[function(_dereq_,module,exports){
(function() {
  var URL, urllite;

  urllite = _dereq_('../core');

  URL = urllite.URL;

  URL.prototype.normalize = function() {
    var m, pathname;
    pathname = this.pathname;
    while (m = /^(.*?)[^\/]+\/\.\.\/*(.*)$/.exec(pathname)) {
      pathname = "" + m[1] + m[2];
    }
    if (this.host && pathname.indexOf('..') !== -1) {
      throw new Error('Path is behind root.');
    }
    return urllite._createURL(this, {
      pathname: pathname
    });
  };

}).call(this);

},{"../core":2}],4:[function(_dereq_,module,exports){
(function() {
  var URL, urllite;

  urllite = _dereq_('../core');

  _dereq_('./resolve');

  URL = urllite.URL;

  URL.prototype.relativize = function(other) {
    var c, i, newSegments, otherSegments, url, urlSegments, _i, _len, _ref;
    if (this.isPathRelative) {
      return new urllite.URL(this);
    }
    if (typeof other === 'string') {
      other = urllite(other);
    }
    url = this.resolve(other);
    if (url.origin && url.origin !== other.origin) {
      throw new Error("Origins don't match (" + url.origin + " and " + other.origin + ")");
    } else if (!other.isAbsolute && !other.isAbsolutePathRelative) {
      throw new Error("Other URL (<" + other + ">) is neither absolute nor absolute path relative.");
    }
    otherSegments = other.pathname.split('/').slice(1);
    urlSegments = url.pathname.split('/').slice(1);
    for (i = _i = 0, _len = urlSegments.length; _i < _len; i = ++_i) {
      c = urlSegments[i];
      if (!(c === otherSegments[i] && (urlSegments.length > (_ref = i + 1) && _ref < otherSegments.length))) {
        break;
      }
    }
    newSegments = urlSegments.slice(i);
    while (i < otherSegments.length - 1) {
      if (otherSegments[i]) {
        newSegments.unshift('..');
      }
      i++;
    }
    if (newSegments.length === 1) {
      newSegments = newSegments[0] === otherSegments[i] ? [''] : newSegments[0] === '' ? ['.'] : newSegments;
    }
    return urllite._createURL({
      pathname: newSegments.join('/'),
      search: url.search,
      hash: url.hash
    });
  };

}).call(this);

},{"../core":2,"./resolve":5}],5:[function(_dereq_,module,exports){
(function() {
  var URL, copyProps, oldParse, urllite,
    __slice = [].slice;

  urllite = _dereq_('../core');

  URL = urllite.URL;

  oldParse = URL.parse;

  copyProps = function() {
    var prop, props, source, target, _i, _len;
    target = arguments[0], source = arguments[1], props = 3 <= arguments.length ? __slice.call(arguments, 2) : [];
    for (_i = 0, _len = props.length; _i < _len; _i++) {
      prop = props[_i];
      target[prop] = source[prop];
    }
    return target;
  };

  URL.parse = function(raw, opts) {
    var base, url;
    if (base = opts != null ? opts.base : void 0) {
      delete opts.base;
    }
    url = oldParse(raw, opts);
    if (base) {
      return url.resolve(base);
    } else {
      return url;
    }
  };

  URL.prototype.resolve = function(base) {
    var p;
    if (this.isAbsolute) {
      return new urllite.URL(this);
    }
    if (typeof base === 'string') {
      base = urllite(base);
    }
    p = {};
    if (this.isSchemeRelative) {
      copyProps(p, this, 'username', 'password', 'host', 'hostname', 'port', 'pathname', 'search', 'hash');
      p.isSchemeRelative = !(p.protocol = base.protocol);
    } else if (this.isAbsolutePathRelative || this.isPathRelative) {
      copyProps(p, this, 'search', 'hash');
      copyProps(p, base, 'protocol', 'username', 'password', 'host', 'hostname', 'port');
      p.pathname = this.isPathRelative ? base.pathname.slice(0, -1) === '/' ? "" + base.pathname + "/" + this.pathname : "" + (base.pathname.split('/').slice(0, -1).join('/')) + "/" + this.pathname : this.pathname;
    }
    return urllite._createURL(p).normalize();
  };

}).call(this);

},{"../core":2}]},{},[1])
(1)
});