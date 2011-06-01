jQuery ->
  $('.major a.extra').live 'click', ->
    majors = $(this).closest('.extra').siblings('.majors')
    majors.toggle()

    $(this).find('.expand').text(if majors.is(':visible') then '-' else '+')

    false
