

$(document).ready(function() {
  function formatQuestion (question) {
    if (!question.id) {
      return question.text;
    }
    var $question = $(
      '<span class="fw-bold">ID #'+ question.id + ' - </span>' + '<span>'+ question.text + '</span>'
    );
    return $question;
  };
  
  const select2Data = {
    data: function (params) {
      var query = {
        search: params.term,
        page: params.page || 1
      }
      return query;
    }
  }

  const select2DefaultOptions = {
    theme: 'bootstrap4',
  }

  $('#report_duplicate_id').select2({
    ...select2DefaultOptions,
    templateResult: formatQuestion,
    ajax: {
      dataType: 'json',
      ...select2Data
    }
  });

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

  $('#tags_row').masonry({
    percentPosition: true
  });

  DependentFields.bind();

  var exampleModal = document.getElementById('confirmationModal')
  exampleModal.addEventListener('show.bs.modal', function (event) {
    var button = event.relatedTarget
    var modalContent = button.getAttribute('data-bs-content')

    var method = button.getAttribute('data-bs-method')
    var path = button.getAttribute('data-bs-path')
    
    var submitBtn = exampleModal.querySelector('[data-bs-submit]')
    var modalBodyInput = exampleModal.querySelector('.modal-body')

    modalBodyInput.textContent = modalContent
    submitBtn.setAttribute('data-method', method)
    submitBtn.setAttribute('href', path)
  })
})