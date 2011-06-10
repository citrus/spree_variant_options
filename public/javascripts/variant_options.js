if (!Object.keys) Object.keys = function(o) {
  if (o !== Object(o)) throw new TypeError('Object.keys called on non-object');
  var ret=[],p;
  for(p in o) if(Object.prototype.hasOwnProperty.call(o,p)) ret.push(p);
  return ret;
}
if (!Array.find_matches) Array.find_matches = function(a) {
  var i, m = [];
  a = a.sort();
  i = a.length
  while(i--) {
    if (a[i - 1] == a[i]) {
      m.push(a[i]);
    }
  }
  if (m.length == 0) {
    return false;
  }
  return m;
}



function VariantOptions(options) {
  
  var options = options;
  var variant, inventory, div, types, values, buttons, index = -1, selected = [];
  
  function init() {
    div = $('#product-variants');
    types = div.find('.variant-option-type');
    values = div.find('.variant-option-values');
    disable(values.find('a.option-value'));
    advance();
  }
  
  function disable(btns) {
    return btns.removeClass('enabled').removeClass('selected').fadeTo(0, 0.5); //.unbind('click').click(cancel_click);
  }
  
  function enable(btns) {
    return btns.fadeTo(0, 1).addClass('enabled').unbind('click').click(handle_click);
  }
  
  function out_of_stock(element) {
    return $(element).removeClass('in-stock').addClass('out-of-stock').unbind('click').click(cancel_click) 
  }  
  
  function toggle() {
    if (variant) {
      $('#variant_id').val(variant);
      $('button[type=submit]').attr('disabled', false).fadeTo(0, 1);
    } else {
      $('#variant_id').val('');
      $('button[type=submit]').attr('disabled', true).fadeTo(0, 0.5);
    }    
  }
  
  function advance() {
    index++;
    enable(set_buttons());
    enable($('a.option-value.out-of-stock').removeClass('out-of-stock'));
    toggle();
  }
  
  function set_buttons() {
    return buttons = $(values[index]).find('a.option-value');
  }
  
  function find_variant() {
    var ids = [], i = selected.length
    while(i--) {
      ids = ids.concat(Object.keys(selected[i]));
    }
    matches = Array.find_matches(ids);
    if (matches) {
      variant = matches[0];
      inventory = selected[selected.length - 1][variant];
    } else {
      variant = false;
      inventory = 0;
    }
  }
  
  function cancel_click(evt) {
    evt.preventDefault();
  }
  
  function handle_click(evt) {
    evt.preventDefault();
    var ids = this.rel.split("-");
        
    disable(buttons.not(this).removeClass('selected'));
    var a = enable($(this).addClass('selected'));
    
    // backtrack
    var parent_index = parseInt($("#option_type_" + ids[0]).attr('class').replace('index-', ''));    
    if (parent_index < index) {
      index = parent_index;      
      selected = selected.slice(0, index);
      set_buttons();
      disable(buttons.not(this));
    }
    
    try {
      var _ids, _vids, vids = options[ids[0]][ids[1]];   
      selected[index] = vids;
      find_variant();
      //console.log('found?', variant, inventory);
      if (variant === false) {
        advance();
        var keys = Object.keys(vids);
        buttons.each(function(i, element) {
          _ids = element.rel.split("-");
          _vids = options[_ids[0]][_ids[1]]
          keys = keys.concat(Object.keys(_vids));
          matches = Array.find_matches(keys);
          if (matches) {
            var i = matches.length;
            while (i--) {
              if (_vids[matches[i]] <= 0) {
                out_of_stock(element);
              }
            };
          }
        });
      } else if (inventory == 0) {
        // shouldn't really ever get here...
        alert('out of stock!');
      } else {
        toggle();
      }
    } catch(error) {
      if (!(window.console && window.console.log)) { return }
      console.log("Type / Value " + this.rel + " combination could not be found");
      console.log(error);
    }
  }
  
  $(document).ready(init);
  
};
