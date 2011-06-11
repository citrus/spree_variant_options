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
    enable(parent.find('a.option-value'));
    toggle();
    $('.clear-option a.clear-button').hide().click(handle_clear);
  }
  
  function update(i) {
    index = isNaN(i) ? index : i;
    parent = $(divs.get(index));
    buttons = parent.find('a.option-value');
    parent.find('a.clear-button').hide();
  }
  
  function disable(btns) {
    return btns.removeClass('selected');
  }
  
  function enable(btns) {
    return btns.removeClass('locked').unbind('click').filter('.in-stock').click(handle_click);
  }
  
  function advance() {
    index++
    update();
    inventory(buttons.removeClass('locked'));
    enable(buttons.filter('.in-stock'));
  }
  
  function inventory(btns) {
    var selected = divs.find('a.selected');
    var rels, selected_rels = $.map(selected, function(i) { return i.rel });
    btns.removeClass('in-stock out-of-stock').each(function(i, element) {
      var obj;
      rels = [element.rel].concat(selected_rels);
      obj = get_variant_object(rels);
      if (obj.count < 1) {
        disable($(element).addClass('out-of-stock').unbind('click'));
      } else {
        $(element).addClass('in-stock');
      }
    });
  }
  
  function get_variant_object(rels) {
    var i, ids, obj, objects = [];
    if (typeof(ids) == 'string') { 
      rels = [rels];
    }
    i = rels.length;
    while (i--) {
      try {
        ids = rels[i].split('-');
        obj = options[ids[0]][ids[1]];
        objects.push(obj)
      } catch(error) {
        console.log(error);
      }
    }
    try {
      ids = $.map(objects, function(i) { return Object.keys(i); });
      i = (Array.find_matches(ids) || [])[0];
      obj = objects[0][i];
      obj.id = i;
    } catch(error) {
      obj = null;
      console.log(error);
    } 
    return obj;
  }
  
  function find_variant() {
    var selected = divs.find('a.selected');
    if (selected.length == divs.length) {
      return get_variant_object($.map(selected, function(i) { return i.rel }));
    };
  }
    
  function toggle() {
    if (variant) {
      console.log("VARIANT:", variant);
      $('#variant_id').val(variant.id);
      $('button[type=submit]').attr('disabled', false).fadeTo(100, 1);
    } else {
      $('#variant_id').val('');
      $('button[type=submit]').attr('disabled', true).fadeTo(0, 0.5);
    }    
  }
  
  function get_index(parent) {
    return parseInt($(parent).attr('class').replace(/[^\d]/g, ''));
  }
  
  function clear(i) {
    variant = null;
    update(i);
    enable(buttons.removeClass('selected'));
    toggle();
    parent.nextAll().each(function(index, element) {
      disable($(element).find('a.option-value').removeClass('in-stock out-of-stock').addClass('locked').unbind('click'));
      $(element).find('a.clear-button').hide();
    });
  }
  
  function handle_clear(evt) {
    evt.preventDefault();
    clear(get_index(this));
  }
  
  function handle_click(evt) {
    evt.preventDefault();
    variant = null;
    var a = $(this);
    if (!parent.has(a).length) {
      clear( divs.index(a.parents('.variant-options:first')) ); 
    }
    disable(buttons);
    var a = enable(a.addClass('selected'));
    parent.find('a.clear-button').css('display', 'block');
    advance();
    if (variant = find_variant()) {
      toggle();
    }
  }
  
  $(document).ready(init);
  
};
