//= require <jquery>
//= require <jquery/ui>

$(function() {

  // Binding the autocomplete of each class search list
  function bindAutocomplete(el) {
    $(el).autocomplete({
      source: '/courses/search',
      minLength: 2,
      select: function(event, ui) {
        if (ui.item) {
          var hidden = $(event.srcElement).siblings('input:hidden');
          hidden.val(ui.item.id);
        }
      }
    });
  }

  $('.course input:text').each(function(i, el) {
    bindAutocomplete(el);
  });

  // Adding requirements
  $('fieldset legend a').click(function() {
    var new_el = $($('#new-requirement').html().replace(/CHANGEME/g,
        new Date().getTime()));

    $(this).closest('fieldset').append(new_el);

    return false;
  });

  // Removing courses
  $('.course a').live('click', function() {
    $(this).closest('dd').remove();

    return false;
  });

  // Finds the template, copies it, then binds the autocomplete and inserts
  $('.requirement a.add').live('click', function() {
    var script = $(this).siblings('.new-course').html();
    script = script.replace(/CHANGEME/g, new Date().getTime());
    var el = $('<dd>').addClass('course').html(script);
    
    el.find('input:disabled').removeAttr('disabled');
    bindAutocomplete(el.find('input:text'));
    
    $(el).insertBefore($(this).closest('dd'));
    return false;
  });

});
