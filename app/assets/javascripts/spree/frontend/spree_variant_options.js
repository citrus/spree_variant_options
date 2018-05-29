//= require spree/frontend
//= require extentions/array
//= require extentions/global_methods
var SpreeVariantOption = {}
SpreeVariantOption.OptionValuesHandler = function(selectors) {
  this.optionsButton = selectors.optionsButton;
  this.addToCartButton = selectors.addToCartButton;
  this.priceHeading = selectors.priceHeading;
  this.quantityField = selectors.quantityField;
  this.variantField = selectors.variantField;
  this.thumbImages = selectors.thumbImages;
  this.variantId = 0;
  this.variantPrice = 0;
};

SpreeVariantOption.OptionValuesHandler.prototype.init = function() {
  this.disableCartInputFields(true);
   this.originalCombination = this.getInitialCombination();
   this.possibleCombinationsArray = $.extend(true, [], this.originalCombination);
   this.onButtonClick();
};

SpreeVariantOption.OptionValuesHandler.prototype.onButtonClick = function() {
  var _this = this;
  this.optionsButton.on("click", function() {
    var $this = $(this);
    _this.possibleCombinationsArray = _this.findAndReduce(_this.possibleCombinationsArray, $this);
    $this.addClass("selected");
    _this.disableCartInputFields(true);

    if(_this.possibleCombinationsArray.length == 0){
      _this.resetAllOtherButtons($this);
      _this.possibleCombinationsArray = $.extend(true, [], _this.originalCombination);
      $this.trigger('click');
    } else if(_this.containsEmptyHash()) {
      _this.disableCartInputFields(false);
      var variant = _this.findVariantForAllSelected();
      _this.setVariantId(variant);
      _this.showVariantImages(variant.variant_id);
    } else if (_this.possibleCombinationsArray.length == 1) {
      _this.findOptionButton(_this.possibleCombinationsArray[0]).trigger('click');
    }
  });
};

SpreeVariantOption.OptionValuesHandler.prototype.resetAllOtherButtons = function(justClicked){
  this.variantField.val('');
  this.thumbImages.show();
  this.optionsButton.filter('.selected').not(justClicked).removeClass('out-of-stock').removeClass('selected');
};

SpreeVariantOption.OptionValuesHandler.prototype.findVariantForAllSelected = function(){
  conditions = {};
  this.optionsButton.filter('.selected').each(function() {
    conditions[$(this).data('typeId')] = $(this).data('valueId');
  });
  for (var i = variant_option_details.length - 1; i >= 0; i--) {
    if (objectContains(variant_option_details[i].option_types, conditions)) {
      variant = variant_option_details[i];
      return variant;
    }
  }
};

SpreeVariantOption.OptionValuesHandler.prototype.findOptionButton = function(hash) {
  var key = Object.keys(hash)[0];
  var value = hash[key];
  return this.optionsButton.filter('[data-type-id="' + key + '"][data-value-id="' + value + '"]');
};

SpreeVariantOption.OptionValuesHandler.prototype.setVariantId = function(variant) {
  this.variantField.val(variant.variant_id);
  this.priceHeading.html(variant.variant_price);
  if (!variant.in_stock && !options["allow_select_outofstock"]) {
    this.optionsButton.filter('.selected').each(function() {
      $(this).addClass('out-of-stock');
    })
  }
};

SpreeVariantOption.OptionValuesHandler.prototype.containsEmptyHash = function(){
  for (var i = this.possibleCombinationsArray.length - 1; i >= 0; i--) {
    if(Object.keys(this.possibleCombinationsArray[i]).length == 0){
      return true;
    }
  }
};

SpreeVariantOption.OptionValuesHandler.prototype.findAndReduce = function(availableOptions, justClickedButton) {
  var key = justClickedButton.data("typeId")
  var value = justClickedButton.data("valueId")
  var reducedArray = [];
  for (var i = availableOptions.length - 1; i >= 0; i--) {
    if (availableOptions[i][key] == value) {
      delete availableOptions[i][key];
      reducedArray.push(availableOptions[i]);
    }
  }
  return reducedArray;
};

SpreeVariantOption.OptionValuesHandler.prototype.getInitialCombination = function(){
  var variantOptionTypes = [];
  if (typeof variant_option_details != "undefined") {
    $.each(variant_option_details, function() {
      variantOptionTypes.push(this.option_types);
    });
  }
  return variantOptionTypes;
};

SpreeVariantOption.OptionValuesHandler.prototype.disableCartInputFields = function(value) {
  this.addToCartButton.prop('disabled', value);
  this.quantityField.prop('disabled', value);

  if(value) { this.priceHeading.html('Select Variant'); }
};

SpreeVariantOption.OptionValuesHandler.prototype.showVariantImages = function(variantId) {
  var imagesToShow = this.thumbImages.filter('li.tmb-' + variantId);

  this.thumbImages.hide();
  imagesToShow.show();
  imagesToShow.first().trigger('mouseenter');
};

$(function () {
  (new SpreeVariantOption.OptionValuesHandler({
    optionsButton: $('.option-value'),
    addToCartButton: $('#add-to-cart-button'),
    priceHeading: $('#product-price [itemprop=price]'),
    quantityField: $('#quantity'),
    variantField: $('#variant_id'),
    thumbImages: $('li.vtmb'),
  })).init();
});
