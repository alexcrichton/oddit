//= require <jquery/colorpicker>

window.inputColorPick = function(el) {
  $(el).ColorPicker({
    onSubmit: function(hsb, hex, rgb, el) {
      $(el).val(hex);
      $(el).ColorPickerHide();
    },
    onBeforeShow: function () {
      $(this).ColorPickerSetColor(this.value);
    },
    onChange: function (hsb, hex, rgb) {
      if (selected) {
        var prop = selected.attr('id').match(/font/) ? 'color' : 'background';
        $('#example').css(prop, '#' + hex);
        selected.val(hex);
      }
    }
  }).bind('keyup', function(){
    $(this).ColorPickerSetColor(this.value);
  }).focus(function() {
    selected = $(this);
  });
};
