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
  this.conditions = {};
  this.bindEvents();
  if (this.optionsButton.length != 0) {
    this.disableCartInputFields(true);
  }
};

SpreeVariantOption.OptionValuesHandler.prototype.bindEvents = function() {
  this.optionsButtonClickHandler();
};

SpreeVariantOption.OptionValuesHandler.prototype.optionsButtonClickHandler = function() {
  var _this = this;

  this.optionsButton.on('click', function(e) {
    var $this = $(this);
    e.preventDefault();
    $this.addClass('selected');
    _this.updateSiblings($this);
    _this.setConditions();
    _this.disableCartInputFields(true);
    _this.exactMatch = false;

    if (!_this.variantExistsForThisCondition()) {
      _this.resetAllLevel($this);
      _this.conditions = {};
      _this.setConditions();
    }
    if (_this.variantExistsForThisCondition()) {
      if (_this.exactMatch) {
        _this.unlockNextLevel($this, false);
        _this.setVariantWithSelecetedValues();
      } else {
        _this.unlockNextLevel($this, true);
      }
    }
  });
};

SpreeVariantOption.OptionValuesHandler.prototype.setConditions = function() {
  var _this = this;
  this.optionsButton.filter('.selected').each(function() {
    _this.conditions[$(this).data('typeId')] = $(this).data('valueId');
  });
};

SpreeVariantOption.OptionValuesHandler.prototype.variantExistsForThisCondition = function(conditions) {
  if (!conditions) {
    var conditions = this.conditions;
  }
  var variant = false;
  var _this = this;
  $.each(variant_option_details, function() {
    if (objectContains(this.option_types, conditions)) {
      variant = {
        inStock: this.in_stock
      };
      if (objectContains(conditions, this.option_types)) {
        _this.exactMatch = true;
        return false;
      }
    }
  });
  return variant;
};

SpreeVariantOption.OptionValuesHandler.prototype.disableCartInputFields = function(value) {
  this.addToCartButton.prop('disabled', value);
  this.quantityField.prop('disabled', value);

  if (value) {
    this.priceHeading.html('Select Variant');
  }
};

SpreeVariantOption.OptionValuesHandler.prototype.updateSiblings = function(optionValue) {
  var siblings = optionValue.closest('li').siblings();
  siblings.find('a').removeClass('selected');
};

SpreeVariantOption.OptionValuesHandler.prototype.resetAllLevel = function(optionValue) {
  var allDivs = optionValue.closest('.variant-options').siblings('.variant-options');
  allDivs.find('.option-value').removeClass('selected');
  this.disableCartInputFields(true);
  this.setVariantId(false);
  this.thumbImages.show();
};

SpreeVariantOption.OptionValuesHandler.prototype.setVariantId = function(is_exist) {
  if (is_exist) {
    this.variantField.val(this.variantId);
    this.priceHeading.html(this.variantPrice);
  } else {
    this.variantField.val('');
    this.priceHeading.html('Select Variant');
  }
};

SpreeVariantOption.OptionValuesHandler.prototype.unlockNextLevel = function(optionValue, trigger) {
  var divOption = optionValue.closest('.variant-options').siblings('.variant-options').first();
  while (divOption.find('.selected').length > 0) {
    divOption = divOption.next('.variant-options');
  }

  var allOptionValues = divOption.find('.option-value');
  var availableOptionValueCount = 0,
    availableOptionValue,
    _this = this,
    conditions = {},
    details;

  $.extend(conditions, this.conditions);
  allOptionValues.each(function() {
    var $this = $(this);

    conditions[$(this).data('typeId')] = $(this).data('valueId');
    details = _this.variantExistsForThisCondition(conditions);

    if (details) {
      availableOptionValueCount += 1;
      availableOptionValue = $this;
      if (!details["inStock"] && !options["allow_select_outofstock"]) {
        $this.addClass('out-of-stock');
      }
    } else {
      $this.removeClass('out-of-stock');
    }
  });
  if (availableOptionValueCount == 1 && trigger) {
    availableOptionValue.trigger('click');
  }
};

SpreeVariantOption.OptionValuesHandler.prototype.setVariantWithSelecetedValues = function() {
  var _this = this;
  this.variantId = 0;
  $.each(variant_option_details, function() {
    if (objectContains(this.option_types, _this.conditions)) {
      _this.variantId = this.variant_id;
      _this.variantPrice = this.variant_price;
    }
  });

  if (this.variantId) {
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

$(function() {
  (new SpreeVariantOption.OptionValuesHandler({
    optionsButton: $('.option-value'),
    addToCartButton: $('#add-to-cart-button'),
    priceHeading: $('#product-price [itemprop=price]'),
    quantityField: $('#quantity'),
    variantField: $('#variant_id'),
    thumbImages: $('li.vtmb')
  })).init();
});
