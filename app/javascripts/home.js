//= require <jquery>
//= require <jquery/ui>
//= require <jquery/scroll_to>

//= require <home/dragging>

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

  // Dragging courses between positions
  makeSortable($('.courses'));

  // Dragging requirements over to the courses
  makeDraggable($('#majors .course'));

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

  $('#majors h4').live('mouseover mouseout', function(e) {
    $(this).closest('.group').find('.req').trigger(e.type);
  });

  // Accordian majors
  $('#majors .show-hide').live('click', function() {
    $(this).closest('.major').find('.group').slideToggle();
    return false;
  });

  // Showing/hiding requirements
  $('#show_completed').live('click', function() {
    if ($(this).is(':checked')) {
      $(this).closest('.major').find('.completed').slideDown();
    } else {
      $(this).closest('.major').find('.completed').slideUp();
    }
  });
});
