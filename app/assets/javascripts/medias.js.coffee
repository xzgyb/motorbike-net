$(document).on 'page:change', ->
  $("[role='dialog']").on 'show.bs.modal', ->
    $modalDialog = $(this).find('.modal-dialog')

    $modalDialog.css({
      'position': 'absolute',
      'margin': '10px',
      'top': "0"
      'left': "0"
    })

  $('.gallery a').click ->
    $('#gallery-image-modal .image-preview').attr('src', $(this).attr('href'))
    $('#gallery-image-modal').modal()
    return false
