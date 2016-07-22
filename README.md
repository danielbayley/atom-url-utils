[![badge][apm]][package]
[![badge][chat]][#slack]

[Atom] URL Utils
================
A small set of utilities for manipulating [URL]s in [Atom].

Commands
--------
Each command works on multiple selections, or each URL found in a block of selected text.

### Tidy
Currently removes any unnecessary `www.` or trailing `/` from selected URLs, and prepends the `http://` protocol if absent. For example, `www.atom.io` becomes `http://atom.io`.

This can be configured in the package settings to always enforce [https].

The ability to automatically tidy up all URLs when specified files are saved can also be configured.

### Encode/decode
[URI] encode/decode selected text.

### Open
Open selected links in your default browser, or _[atom-webbrowser]_ tabs if installed and configured in package settings.

### _Linkify_
Wrap selected URLs in either [Markdown] or [HTML] link tags, depending on the current file _[grammar]_.

---

Install
-------
`apm install url-utils` or search “url” under Packages within Atom.

License
-------
[MIT] © [Daniel Bayley]

[MIT]:              LICENSE.md
[Daniel Bayley]:    https://github.com/danielbayley
[atom]:             https://atom.io
[apm]:              https://img.shields.io/apm/v/url-utils.svg?style=flat-square
[package]:          https://atom.io/packages/url-utils
[chat]:             https://img.shields.io/badge/chat-atom.io%20slack-ff69b4.svg?style=flat-square
[#slack]:           https://atom-slack.herokuapp.com

[grammar]:          http://flight-manual.atom.io/using-atom/sections/grammar
[markdown]:         http://commonmark.org/help/tutorial/05-links.html
[HTML]:             http://w3schools.com/html/html_links.asp
[URL]:              https://en.wikipedia.org/wiki/Uniform_Resource_Locator
[URI]:              https://en.wikipedia.org/wiki/Uniform_Resource_Identifier
[https]:            http://mashable.com/2011/05/31/https-web-security

[atom-webbrowser]:  https://atom.io/packages/atom-webbrowser
[browser-plus]:     https://atom.io/packages/browser-plus
