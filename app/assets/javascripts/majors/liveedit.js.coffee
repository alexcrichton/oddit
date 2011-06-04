jQuery ->
  $(':input').each (_, el) ->
    $(el).data('original', $(el).val())

  $(':input').live 'blur', ->
    input = $(this)
    form = input.closest('form')
    return if input.val() == input.data('original') or
              input.closest('.token-input-list').length > 0

    input.data('original', input.val())
    input.addClass('saving').removeClass('error')

    data = {_method: 'put'}
    data[input.prop('name')] = input.val()

    $.ajax
      url: form.attr('action')
      type: form.attr('method')
      data: data
      dataType: 'json'
      success: ->
        input.addClass('good')
        setTimeout (-> input.removeClass('saving good')), 2000
      error: ->
        input.addClass('error')
