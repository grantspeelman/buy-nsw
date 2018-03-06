(function() {
  "use strict";
  window.ProcurementHub = window.ProcurementHub || {};

  function ExpandingListModule(options) {
    this.$el = options.$el;
    this.$template = this.buildTemplateForm();
    this.$container = this.$el.find('ol');

    this.setupForm();
  }

  ExpandingListModule.prototype.setupForm = function setupForm(){
    this.$el.addClass('expanding-list');
    this.buildAddLink().appendTo(this.$el);

    // Only add delete links to the rows which exist in the database, not new
    // empty ones. We can check for this by finding the ones which have an
    // existing value in the 'id' hidden field.
    //
    var $rows = this.$container.find('li:has(input[type=hidden][value])');
    $($rows).each(
      $.proxy(this.buildDeleteLink, this)
    );
  }

  ExpandingListModule.prototype.addNewRow = function addNewRow(event){
    event.preventDefault();

    var $newRow = this.$template.clone();

    var $label = $newRow.find('label');
    var $textInput = $newRow.find('input[type=text]');
    var $hiddenInput = $newRow.find('input[type=hidden]');

    var newIndex = this.getNewIndex();
    var visibleIndex = newIndex + 1;

    $label.text(visibleIndex + '.');

    $label.attr('for', this.buildFieldID(
                          $textInput.attr('id'), newIndex
                        ));

    $textInput.attr('name', this.buildFieldName(
                              $textInput.attr('name'), newIndex
                            ));
    $textInput.attr('id', this.buildFieldID(
                            $textInput.attr('id'), newIndex
                          ));

    $hiddenInput.attr('name', this.buildFieldName(
                              $hiddenInput.attr('name'), newIndex
                            ));
    $hiddenInput.attr('id', this.buildFieldID(
                              $hiddenInput.attr('id'), newIndex
                            ));

    $newRow.appendTo(this.$container);
  }

  ExpandingListModule.prototype.deleteRow = function deleteRow($row){
    event.preventDefault();

    var $inputField = $row.find('input[type=text]');
    var $deleteLink = $row.find('a');
    var $label = $row.find('label');

    var existingText = $inputField.val();

    var $previousVal = $('<span></span>');
    $previousVal.addClass('previous-value').text(existingText);

    $row.addClass('removed');
    $inputField.val('').attr('disabled', true);
    $previousVal.insertAfter($label);
    $deleteLink.remove();
  }

  ExpandingListModule.prototype.buildAddLink = function buildAddLink(){
    var $addLink = $('<a></a>');
    $addLink.text('Add another row');
    $addLink.attr('href','#');
    $addLink.on('click', $.proxy(this.addNewRow, this));

    return $addLink;
  }

  ExpandingListModule.prototype.buildDeleteLink = function buildDeleteLink(i, element){
    var $deleteContainer = $('<div></div>').addClass('delete-action');
    var $deleteLink = $('<a></a>');
    var $element = $(element);

    $deleteLink.text('Delete this row');
    $deleteLink.attr('href','#');
    $deleteLink.on('click', $.proxy(this.deleteRow, this, $element));

    $deleteLink.appendTo($deleteContainer);
    $deleteContainer.appendTo($element);
  }

  ExpandingListModule.prototype.buildTemplateForm = function buildTemplateForm(){
    var $templateForm = this.$el.find('li:first-of-type').clone();

    var $label = $templateForm.find('label');
    var $textInput = $templateForm.find('input[type=text]');
    var $hiddenInput = $templateForm.find('input[type=hidden]');

    $textInput.val('');
    $hiddenInput.val('');

    return $templateForm;
  }

  ExpandingListModule.prototype.buildFieldName = function buildFieldName(name, newIndex){
    // The following expressions are designed to match everything in the following
    // strings apart from the '[0]' index:
    //
    //    application[accreditations_attributes][0][accreditation]
    //
    var nameExpr = /([\w\[\]]+)\[0\](\[\w+\])$/;

    var matches = name.match(nameExpr);
    var newFieldName = matches[1] + '[' + newIndex + ']' + matches[2];

    return newFieldName;
  }

  ExpandingListModule.prototype.buildFieldID = function buildFieldID(id, newIndex){
    // The following expressions are designed to match everything in the following
    // strings apart from the '[0]' index:
    //
    //    application_accreditations_attributes_0_accreditation
    //
    var idExpr = /([\w\[\]]+)_0_(\w+)$/;

    var matches = id.match(idExpr);
    var newFieldID = matches[1] + '_' + newIndex + '_' + matches[2];

    return newFieldID;
  }

  ExpandingListModule.prototype.getNewIndex = function getNewIndex(){
    var $lastEl = this.$el.find('li:last-of-type');
    var $hiddenInput = $lastEl.find('input[type=hidden]');

    var indexExpr = /[\w\[\]]+_(\d+)_\w+$/;
    var matches = $hiddenInput.attr('id').match(indexExpr);

    var lastIndex = parseInt(matches[1]);

    return (lastIndex + 1);
  }

  ProcurementHub.ExpandingListModule = ExpandingListModule;
}());

$(function(){
  $('*[data-module="expanding-list"]').each(function(i, element){
    new ProcurementHub.ExpandingListModule({
      $el: $(element)
    });
  });
})
