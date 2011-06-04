jQuery ->
  $(':input').live 'change', ->
    input     = $(this)
    container = input.parent()
    form      = input.closest('form')

    return if input.closest('.token-input-list').length > 0

    container.addClass('saving').removeClass('error good')

    data = {_method: 'put'}
    # A checkbox's val() method always returns whatever is in the "value"
    # property, regardless of whether it's checked or not
    if input.is(':checkbox')
      data[input.prop('name')] = input.is(':checked')
    else
      data[input.prop('name')] = input.val()

    $.ajax
      url: form.attr('action')
      type: form.attr('method')
      data: data
      dataType: 'json'
      success: ->
        container.addClass('good')
        setTimeout (-> container.removeClass('saving good')), 2000
      error: ->
        container.addClass('error')
