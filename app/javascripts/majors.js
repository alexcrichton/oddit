//= require <jquery>

$(function() {
  $('.major a.extra').live('click', function() {
    var majors = $(this).closest('.extra').siblings('.majors');
    majors.toggle();

    $(this).find('.expand').text(majors.is(':visible') ? '-' : '+');

    return false;
  });
});
