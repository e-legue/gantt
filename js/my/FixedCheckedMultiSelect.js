define([
  "dojo/_base/declare",
  "dojox/form/CheckedMultiSelect",
], function(
  declare, 
  CheckedMultiSelect
) {
  /*
   * Fix to support reset on CheckedMultiSelect.
   * source: http://jsfiddle.net/FNL3h/
   */
  var FixedCheckedMultiSelect = declare("dojox/form/FixedCheckedMultiSelect", [ CheckedMultiSelect ], {
    reset: function() {
      var self = this;
      self.inherited(arguments);
      if (!self._resetValue || !self._resetValue.length) {
        self._updateSelection();
      }
    },
    validator: function() {
      var self = this;
      if (!self.required) {
        return true;
      }
      return self.value.length > 0 ? true : false; 
    },
  });

  return FixedCheckedMultiSelect;

});


