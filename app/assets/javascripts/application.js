//= require turbolinks
//= require rails-ujs
//= require activestorage
// require popper.js/dist/umd/popper
//= require bootstrap/dist/js/bootstrap.bundle
//= require jquery/dist/jquery
//= require_tree .

window.onload = function() {
  var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-toggle="tooltip"]'))
  var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
    return new bootstrap.Tooltip(tooltipTriggerEl)
  })
}