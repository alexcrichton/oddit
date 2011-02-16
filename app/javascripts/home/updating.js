//= require <jquery>

window.updateMajor = function(id) {
  $.ajax({
    url: '/users/update_major',
    dataType: 'script',
    data: {major_id: id}
  });
};

window.updateMajors = function() {
  $('.major').each(function(_, el) {
    updateMajor($(el).data('id'));
  });
};
