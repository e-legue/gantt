define([
  "dojo/_base/declare",
  "dijit/_Widget",
  "dijit/form/Button",
], function(
  declare, 
  _WidgetBase,
  Button
) {
    
  var CustomEditorLegLayover = declare("CustomEditorLegLayover", [_WidgetBase], {
    value          : null,
    buildRendering : function() {
      var self = this;
      this.inherited(arguments);

      self._buttonLeg = new Button({
        label     : "New leg",
        iconClass : "plusIcon",
        class     : "thinButton",
      });
      self._buttonLayover = new Button({
        label     : "New layover",
        iconClass : "plusIcon",
        class     : "thinButton",
      });
      self._buttonDelete = new Button({
        iconClass : "dijitIconDelete",
        class     : "thinButton",
      });

      self._buttonLeg.on("click", function() {
        self.grid.collection.add({
          pk      : self.grid.collection.nextPk,
          order   : self.value.order + 0.1,
          type    : "leg",
          legType : "A",
          dhour   : 2,
          dminute : 0,
        });
        self.grid.collection.add({
          pk      : self.grid.collection.nextPk,
          order   : self.value.order + 0.2,
          dhour   : 0,
          dminute : 45,
          type    : "sta",
        });
        self.grid.collection.process();
      });

      self._buttonLayover.on("click", function() {
        // prevoir le chgt de duree de la station d'avant.
        self.grid.collection.add({
          pk      : self.grid.collection.nextPk,
          order   : self.value.order + 0.1,
          type    : "lay",
          dhour   : 12,
          dminute : 0,
        });
        self.grid.collection.add({
          pk      : self.grid.collection.nextPk,
          order   : self.value.order + 0.2,
          dhour   : 0,
          dminute : 20,
          type    : "sta",
          station : self.value.station
        });
        self.grid.collection.process();
      });

      self._buttonDelete.on("click", function() {
        if( self.value.order != self.grid.collection.len -1 ) {
          self.grid.collection.filter({order: self.value.order + 1}).forEach( function(object) {
            self.grid.collection.removeSync(object.pk);
          });
        } 
        else {
          // as this is the last leg/layover in the ordered list, I need to delete the current
          // leg/layover and the previous station, because the next one is untouchable, required
          // as the destination station.
          self.grid.collection.filter({order: self.value.order - 1}).forEach( function(object) {
            self.grid.collection.removeSync(object.pk);
          });
        }

        self.grid.collection.removeSync(self.value.pk);
        self.grid.collection.process();
      });

    },
    _setValueAttr: function(value) {
      this.value = value;

      if( this.value.newLegButton ) this.domNode.appendChild(this._buttonLeg.domNode);
      if( this.value.newLayButton ) this.domNode.appendChild(this._buttonLayover.domNode);
      if( this.value.deleteButton ) this.domNode.appendChild(this._buttonDelete.domNode);
    },
    _getValueAttr: function() {
      return this.value;
    },
    destroy: function() {
      this._buttonLeg.destroy();
      this._buttonLayover.destroy();
      this._buttonDelete.destroy();
      this.inherited(arguments);
    }
  });

  return CustomEditorLegLayover;

});
