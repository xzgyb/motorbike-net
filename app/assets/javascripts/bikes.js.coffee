$(document).on 'page:change', ->
  $('.bike-summary-info>tbody tr').click ->
    unless $(this).hasClass("selected")
      document.location = $(this).data("href")
