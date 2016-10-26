//= require spree/frontend
//= require_tree ../../extentions

var SpreeVariantOption = {}
SpreeVariantOption.OptionValuesHandler = function(selectors) {
  this.optionsButton = selectors.optionsButton;
  this.addToCartButton = selectors.addToCartButton;
  this.clearButtons = selectors.clearButtons;
  this.priceHeading = selectors.priceHeading;
  this.quantityField = selectors.quantityField;
  this.variantField = selectors.variantField;
  this.thumbImages = selectors.thumbImages;
  this.variantId = 0;
  this.variantPrice = 0;
};

SpreeVariantOption.OptionValuesHandler.prototype.init = function() {
  this.bindEvents();
  this.optionsButton.filter('[data-level!=1]').addClass('locked').removeClass('selected');
  this.disableCartInputFields(true);
};

SpreeVariantOption.OptionValuesHandler.prototype.bindEvents = function() {
  this.optionsButtonClickHandler();
  this.clearButtonClickHandler();

};

SpreeVariantOption.OptionValuesHandler.prototype.optionsButtonClickHandler = function() {
  var _this = this;

  this.optionsButton.on('click', function(e) {
    var $this = $(this);
    e.preventDefault();
    if(!$this.hasClass('locked')) {
      $this.addClass('selected');
      _this.updateSiblings($this);
      _this.resetAllNextLevel($this);
      _this.unlockNextLevel($this);

      if($this.data('level') == options["option_type_count"]) {
        _this.setVariantWithSelecetedValues();
      }
    }
  });
};

SpreeVariantOption.OptionValuesHandler.prototype.clearButtonClickHandler = function() {
  var _this = this;

  this.clearButtons.on('click', function(e) {
    e.preventDefault();
    $(this).closest('li').addClass('hidden');
    _this.updateSiblings($(this));
    _this.resetAllNextLevel($(this));
  });
};

SpreeVariantOption.OptionValuesHandler.prototype.disableCartInputFields = function(value) {
  this.addToCartButton.prop('disabled', value);
  this.quantityField.prop('disabled', value);

  if(value) { this.priceHeading.html('Select Variant'); }
};

SpreeVariantOption.OptionValuesHandler.prototype.updateSiblings = function(optionValue) {
  var siblings = optionValue.closest('li').siblings();
  siblings.find('a').removeClass('selected');
  siblings.filter('.clear-option').removeClass('hidden');
};

SpreeVariantOption.OptionValuesHandler.prototype.resetAllNextLevel = function(optionValue) {
  var nextAllDivs = optionValue.closest('.variant-options').nextAll('.variant-options');
  nextAllDivs.find('.clear-option').addClass('hidden');
  nextAllDivs.find('.option-value').addClass('locked').removeClass('selected');
  this.disableCartInputFields(true);
  this.setVariantId(false);
  this.thumbImages.show();
};

SpreeVariantOption.OptionValuesHandler.prototype.setComparingConditions = function (conditions) {
  conditions = conditions || {};

  this.optionsButton.filter('.selected').each(function() {
    conditions[$(this).data('typeId')] = $(this).data('valueId');
  });
};

SpreeVariantOption.OptionValuesHandler.prototype.anyVariantExists = function(conditions) {
  var variant = false;
  this.setComparingConditions(conditions);

  $.each(variant_option_details, function() {
    if(objectContains(this.option_types, conditions)) {
      variant = { inStock: this.in_stock };
      return false;
    }
  });
  return variant;
};

SpreeVariantOption.OptionValuesHandler.prototype.setVariantId = function(is_exist) {
  if(is_exist) {
    this.variantField.val(this.variantId);
    this.priceHeading.html(this.variantPrice);
  } else {
    this.variantField.val('');
    this.priceHeading.html('Select Variant');
  }
};

SpreeVariantOption.OptionValuesHandler.prototype.unlockNextLevel = function(optionValue) {
  var allOptionValues = optionValue.closest('.variant-options').next().find('.option-value'),
      availableOptionValueCount = 0,
      availableOptionValue,
      _this = this,
      details;

  allOptionValues.each(function() {
    var $this = $(this),
        conditions = {};

    conditions[$(this).data('typeId')] = $(this).data('valueId');
    details = _this.anyVariantExists(conditions);

    if(details) {
      availableOptionValueCount += 1;
      availableOptionValue = $this;
      if(($this.data('level') == options["option_type_count"]) && !details["inStock"] && !options["allow_select_outofstock"]) {
        $this.addClass('out-of-stock');
      } else {
        $this.removeClass('out-of-stock locked');
      }
    } else {
      $this.removeClass('out-of-stock');
    }
  });

  if(availableOptionValueCount == 1) {
    availableOptionValue.trigger('click');
  }
};

SpreeVariantOption.OptionValuesHandler.prototype.setVariantWithSelecetedValues = function() {
  var conditions = {},
      _this = this;
  this.variantId = 0;
  this.setComparingConditions(conditions);

  $.each(variant_option_details, function() {
    if(objectContains(this.option_types, conditions)) {
      _this.variantId = this.variant_id;
      _this.variantPrice = this.variant_price;
      return false;
    }
  });

  if(this.variantId) {
    this.setVariantId(true);
    this.showVariantImages(this.variantId);
    this.disableCartInputFields(false);
  } else {
    this.disableCartInputFields(true);
  }
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
    clearButtons: $('.clear-button')
  })).init();
});
