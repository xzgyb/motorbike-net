$(document).on 'page:change', ->
    $('.user-operations input[type="checkbox"]').click ->
        form = $(this).closest('form')[0]
        form.submit()
