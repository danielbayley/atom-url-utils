URL Utils
=========
A small set of utilities for manipulating URLs in [Atom].

Commands
--------
Each command works on multiple selections, or each URL found in a block of selected text.

### Tidy
Currently removes any unnecessary `www.` or trailing `/` from selected URLs, and prepends the `http://` protocol if absent. For example, `http://www.atom.io` becomes `http://atom.io`.

This can be configured in the package settings to always enforce [https].

The ability to automatically tidy up all URLs when specified files are saved can also be configured.

### Encode/decode
[URI] encode/decode selected text.

### Open
Open selected links in the default external browser or a new pane if [browser-plus] is active.

### Linkify
Wrap selected URLs in either [Markdown] or [HTML] link tags, depending on the current [grammar].

---

Install
-------
`apm install url-utils` or search "url" under packages within Atom.

License
-------
[MIT] © [Daniel Bayley]

[MIT]:						LICENSE.md
[Daniel Bayley]:	https://github.com/danielbayley
[atom]:						https://atom.io
[grammar]:				http://flight-manual.atom.io/using-atom/sections/grammar
[browser-plus]:		https://atom.io/packages/browser-plus
[markdown]:				http://commonmark.org/help/tutorial/05-links.html
[HTML]:						http://w3schools.com/html/html_links.asp
[URI]:						https://en.wikipedia.org/wiki/Uniform_Resource_Identifier
[https]:					https://mashable.com/2011/05/31/https-web-security
