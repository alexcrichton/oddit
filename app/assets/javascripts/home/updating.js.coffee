window.updateMajor = (id) ->
  jQuery.ajax
    url: '/users/update_major',
    dataType: 'script',
    data: {major_id: id}

window.updateMajors = ->
  jQuery('.major').each (_, el) ->
    updateMajor($(el).data('id'));
