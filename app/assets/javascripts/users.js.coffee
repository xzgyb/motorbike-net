$(document).on 'turbolinks:load', ->
    $('.user-operations input[type="checkbox"]').click ->
        form = $(this).closest('form')[0]
        form.submit()
