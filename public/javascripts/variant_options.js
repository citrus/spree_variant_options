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
  var variant, divs, parent, index = 0;
  
  function init() {
    divs = $('#product-variants .variant-options'); 
    disable(divs.find('a.option-value').addClass('locked'));
    update();
    enable(parent.find('a.option-value').removeClass('selected'));
    $('.clear-option a.clear-button').hide().click(handle_clear);
  }
  
  function update(i) {
    index = isNaN(i) ? index : i;
    parent = $(divs.get(index));
    buttons = parent.find('a.option-value');
    parent.find('a.clear-button').hide();
  }
  
  function disable(btns) {
    return btns.removeClass('enabled').removeClass('selected').fadeTo(0, 0.5);
  }
  
  function enable(btns) {
    return btns.fadeTo(0, 1).removeClass('locked').addClass('enabled').unbind('click').click(handle_click);
  }
  
  function advance() {
    index++
    update();
    enable(buttons);
  }
  
  function find_variant() {
    var selected = divs.find('a.selected');
    if (selected.length != divs.length) { return };
    var _var, ids, matches, variants, variant_ids = [];
    selected.each(function(i, element) {
      try {
        ids = element.rel.split('-')
        _var = options[ids[0]][ids[1]];
        variants = _var;
        variant_ids = variant_ids.concat(Object.keys(_var));
      } catch(error) {
        alert(error);
      }
    });
    matches = Array.find_matches(variant_ids);
    if (matches.length == 1) { 
      variant = variants[matches[0]];
      console.log(variant);
      if (variant.count == 0) alert('out of stock');
    }
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
  
  function get_index(parent) {
    return parseInt($(parent).attr('class').replace(/[^\d]/g, ''));
  }
  
  function clear(i) {
    update(i);
    enable(buttons.removeClass('selected'));
    parent.nextAll().each(function(index, element) {
      disable($(element).find('a.option-value').addClass('locked').unbind('click'));
      $(element).find('a.clear-button').hide();
    });
  }
  
  function handle_clear(evt) {
    evt.preventDefault();
    clear(get_index(this));
  }
  
  function handle_click(evt) {
    evt.preventDefault();
    var a = $(this);
    if (!parent.has(a).length) {
      clear( divs.index(a.parents('.variant-options:first')) ); 
    }
    disable(buttons);
    var a = enable(a.addClass('selected'));
    parent.find('a.clear-button').css('display', 'block');
    advance();
    if (find_variant()) {
      console.log('VARIANT!');
      
    };
  }
  
  $(document).ready(init);
  
};
