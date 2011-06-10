function VariantOptions(options) {
  
  var options = options;
  var div, types, values, buttons, index = -1, selected = [];
  
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
  
  function set_buttons() {
    return buttons = $(values[index]).find('a.option-value');
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
      var vids = options[ids[0]][ids[1]];   
      selected[index] = this.rel;
      advance();
      console.log("SEL:", selected.length, selected);
      
    } catch(error) {
      console.log("Type / Value " + this.rel + " combination could not be found");
    }
  }
  
  $(document).ready(init);
  
};
