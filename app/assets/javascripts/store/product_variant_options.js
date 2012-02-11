var show_variant_images = function(variant_id) {
  $('li.vtmb').hide();
  $('li.vtmb-' + variant_id).show();
  var currentThumb = $('#' + $("#main-image").data('selectedThumbId'));
  // if currently selected thumb does not belong to current variant, nor to common images,
  // hide it and select the first available thumb instead.
  if(!currentThumb.hasClass('vtmb-' + variant_id)) {
    //var thumb = $($('ul.thumbnails li:visible').eq(0));
    var thumb = $($("ul.thumbnails li.vtmb-" + variant_id + ":first").eq(0));
    if (thumb.length == 0) {
      thumb = $($('ul.thumbnails li:visible').eq(0));
    }
    var newImg = thumb.find('a').attr('href');
    $('ul.thumbnails li').removeClass('selected');
    thumb.addClass('selected');
    $('#main-image img').attr('src', newImg);
    $("#main-image").data('selectedThumb', newImg);
    $("#main-image").data('selectedThumbId', thumb.attr('id'));
  }
}

var show_all_variant_images = function() {
  $('li.vtmb').show();
}