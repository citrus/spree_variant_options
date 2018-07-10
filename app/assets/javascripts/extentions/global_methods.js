function objectContains(obj1, obj2) {
  var matches = true;
  if(Object.keys(obj1).length != Object.keys(obj2).length) {
    return false;
  }
  $.each(obj2, function(key, value) {
    if(obj1[key] != value) {
      matches = false;
    }
  });
  return matches;
}
