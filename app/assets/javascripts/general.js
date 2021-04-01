window.onload = function() {
  var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-toggle="tooltip"]'))
  var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
    return new bootstrap.Tooltip(tooltipTriggerEl)
  })
}

$(document).on('turbolinks:load', function() {
  $('select.select2').each(function () {
    const select = $(this);
    const tags = select[0].getAttribute('data-tags') === 'false' ? false : true;
    const url = select.data('url');

    select.select2({
      theme: 'bootstrap4',
      maximumSelectionLength: 5,
      tags: tags,
      tokenSeparators: [','],
      placeholder: 'Search for tag...',
      tokenSeparators: tags ? ['/', ',', ';'] : null, 
      ajax: {
        url: url,
        dataType: 'json',
        data: function (params) {
          var query = {
            search: params.term,
            page: params.page || 1
          }
          return query;
        }
      }
    });


  });
})