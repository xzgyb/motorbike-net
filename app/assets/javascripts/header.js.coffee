$(document).on 'turbolinks:load', ->
    $('.dropdown').hover ->
        $(this).addClass('open')
    , ->
        $(this).removeClass('open')
