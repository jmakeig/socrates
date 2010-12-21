var text = "Markdown *rocks*.";
var converter = new Showdown.converter();
var html = converter.makeHtml(text);