# URL Utils
A small set of utilities for manipulating URLs in [Atom](https://atom.io).

## Commands
Each command works on multiple selections, or each URL found in a block of selected text.

#### Tidy
Currently removes any unnecessary `www.` or trailing `/` from selected URLs, and prepends the `http://` protocol if absent. For example, `www.atom.io/` becomes `http://atom.io`.

This can be configured in the package settings to always enforce [https](https://mashable.com/2011/05/31/https-web-security).

The ability to automatically tidy up all URLs when specified files are saved can also be configured.

#### Encode/decode
[URI](https://en.wikipedia.org/wiki/Uniform_Resource_Identifier) encode/decode selected text.

#### Open
Open selected links in the default external browser.

#### Linkify
Wrap selected URLs in either [Markdown](http://commonmark.org/help/tutorial/05-links.html) or [HTML](http://w3schools.com/html/html_links.asp) link tags, depending on the current [grammar](https://atom.io/docs/latest/using-atom-grammar).

---

## Install
`apm install url-utils` or search "url" under packages within Atom.
