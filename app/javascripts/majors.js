//= require <jquery>

$(function() {
  $('.major a.info').live('click', function() {
    var majors = $(this).closest('.info').siblings('.majors');
    majors.toggle();

    $(this).find('.expand').text(majors.is(':visible') ? '-' : '+');

    return false;
  });
});
