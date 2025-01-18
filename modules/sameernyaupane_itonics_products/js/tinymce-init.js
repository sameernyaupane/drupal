(function ($) {
  Drupal.behaviors.sameernyaupaneItonicsProducts = {
    attach: function (context, settings) {
      tinymce.init({
        selector: 'textarea[name="description"]',
        plugins: [
          'advlist autolink lists link image charmap print preview anchor',
          'searchreplace visualblocks code fullscreen',
          'insertdatetime media table paste code help wordcount'
        ],
        toolbar: 'undo redo | formatselect | bold italic backcolor | \
          alignleft aligncenter alignright alignjustify | \
          bullist numlist outdent indent | removeformat | help',
        height: 400,
        width: '100%'
      });
    }
  };
})(jQuery);