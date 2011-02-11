//= require <jquery/qtip>

$(function() {
  $('*[data-tooltip]').each(function(index, el) {
    $(el).qtip({
      content: $(this).data('tooltip'),
      position: { corner: {target: 'rightMiddle', tooltip: 'leftMiddle' } },
      style:{name:'dark', tip: 'leftMiddle', border: {radius: 5}},
      show: {delay: 0, effect:{type:'show', length:0}, when:{event: 'mouseover'}},
      hide: {effect:{type:'hide'}, when:{event: 'mouseout'}}
    });
  });
});
