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
        processResults: function (data) {
          return {
            results: $.map(data.results, function(obj) {
              return { id: obj.text, text: obj.text };
            })
          };
        },
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

  var urlParams = new URLSearchParams(window.location.search);

  if(urlParams.toString().length) {
    for (const [key] of urlParams) { 
      $('.navigation-tabs').find(`.${key}`).addClass('active');
    }
  } else {
    $('.navigation-tabs').find('.main-tab').addClass('active');
  }

  $('.followed-tags > .list-group-item.tag').filter(function(){
    return this.innerHTML == urlParams.get('tag');
  }).addClass('active');

  const current_tab = urlParams.get('tab');

  if(current_tab !== null) {
    $('.navigation-tabs').find('.main-tab').removeClass('active');
    $('.navigation-tabs').find(`.${current_tab}`).addClass('active');
  }
})