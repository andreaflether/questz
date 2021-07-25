import { select2Data, select2DefaultOptions } from './select2data'

$(document).ready(function() {
  $(document).on('scroll load', function(){
    if ($(this).scrollTop() > 550) {
      $('.sticky-top.toc').removeClass('top-spacing');
    } else {
      $('.sticky-top.toc').addClass('top-spacing');
    }
  })

  $('input[type=radio][name="report[reason]"]').change(function() {
    $('#report_duplicate_id').val(null).trigger('change');
    $('#report_mod_attention_details').val('');
  });

  const tagsAllowed = $('#question_tag_list').attr('data-tags') === 'false' ? false : true;

  $('#question_tag_list').select2({
    ...select2DefaultOptions,
    tokenSeparators: tagsAllowed ? ['/', ',', ';'] : null,
    ajax: {
      dataType: 'json',
      ...select2Data,
      processResults: function (data) {
        return {
          results: $.map(data.results, function(obj) {
            return { id: obj.text, text: obj.text };
          })
        };
      },
      ...select2Data
    }
  });  

  $('.masonry').masonry({
    percentPosition: true,
    horizontalOrder: true
  });
})