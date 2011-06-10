if (!Object.keys) Object.keys = function(o) {
  if (o !== Object(o)) throw new TypeError('Object.keys called on non-object');
  var ret=[],p;
  for(p in o) if(Object.prototype.hasOwnProperty.call(o,p)) ret.push(p);
  return ret;
}

function VariantOptions(options) {
  
  var options = options;
  var variant, div, types, values, buttons, index = -1, selected = [];
  
  function init() {
    div = $('#product-variants');
    types = div.find('.variant-option-type');
    values = div.find('.variant-option-values');
    disable(values.find('a.option-value'));
    advance();
  }
  
  function disable(btns) {
    return btns.removeClass('selected').fadeTo(0, 0.3).click(cancel_click);
  }
  
  function enable(btns) {
    return btns.fadeTo(0, 1).unbind('click').click(handle_click);
  }
  
  function advance() {
    index++;
    enable(set_buttons());
  }
  
  function out_of_stock() {
    alert('out of stock!');
  }  
  
  function select() {
    console.log('choose variant');
  }
  
  
  
  function set_buttons() {
    return buttons = $(values[index]).find('a.option-value');
  }
  
  function find_variant() {
    console.log('find_variant');
    console.log(options);
    
    var res = [], ids = [], i = selected.length
    while(i--) {
      ids = ids.concat(Object.keys(selected[i]));
    }
    ids = ids.sort();
    i = ids.length
    while(i--) {
      if (ids[i - 1] == ids[i]) {
        res.push(ids[i]);
      }
    }
    if (res.length != 1) {
      return false;
    }
    variant = res[0];
    return selected[0][variant];
  }
  
  function cancel_click(evt) {
    evt.preventDefault();
  }
  
  function handle_click(evt) {
    evt.preventDefault();
    var ids = this.rel.split("-");
    
    disable(buttons.not(this).removeClass('selected'));
    var a = enable($(this).addClass('selected'));
    
    var parent_index = parseInt($("#option_type_" + ids[0]).attr('class').replace('index-', ''));    
    if (parent_index < index) {
      index = parent_index;      
      selected = selected.slice(0, index);
      set_buttons();
      disable(buttons.not(this));
    }
    
    try {
      var inv, vids = options[ids[0]][ids[1]];   
      selected[index] = vids;
      inv = find_variant();
      console.log(variant, inv);
      if (inv === false) {
        advance();      
      } else if (inv == 0) {
        out_of_stock();
      } else {
        select();
      }
    } catch(error) {
      console.log("Type / Value " + this.rel + " combination could not be found");
    }
  }
  
  $(document).ready(init);
  
};
