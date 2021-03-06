{CompositeDisposable} = require 'atom'

module.exports =
	package: require './package.json'
	config: -> atom.config.get @package.name

	#browsers: ['atom-webbrowser'] #browser-plus

	line: /[^\s]+/
	URL: ///
		#([\ \t]|^)								# Preceded by white space or nothing.
		(?:http(s)?://|www\.)+		# Protocol / www. subdomain
		(													# Capture group $2
			([a-z]{2,7}\.)?					# Subdomain
			[a-z\d-]+								# Domain
			(\.[a-z]{2,4})+					# TLD
			[./_\w@:%+,~#?&;=-]*		# Content
		\b)/?											# Trailing /
		///g

	subs: new CompositeDisposable
#-------------------------------------------------------------------------------
	activate: ->

		# Modify `browser` setting options. TODO
		#for browser in @browsers
			#if atom.packages.isPackageActive browser
				#config[?] =

		@subs.add atom.commands.add 'atom-text-editor',
			'url-utils:tidy': =>
				@filter @get(), ({matchText, replace}) => replace @tidy matchText

			'url-utils:uri-encode': => @encoding encodeURI
			'url-utils:decode-uri': => @encoding decodeURI

			'url-utils:open': =>
				@filter @get(), ({matchText}) => @open @tidy matchText

			'url-utils:linkify': =>
				@filter @get(), ({matchText, replace}) => replace @linkify matchText

			# TODO 'url-utils:shorten': => @shorten()

		@subs.add atom.workspace.observeTextEditors (editor) =>
			editor.buffer.onWillSave =>
				{autoTidy, grammars} = @config()

				unless autoTidy is 'None' #indexOf
					{scopeName, name} = editor.getGrammar() #scopeName.split('.')[1]

					unless autoTidy is 'Any'
						return unless grammars.some (grammar) ->
							~name.indexOf(grammar) or ~scopeName.indexOf grammar

					try @filter [ editor.buffer.getRange() ],
						({matchText, replace}) => replace @tidy matchText

#-------------------------------------------------------------------------------

	editor: -> atom.workspace.getActiveTextEditor()
	#grammar: -> @editor().getGrammar()

	get: -> # URL/s
		selected = []
		for @selection in @editor().getSelections()
			if @selection.isEmpty()
				{cursor} = @selection
				expand = [
					cursor.getBeginningOfCurrentWordBufferPosition wordRegex: @line,
						allowPrevious: false #/[^\s(]+/
					cursor.getEndOfCurrentWordBufferPosition wordRegex: @line,
						allowNext: false #/[^\s)]+/
				]
				@selection.setBufferRange expand # selection
				selected.push expand
			else selected = [ @selection.getBufferRange() ]
		return selected

	filter: (selected, process) -> # URL/s
		for selection in selected # text
			@editor().backwardsScanInBufferRange @URL, selection, (URL) ->
				process URL #.buffer.scanInRange

#-------------------------------------------------------------------------------

	tidy: (URL) ->
		s = if @config().https then 's' else '$1'
		URL.replace @URL,"http#{s}://$2"

	linkify: (URL) ->
		URL = @tidy URL if @config().linkifyTidy
		{scopeName} = @editor().getGrammar()

		title = require('title-from-url') URL #.match( /\/+(.+)\..*/ )[1]
		if /html/.test scopeName then "<a href=\"#{URL}\">#{title}</a>"
		else "[#{title}](#{URL})" #scopeName.endsWith 'gfm'

	encoding: (format) ->
		@get() # URL
		format = format @selection.getText()
		@selection.insertText format, select: true

	open: (URL) ->
		{browser} = @config()
		if browser is 'External'
			#atom.commands.dispatch atom.views.getView(atom.workspace),'link:open'
			{openExternal} = require 'shell'
			try openExternal URL
		#else if browser is 'atom-webbrowser' and
		else if atom.packages.isPackageActive browser
			atom.workspace.open URL

#-------------------------------------------------------------------------------
	deactivate: -> @subs.dispose()
