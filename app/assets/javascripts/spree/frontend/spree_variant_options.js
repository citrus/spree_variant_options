//= require spree/frontend
//= require extentions/array
//= require extentions/global_methods

var SpreeVariantOption = {};
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
  this.originalCombination = original_combination;
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
    if(_this.possibleCombinationsArray.length === 0){
      _this.noVariantsPresent($this);
    } else if(_this.containsEmptyHash()) {
      _this.setVariantSelected();
    } else if (_this.possibleCombinationsArray.length === 1) {
      _this.findOptionButton(_this.possibleCombinationsArray[0]).trigger('click');
    }
  });
};

SpreeVariantOption.OptionValuesHandler.prototype.noVariantsPresent = function(optionClicked) {
  this.resetAllOtherButtons(optionClicked);
  this.possibleCombinationsArray = $.extend(true, [], this.originalCombination);
  optionClicked.trigger('click');
};

SpreeVariantOption.OptionValuesHandler.prototype.setVariantSelected = function() {
  this.disableCartInputFields(false);
  var variant = this.findVariantForAllSelected();
  this.setVariantId(variant);
  this.showVariantImages(variant.variant_id);
};

SpreeVariantOption.OptionValuesHandler.prototype.resetAllOtherButtons = function(justClicked){
  this.variantField.val('');
  this.thumbImages.show();
  this.optionsButton.filter('.selected').not(justClicked).removeClass('out-of-stock').removeClass('selected');
};

SpreeVariantOption.OptionValuesHandler.prototype.findVariantForAllSelected = function(){
  var conditions = {};
  this.optionsButton.filter('.selected').each(function() {
    conditions[$(this).data('typeId')] = $(this).data('valueId');
  });
  $.each(variant_option_details, function() {
    if (objectContains(this.option_types, conditions)) {
      variant = this;
    }
  });
  return variant;
};

SpreeVariantOption.OptionValuesHandler.prototype.findOptionButton = function(hash) {
  var key = Object.keys(hash)[0],
      value = hash[key];
  return this.optionsButton.filter('[data-type-id="' + key + '"][data-value-id="' + value + '"]');
};

SpreeVariantOption.OptionValuesHandler.prototype.setVariantId = function(variant) {
  this.variantField.val(variant.variant_id);
  this.priceHeading.html(variant.variant_price);
  if (!variant.in_stock && !options.allow_select_outofstock) {
    this.optionsButton.filter('.selected').addClass('out-of-stock');
  }
};

SpreeVariantOption.OptionValuesHandler.prototype.containsEmptyHash = function() {
  for (var i = this.possibleCombinationsArray.length - 1; i >= 0; i--) {
    if(Object.keys(this.possibleCombinationsArray[i]).length === 0){
      return true;
    }
  }
};

SpreeVariantOption.OptionValuesHandler.prototype.findAndReduce = function(availableOptions, justClickedButton) {
  var key = justClickedButton.data("typeId"),
      value = justClickedButton.data("valueId");
  return availableOptions.filter(function (item) {
    if (item[key] == value) {
      delete item[key];
      return item;
    }
  });
};

SpreeVariantOption.OptionValuesHandler.prototype.disableCartInputFields = function(value) {
  this.addToCartButton.prop('disabled', value);
  this.quantityField.prop('disabled', value);
  if(value) {
    this.priceHeading.html('Select Variant');
  }
};

SpreeVariantOption.OptionValuesHandler.prototype.showVariantImages = function(variantId) {
  var imagesToShow = this.thumbImages.filter('li.tmb-' + variantId);
  this.thumbImages.hide();
  imagesToShow.show().first().trigger('mouseenter');
};

$(function() {
  if ($("input#variant_present").val() == 'true') {
    (new SpreeVariantOption.OptionValuesHandler({
      optionsButton: $('a[data-hook=option-value]'),
      addToCartButton: $('#add-to-cart-button'),
      priceHeading: $('#product-price [itemprop=price]'),
      quantityField: $('#quantity'),
      variantField: $('input#variant_id'),
      thumbImages: $('li.vtmb')
    })).init();
  }
});
