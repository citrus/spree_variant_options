if (!Object.keys) Object.keys = function(o) {
  if (o !== Object(o)) throw new TypeError('Object.keys called on non-object');
  var ret=[],p;
  for(p in o) if(Object.prototype.hasOwnProperty.call(o,p)) ret.push(p);
  return ret;
}
if (!Array.indexOf) Array.prototype.indexOf = function(obj) {
  for(var i = 0; i < this.length; i++){
    if(this[i] == obj) {
      return i;
    }
  }
  return -1;
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
  
  function get_index(parent) {
    return parseInt($(parent).attr('class').replace(/[^\d]/g, ''));
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
    return btns.not('.unavailable').removeClass('locked').unbind('click').filter('.in-stock').click(handle_click);
  }
  
  function advance() {
    index++
    update();
    inventory(buttons.removeClass('locked'));
    enable(buttons.filter('.in-stock'));
  }
  
  function inventory(btns) {
    var count = 0, selected = [];
    var vars = get_variant_objects(divs.find('a.selected:last').attr('rel'));
    selected = Object.keys(vars);
    btns.removeClass('in-stock out-of-stock unavailable').each(function(i, element) {
      var variants = get_variant_objects(element.rel);
      $.each(variants, function(key, value) { 
        if (selected.indexOf(key) < 0) {
          variants[key] = null;
          delete variants[key];          
        } else {
          count += variants[key].count;
        }
      });
      var keys = Object.keys(variants);
      if (keys.length == 0) {
        disable($(element).addClass('unavailable locked').unbind('click'));
      } else if (keys.length == 1) {
        _var = variants[keys[0]];
        $(element).addClass(_var.count ? 'in-stock' : 'out-of-stock');
      } else {
        console.log('multiple!', count);
        $(element).addClass(count ? 'in-stock' : 'out-of-stock');        
      }
    });
  }
  
  function get_variant_objects(rels) {
    var i, ids, obj, count = 0, objects = {}, variants = {};
    if (typeof(rels) == 'string') { rels = [rels]; }
    var otid, ovid, opt, opv;
    i = rels.length;
    try {
      while (i--) {
        ids = rels[i].split('-');
        otid = ids[0];
        ovid = ids[1];
        opt = options[otid];
        if (opt) {
          opv = opt[ovid];
          ids = Object.keys(opv);
          if (opv && ids.length) {
            var j = ids.length;
            while (j--) {
              obj = opv[ids[j]];
              variants[obj.id] = opv[ids[j]];
            }
          }
        }
      }
    } catch(error) {
      _log(error);
    }    
    return variants;
  }
  
  function find_variant() {
    var selected = divs.find('a.selected');
    if (selected.length == divs.length) {
      return variant = get_variant_objects($.map(selected, function(i) { return i.rel }));
    };
  }
      
  function toggle() {
    if (variant) {
      console.log('variant:', variant);
      $('#variant_id').val(variant.id);
      $('button[type=submit]').attr('disabled', false).fadeTo(100, 1);
    } else {
      $('#variant_id').val('');
      $('button[type=submit]').attr('disabled', true).fadeTo(0, 0.5);
    }    
  }
  
  function clear(i) {
    variant = null;
    update(i);
    enable(buttons.removeClass('selected'));
    toggle();
    parent.nextAll().each(function(index, element) {
      disable($(element).find('a.option-value').show().removeClass('in-stock out-of-stock').addClass('locked').unbind('click'));
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
    if (find_variant()) {
      toggle();
    }
  }
  
  function _log(msg) {
    if (!(window.console && window.console.log)) return;
    console.log(msg);
  }
  
  $(document).ready(init);
  
};
