function VariantOptions(options) {
  var options = options;
  
  function init() {
    this.div = $('#product-variants');
    console.log(this.div);
    
    this.types = this.div.find('.variant-option-type');
    this.values = this.div.find('.variant-option-values');
    
    //this.div.find('a.option-value').click(handle_click);
    
  }
  
  function handle_click(evt) {
    evt.preventDefault();
    try {
      var ids = this.rel.split("-");
      var vids = options[ids[0]][ids[1]];   
    } catch(error) {
      console.log("Type / Value combination could not be found");
      return false;
    }
    
    console.log(vids);
    
  }
  
  $(document).ready(init);
};
