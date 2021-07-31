$(document).ready(function() {
  $(document).on('scroll load', function(){
    if ($(this).scrollTop() > 550) {
      $('.sticky-top.toc').removeClass('top-spacing');
    } else {
      $('.sticky-top.toc').addClass('top-spacing');
    }
  });

  $('input[type=radio][name="report[reason]"]').change(function() {
    $('#report_duplicate_id').val(null).trigger('change');
    $('#report_mod_attention_details').val('');
  });

  $('.masonry').masonry({
    percentPosition: true,
    horizontalOrder: true
  });
})