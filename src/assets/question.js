/* 
 *  Copyright 2010-2011 Mark Logic Corporation
 *  
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *  
 *      http://www.apache.org/licenses/LICENSE-2.0
 *  
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *  
 *  @author Justin Makeig <jmakeig@marklogic.com>
 *
 */

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

  this.previewActionEl.bind("click", function(evt) {
    console.dir(this);
    evt.preventDefault();
    evt.stopPropagation();
    convert();
    var ed = $(this).closest(".control.editor").toggleClass("flip");
    if (ed.is(".flip"))
      $(this).html("← Edit");
    else
      $(this).html("Preview →");
  });

  this.inputEl.bind("change paste blur", function(evt) {
    convert();
  });
}
ML.Editor.prototype = {
  bind: function() {

  }
}