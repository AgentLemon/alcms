/**
 * @license Copyright (c) 2003-2015, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/license
 */

CKEDITOR.editorConfig = function( config ) {
	// Define changes to default configuration here.
	// For complete reference see:
	// http://docs.ckeditor.com/#!/api/CKEDITOR.config
	config.extraPlugins = 'font';

	// The toolbar groups arrangement, optimized for two toolbar rows.
	config.toolbarGroups = [
		{ name: 'clipboard',   groups: [ 'clipboard', 'undo' ] },
		{ name: 'editing',     groups: [ 'find', 'selection', 'spellchecker' ] },
		{ name: 'links' },
		{ name: 'insert' },
		{ name: 'forms' },
		{ name: 'tools' },
		{ name: 'paragraph',   groups: [ 'list', 'indent', 'blocks', 'align', 'bidi' ] },
		{ name: 'about' },
		{ name: 'others' },
		'/',
		{ name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ] },
		{ name: 'styles' },
		{ name: 'colors' },
		{ name: 'document',	   groups: [ 'mode', 'document', 'doctools' ] }
	];

	// Remove some buttons provided by the standard plugins, which are
	// not needed in the Standard(s) toolbar.
	config.removeButtons = 'Underline,Subscript,Superscript';

	// Set the most common block elements.
	config.format_tags = 'p;h1;h2;h3;pre';

	// Simplify the dialog windows.
	config.removeDialogTabs = 'image:advanced;link:advanced';

	config.allowedContent = true;

	config.fontSize_sizes = "30%/0.3em;40%/0.4em;50%/0.5em;60%/0.6em;70%/0.7em;80%/0.8em;90%/0.9em;100%/1em;110%/1.1em;120%/1.2em;130%/1.3em;140%/1.4em;150%/1.5em;160%/1.6em;170%/1.7em;180%/1.8em;190%/1.9em;200%/2.0em;250%/2.5em;300%/3.0em;";
	config.font_style = {
		element: 'p',
		styles: { 'font-family': '#(family)' },
		overrides: [ {
			element: 'font', attributes: { 'face': null }
		} ]
	};
	config.fontSize_style = {
		element: 'p',
		styles: { 'font-size': '#(size)' },
		overrides: [ {
			element: 'font', attributes: { 'size': null }
		} ]
	};
};
