module.exports =

	line: /[^\s]+/
	URL: ///
		#([\ \t]|^)								# Preceded by white space or nothing
		(?:http(s)?://|www\.)+		# Protocol / www. subdomain
		(													# Capture group $2
			([a-z]{2,7}\.)?					# Subdomain
			[a-z\d-]+								# Domain
			(\.[a-z]{2,4})+					# TLD
			[./_\w@:%+,~#?&;=-]*		# Content
		\b)/?											# Trailing slash
		///g

	subs: null
	activate: ->
		{CompositeDisposable} = require 'atom'
		@subs = new CompositeDisposable
#-------------------------------------------------------------------------------

		@subs.add atom.commands.add 'atom-text-editor',
			'url-utils:tidy': =>
				@filter @get(), (URLs) => URLs.replace @tidy @matchText
			'url-utils:uri-encode': => @encoding encodeURI
			'url-utils:decode-uri': => @encoding decodeURI
			'url-utils:open': => @filter @get(), => @open @matchText
			'url-utils:linkify': =>
				@filter @get(), (URLs) => URLs.replace @linkify @matchText
			# TODO 'url-utils:shorten': => @shorten()

		@subs.add atom.workspace.observeTextEditors (editor) =>
			editor.buffer.onWillSave =>
				autoTidy = atom.config.get 'url-utils.autoTidy'

				unless autoTidy is 'None' #indexOf
					{scopeName,name} = editor.getGrammar() #scopeName.split('.')[1]
					grammars = atom.config.get 'url-utils.grammars'

					unless autoTidy is 'Any'
						return unless grammars.some (grammar) ->
							~name.indexOf(grammar) or ~scopeName.indexOf grammar

					try @filter [editor.buffer.getRange()], (URLs) =>
						URLs.replace @tidy @matchText
#-------------------------------------------------------------------------------

	editor: -> atom.workspace.getActiveTextEditor()
	#grammar: -> @editor().getGrammar()
	get: ->
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
			else selected = [@selection.getBufferRange()]
		return selected

	filter: (selected, process) -> #URL/s
		for selection in selected #text
			@editor().backwardsScanInBufferRange @URL, selection, (URL) => #.buffer.scanInRange
				{@matchText} = URL
				process URL
#-------------------------------------------------------------------------------

	tidy: (URL) ->
		s = if atom.config.get 'url-utils.https' then 's' else '$1'
		URL.replace @URL,"http#{s}://$2"

	linkify: (URL) ->
		URL = @tidy URL if atom.config.get 'url-utils.linkifyTidy'
		{scopeName} = @editor().getGrammar()

		title = require('title-from-url') URL #.match( /\/+(.+)\..*/ )[1]
		if /html/.test scopeName then "<a href=\"#{URL}\">#{title}</a>"
		else "[#{title}](#{URL})" #scopeName.endsWith 'gfm'

	encoding: (format) ->
		@get(); @selection.insertText format(@selection.getText()), select: true

	open: (URL) ->
		#unless atom.config.get 'url-utils.browser' is 'external' #default
		# TODO if atom.packages.isPackageActive 'browser-plus'
		{openExternal} = require 'shell'
		try openExternal URL

#-------------------------------------------------------------------------------
	deactivate: -> @subs.dispose()
