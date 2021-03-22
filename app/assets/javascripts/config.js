$.notyf = new Notyf({
  duration: 5000,
  position: {
    x: 'center',
    y: 'top',
  },
  dismissible: true,
  types: [
    {
      type: 'warning',
      background: '#ffc107',
      icon: {
        className: 'fas fa-exclamation-triangle',
        tagName: 'i',
        color: 'white'
      }
    },
    {
      type: 'info',
      background: '#3d8bfd',
      icon: {
        className: 'fas fa-info-circle',
        tagName: 'i',
        color: 'white'
      }
    },
  ]
})