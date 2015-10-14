$(document).on 'page:change', ->
    $('.dropdown').hover ->
        $(this).addClass('open')
    , ->
        $(this).removeClass('open')
