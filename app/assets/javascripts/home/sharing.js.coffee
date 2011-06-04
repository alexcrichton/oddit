jQuery ->
  $('.facebook, .twitter').click ->
    window.open this.href, 'sharer', 'toolbar=0,status=0,width=626,height=436'
    false

  $('.toolbar .link').click ->
    dialog = $('<div>' + ajaxSmall + '</div>')
    dialog.load this.href, ->
      console.log 'here'
      dialog.dialog width:550, height:350
      dialog.dialog position: 'center'
    dialog.dialog modal:true

    false
