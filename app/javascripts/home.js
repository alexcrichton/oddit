//= require <jquery>
//= require <jquery/ui>
//= require <jquery/scroll_to>

window.bindAutocomplete = function(el) {
  $(el).autocomplete({
    source: '/courses/search',
    select: function(event, ui) {
      if (ui.item) {
        var form = $(event.srcElement).closest('form');
        form.find('#course_id').val(ui.item.id);
      }
    }
  });
};

$(function() {
  // Adding a new major
  $('#majors :text').autocomplete({
    source: '/majors/search',
    select: function(event, ui) {
      if (ui.item) {
        var form = $(event.srcElement).closest('form');
        form.find('#major_id').val(ui.item.id);
      }
    }
  });

  // Draggable semesters
  $('#semesters').sortable({
    handle: 'legend',
    placeholder: 'ui-state-highlight',
    update: function(event, ui) {
      var elementMoved = $(ui.item[0]);

      var csrf_token = $('meta[name=csrf-token]').attr('content'),
          csrf_param = $('meta[name=csrf-param]').attr('content');

      var data = {_method: 'put', pos: elementMoved.prevAll().length};
      data[csrf_param] = csrf_token;

      $.ajax({
        dataType: 'script',
        type: 'POST',
        url: '/semesters/' + elementMoved.data('id') + '/order',
        data: data
      });
    }
  });

  // Removing field_with_errors stuff when typing
  $(':text').live('keyup', function() {
    $(this).parent().removeClass('field_with_errors');
  });

  // Autocompete for all of the semesters
  $('#semesters :text').each(function(_, el) {
    bindAutocomplete(el);
  });

  // Expanding major menus
  $('#majors .req .name').live('click', function() {
    var el = $(this).siblings('ul');

    if (el.is(':visible')) {
      el.slideUp();
    } else {
      el.slideDown();
    }

    return false;
  });

  // Hovering to show connections
  $('#majors .req').live('mouseover mouseout', function(e) {
    $.each($(this).data('scheduled'), function(_, el) {
      var course = $(
        '.semester[data-id=' + el[1] + '] .course[data-id=' + el[0] + ']');

      if (e.type == 'mouseover') {
        course.addClass('selected');
        course.closest('.courses').scrollTo(course);
      } else {
        course.removeClass('selected');
      }
    });
  });
});
