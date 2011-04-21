//= require <jquery>
//= require <jquery/ui>
//= require <jquery/scroll_to>

//= require <home/dragging>
//= require <tooltip>

$(function() {

  function hideMajorCourses(major) {
    var ids = major.find('.course').map(function(_, el) {
      return $(el).data('id');
    });
    var others = major.siblings('.major').find('.taken .course').map(
      function(_, el) { return $(el).data('id'); });

    for (var i = 0; i < ids.length; i++) {
      if ($.inArray(ids[i], others) == -1) {
        $('.course[data-id="' + ids[i] + '"]').css('opacity', '0.5');
      }
    }
  }

  function showMajorCourses(major) {
    var ids = major.find('.course').map(function(_, el) {
      return $(el).data('id');
    });

    for (var i = 0; i < ids.length; i++) {
      $('.course[data-id="' + ids[i] + '"]').css('opacity', '1');
    }
  }

  // Removing field_with_errors stuff when typing
  $(':text').live('keyup', function() {
    $(this).parent().removeClass('field_with_errors');
  });

  // Autocompete for all of the semesters
  $('#semesters :text').each(function(_, el) {
    bindAutocomplete(el);
  });
  $('#semesters form').submit(function() {
    $(this).find('.ui-autocomplete-input').autocomplete('close');
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

      if (!course.is(':visible')) {
        course = course.closest('.semester');
      }

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
    var major = $(this).closest('.major');
    var group = major.find('.content');
    if (group.is(':visible')) {
      group.slideUp();
      hideMajorCourses(major);
    } else {
      group.slideDown();
      showMajorCourses(major);
    }

    $(this).toggleClass('other');
    return false;
  });

  // Showing/hiding requirements
  $('.major .show_completed').live('click', function() {
    if ($(this).is(':checked')) {
      $(this).closest('.major').find('.completed').slideDown();
    } else {
      $(this).closest('.major').find('.completed').slideUp();
    }
  });

  // Accordian semesters
  $('#semesters .show-hide').live('click', function() {
    $(this).closest('.semester').find('.content').slideToggle();
    $(this).toggleClass('other');
    return false;
  });

  // Showing/hiding add course form
  $('#semesters .add').live('click', function() {
    $(this).closest('.semester').find('form').toggle().
        find('input:text').focus();
    $(this).toggleClass('other');
    return false;
  });

  // Escape closes add course form
  $('#semesters input:text').live('keydown', function(e) {
    if (e.keyCode == 27 && $(this).is(':visible')) { // ESC key
      $(this).closest('.semester').find('a.add').click();
    }
  });
});
