urllite.js
==========

urllite is a URL parser for nodejs and the browser. Its main goal is to be tiny
enough to be bundled with browser builds of JS libraries so your users don't
have to understand dependency management to use your library.

Its core API is based on the [URLUtils] interface (the properties of "a"
HTMLElements and `window.location`):

```javascript
var url = urllite('http://u:p@example.com:10/a/b/c?one=1&two=2#three');
url.origin    // "http://example.com:10"
url.protocol  // "http:"
url.username  // "u"
url.password  // "p"
url.host      // "example.com:10"
url.hostname  // "example.com"
url.port      // "10"
url.pathname  // "/a/b/c"
url.search    // "?one=1&two=2"
url.hash      // "#three"
```


## Usage


### In the browser

```html
<script src="urllite.js"></script>
<script>
    var url = urllite('http://u:p@example.com:10/a/b/c?one=1&two=2#three');
</script>
```

You can also use urllite as an AMD module.


### In node

```javascript
var urllite = require('urllite');
var url = urllite('http://u:p@example.com:10/a/b/c?one=1&two=2#three');
```


### In your own libraries

You can compile urllite into your own libraries using a tool like [browserify].


[URLUtils]: https://developer.mozilla.org/en-US/docs/Web/API/URLUtils
[browserify]: http://browserify.org
