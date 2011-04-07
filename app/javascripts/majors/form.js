//= require <jquery>
//= require <jquery/ui>
//= require <jquery/tokeninput>

$(function() {

  // Binding the autocomplete of each class search list
  function bindAutocomplete(el) {
    $(el).tokenInput('/courses/search', {
      prePopulate: $(el).data('courses')
    });
  }

  // Adding groups
  $('dl a').click(function() {
    var new_el = $($('#new-group').html().replace(/CHANGEME/g,
        new Date().getTime()));

    $('#groups').prepend(new_el);
    return false;
  });

  // Adding a requirement
  $('fieldset .add-req').live('click', function() {
    var area = $(this).closest('fieldset');
    var selector = '.new-requirement[data-id=' + area.data('id') + ']';
    var new_el = $(selector).html().replace(/ALTERME/g, new Date().getTime());
    new_el = $(new_el);

    area.find('.requirements').append(new_el);
    bindAutocomplete(new_el.find('.autocomplete'));
    return false;
  });

  // Removing courses
  $('.course a').live('click', function() {
    $(this).closest('dd').remove();

    return false;
  });

  // Accordian groups
  $('.show-hide').live('click', function() {
    $(this).toggleClass('other');
    var content = $(this).closest('.requirement-group').find('.content');
    content.slideToggle();
    var el = $(this).closest('.requirement-group').find('input.visible');

    if (content.is(':visible')) {
      el.val('1').removeAttr('disabled');
    } else {
      el.val('0').attr('disabled', 'disabled');
    }

    return false;
  });

  // Autocomplete tokenizers
  $(':text.autocomplete').each(function(_, el) { bindAutocomplete(el); });
});
