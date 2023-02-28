function poweredByM23Logo() {
  var poweredByDiv = $(".powered-by-logo");
  var linkNuvem = poweredByDiv.find("a");

  linkNuvem.find("svg").remove();
  var nuvemImage = $(
    '<a target="_blank" title="NuvemShop" rel="nofollow" href="https://www.nuvemshop.com.br/partners/felipe-carvalho"><img src="https://i.ibb.co/D497fDn/nuvemshop.png" /></a>'
  );
  linkNuvem.append(nuvemImage);

  var linkM23 = $(
    '<a target="_blank" title="M23" rel="nofollow" href="https://m23.studio"><img src="https://i.ibb.co/yqFgYJM/m23.png" /></a>'
  );
  poweredByDiv.append(linkM23);
}

$(document).ready(function () {
  poweredByM23Logo();
});
