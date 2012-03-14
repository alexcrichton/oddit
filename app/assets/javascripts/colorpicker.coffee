#= require jquery/colorpicker

window.inputColorPick = (el) ->
  $el = $(el)
  selected = $el
  $el.ColorPicker
    onSubmit: (hsb, hex, rgb, el) ->
      $el.val(hex)
      $el.ColorPickerHide()
    onBeforeShow: -> $(this).ColorPickerSetColor(@value)
    onChange: (hsb, hex, rgb) ->
      if selected
        prop = if selected.attr('id').match /fon/ then 'color' else 'background'
        $('#example').css(prop, '#' + hex);
        selected.val(hex);
  $el.bind 'keyup', -> $(this).ColorPickerSetColor(@value);
  $el.focus -> selected = $(this)
