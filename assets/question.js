$(document).ready(function() {
//$("#new-question").onsubmit(function(){
//	console.dir(this);
//	var markup=(new Showdown.converter()).makeHtml(document.getElementById('question').value); 
//	document.getElementById('markup').value=markup;

//var text = "Markdown *rocks*.";
//var converter = new Showdown.converter();
//var html = converter.makeHtml(text);

	var editor = new ML.Editor($("#question"), $("#markup"), $("#preview"));
});

var ML = {};
ML.Editor = function(inputEl, markupEl, previewEl) {
	this.inputEl = $(inputEl);
	this.markupEl = $(markupEl);
	this.previewEl = $(previewEl);
	this.previewActionEl = $(".preview-action");
	
	var editor = this;
	var converter = new Showdown.converter();
	
	function convert() {
		var html = converter.makeHtml(editor.inputEl.val());
		console.log(html);
		editor.markupEl.val(html);
		editor.previewEl.html(html);
	}
	
	this.previewActionEl.bind("click", function(evt){
		console.dir(this);
		evt.preventDefault();
		evt.stopPropagation();
		convert();
		var ed = $(this).closest(".control.editor").toggleClass("flip");
		if(ed.is(".flip")) $(this).html("Edit");
		else $(this).html("Preview");
	});
	
	this.inputEl.bind("change paste blur", function(evt){
		convert();
	});
}
ML.Editor.prototype = {
	bind: function() {
		
	}
}