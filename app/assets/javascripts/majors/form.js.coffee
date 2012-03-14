#= require jquery-ui
#= require jquery/tokeninput
#= require majors/liveedit
#= require tooltip

jQuery ->
  # Binding the autocomplete of each class search list
  window.bindCourseAutocomplete = (el) ->
    update = -> $(el).change()
    $(el).tokenInput '/courses/search',
      prePopulate: $(el).data('courses')
      onAdd: update
      onDelete: update
      preventDuplicates: true

  # Removing a requirement group
  $('legend .remove').live 'ajax:before', ->
    if $(this).closest('fieldset').find('.requirements').children().length == 0
      true
    else
      $.rails.confirm('Are you sure?')

  # Removing a requirement
  $('.requirement .remove a').live 'ajax:before', ->
    input = $(this).closest('.requirement').
      find('.courses :input[id$=course_ids]')
    if input.val() == ''
      true
    else
      $.rails.confirm('Are you sure?')

  # Removing courses
  $('.course a').live 'click', ->
    $(this).closest('dd').remove()
    false

  # Accordian groups
  $('.show-hide').live 'click', ->
    $(this).toggleClass('other')
    content = $(this).closest('.requirement-group').find('.content')
    content.slideToggle()
    el = $(this).closest('.requirement-group').find('input.visible')

    if content.is(':visible')
      el.val('1').removeAttr('disabled')
    else
      el.val('0').attr('disabled', 'disabled')

    false

  # Autocomplete tokenizers
  $(':text.autocomplete').each (_, el) -> bindCourseAutocomplete(el)
