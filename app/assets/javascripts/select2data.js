export const select2Data = {
  data: function (params) {
    var query = {
      search: params.term,
      page: params.page || 1
    }
    return query;
  }
}

export const select2DefaultOptions = {
  theme: 'bootstrap4',
}