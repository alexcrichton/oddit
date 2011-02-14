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

window.makeSortable = function(el) {
  $(el).sortable({
    receive: function(event) {
      var semester_id, course_id;
      var $el = $(event.originalEvent.target).closest('.course');
      var container = $(event.target);

      if ($el.is('.new')) {
        course_id = $el.data('id');
        semester_id = container.closest('.semester').data('id');
        // Dragged from majors to courses
        $el.remove();
        $el = $('<div>').addClass('ui-state-highlight');
        $el.html($('<img>').attr('src', '/images/ajax-small.gif'));
        container.find('.new').replaceWith($el);

        $.ajax({
          url: '/semesters/' + semester_id + '/add',
          type: 'PUT',
          dataType: 'script',
          data: {id: semester_id, course_id: course_id}
        });
      } else {
        // Dragged between two semesters
        course_id = $(event.srcElement).closest('.course').data('id');
        semester_id = $(event.target).closest('.semester').data('id');

        $.ajax({
          url: '/semesters/' + semester_id + '/add',
          type: 'PUT',
          dataType: 'script',
          data: {id: semester_id, course_id: course_id}
        });
      }
    },
    remove: function(event, ui) {
      var course = $(event.srcElement).closest('.course');
      var semester_id = $(event.target).closest('.semester').data('id');

      $.ajax({
        url: '/semesters/' + semester_id + '/remove',
        type: 'DELETE',
        dataType: 'script',
        data: {id: semester_id, course_id: course.data('id')}
      });
    },
    placeholder: 'ui-state-highlight',
    connectWith: '.courses'
  }).disableSelection();
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
  $('#majors .course').draggable({
    connectToSortable: '.courses',
    helper: 'clone',
    cursorAt: {left: 5, top: 5}
  }).disableSelection();

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
});
