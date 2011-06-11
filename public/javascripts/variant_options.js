function VariantOptions(options) {
  
  var options = options;
  var divs, parent, index = 0;
  
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
  
  function get_index(parent) {
    return parseInt($(parent).attr('class').replace(/[^\d]/g, ''));
  }
  
  function handle_clear(evt) {
    evt.preventDefault();
    update(get_index(this));
    enable(buttons.removeClass('selected'));
    parent.nextAll().each(function(index, element) {
      disable($(element).find('a.option-value').addClass('locked').unbind('click'));
      $(element).find('a.clear-button').hide();
    });
  }
  
  function handle_click(evt) {
    evt.preventDefault();
    var a = $(this);
    if (!parent.has(a).length) {
      update( divs.index(a.parents('.variant-options:first')) ); 
    }
    disable(buttons);
    var a = enable(a.addClass('selected'));
    parent.find('a.clear-button').css('display', 'block');
    advance();    
  }
  
  $(document).ready(init);
  
};
