window.onload = function() {
  var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-toggle="tooltip"]'))
  var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
    return new bootstrap.Tooltip(tooltipTriggerEl)
  })
}

$(document).on('turbolinks:load', function() {
  $('.select2').select2({
    theme: 'bootstrap4',
    maximumSelectionLength: 5,
    tags: true,
    tokenSeparators: [','],
    placeholder: 'Search for tag...',
    tokenSeparators: ['/', ',', ';', ' '], 
    ajax: {
      url: '/tags/search',
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
})