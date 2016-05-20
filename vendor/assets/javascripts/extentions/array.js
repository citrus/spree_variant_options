$.extend(true, Array.prototype, {
  compare: function ( array ) {
    var sortedThis = this.sort();
    array = array.sort();

    // if the other array is a falsy value, return
    if ( !array )
      return false;

    // compare lengths - can save a lot of time
    if ( sortedThis.length != array.length )
      return false;

    for ( var i = 0, l = sortedThis.length; i < l; i++ ) {
      // Check if we have nested arrays
      if ( sortedThis[i] instanceof Array && array[i] instanceof Array ) {
        // recurse into the nested arrays
        if ( !sortedThis[i].compare( array[i] ) )
          return false;
      }
      else if ( sortedThis[i] != array[i] ) {
        // Warning - two different object instances will never be equal: {x:20} != {x:20}
        return false;
      }
    }
    return true;
  }
});

