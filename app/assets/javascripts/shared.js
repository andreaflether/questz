import { select2Data, select2DefaultOptions } from './select2data'

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

  function initializeDuplicateSelect2() {
    $('.duplicate_id_field').select2({
      ...select2DefaultOptions,
      templateResult: formatQuestion,
      ajax: {
        dataType: 'json',
        ...select2Data
      }
    });
  }

  $('#modal-close').on('show.bs.modal', function() {
    initializeDuplicateSelect2()
  })

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

  initializeDuplicateSelect2()
})