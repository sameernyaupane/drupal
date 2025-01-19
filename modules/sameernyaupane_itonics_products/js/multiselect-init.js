(function ($) {
  Drupal.behaviors.sameernyaupaneItonicsProductsMultiselect = {
    attach: function (context, settings) {
      $('select[multiple].multiselect', context).once('multiselect', function() {
        $(this).multiselect({
          selectedList: 4,
          noneSelectedText: Drupal.t('Select categories'),
          selectedText: Drupal.t('# categories selected'),
          height: 'auto',
          minWidth: 300
        });
      });
    }
  };
})(jQuery); 