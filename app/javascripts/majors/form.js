//= require <jquery>

$(function() {
  $('fieldset legend a').click(function() {
    var new_el = $($('#new-requirement').html().replace(/CHANGEME/g,
        new Date().getTime()));

    $(this).closest('fieldset').append(new_el);

    return false;
  });

  $('.course a').live('click', function() {
    $(this).closest('dd').remove();
  });

  $('.requirement a').live('click', function() {
    var script = $(this).siblings('.new-course').html();
    script = script.replace(/CHANGEME/g, new Date().getTime());
    var el = $('<dd>').addClass('course').html(script);
    el.find('input:disabled').removeAttr('disabled');
    $(el).insertBefore($(this).closest('dd'));
    return false;
  });
});
