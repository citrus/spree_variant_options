function objectContains(obj1, obj2) {
  var matches = true;
  $.each(obj2, function(key, value) {
    if(obj1[key] != value) {
      matches = false;
    }
  });
  return matches;
}
