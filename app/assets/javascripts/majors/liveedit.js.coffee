jQuery ->
  form = $('form')

  $(':input').blur ->
    input = this
    $(ajaxSmall).insertAfter(this)
    all_data = form.serializeArray()
    data = {}

    for input in all_data
      if input.name is $(this).prop('name') ||
         input.name is 'utf8' ||
         input.name is 'authenticity_token' ||
         input.name is '_method'
        data[input.name] = input.value

    $.ajax
      url: form.attr('action'),
      type: form.attr('method'),

    console.log data
