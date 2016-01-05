
$(document).on 'page:change', ->
  $("#gallery-image-modal").on 'show.bs.modal', ->
    $(this).css('display', 'block')
    $modalDialog = $(this).find('.modal-dialog')
    offset = ($(window).height() - $modalDialog.height()) / 2
    offset = 0 if offset < 0

    $modalDialog.css({
        'margin-top': offset
    })

  $('.gallery a').click ->
    $('#gallery-image-modal .image-preview').attr('src', $(this).attr('href'))
    $('#gallery-image-modal').modal()
    return false
