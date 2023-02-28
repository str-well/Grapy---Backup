function renameTags() {
  var tag = $("span#tag-el");
  for (var i = 0; i < tag.length; i++) {
    var tag_name = tag[i].innerHTML;
    tag[i].innerHTML = tag_name.replace(/^\d+\s*-*\s*/gm, " ");
    if (tag[i].innerHTML.trim() === "") {
      $(tag[i]).parent().css("display", "none");
    }
  }
}
function renameClass() {
  var classNames = $("div.icone-sustentaveis");
  for (var i = 0; i < classNames.length; i++) {
    var classNames_name = classNames[i].innerHTML;
    if (classNames_name.match(/Sustentavel/gi)) {
      classNames[i].className = "icone-sustentaveis";
    } else {
      classNames[i].className = "icone-biologicos";
    }
  }
}

$(document).ready(function () {
  renameTags();
  renameClass();
  setTimeout(renameTags, 500);
});
