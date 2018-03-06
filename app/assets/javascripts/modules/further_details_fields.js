(function() {
  "use strict";
  window.ProcurementHub = window.ProcurementHub || {};

  function FurtherDetailsFieldsModule(options) {
    this.$el = options.$el;
    this.$radioButtons = this.$el.find('input[type=radio]');
    this.$furtherDetails = this.$el.find('.form-group:last-of-type');

    this.registerEvents();
    this.refreshFields();
  }

  FurtherDetailsFieldsModule.prototype.registerEvents = function registerEvents(){
    this.$radioButtons.on('change', $.proxy( this.refreshFields, this ));
  }

  FurtherDetailsFieldsModule.prototype.refreshFields = function refreshFields(){
    var value = this.$radioButtons.filter(':checked').val();

    if (value == 'true') {
      this.$furtherDetails.show();
    } else {
      this.$furtherDetails.hide();
    }
  }

  ProcurementHub.FurtherDetailsFieldsModule = FurtherDetailsFieldsModule;
}());

$(function(){
  $('*[data-module="further-details-fields"]').each(function(i, element){
    new ProcurementHub.FurtherDetailsFieldsModule({
      $el: $(element)
    });
  });
})
