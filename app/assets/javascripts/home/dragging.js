//= require home/updating

(function() {

  var cache = {}, lastXhr;

  window.bindAutocomplete = function(el) {
    $(el).autocomplete({
      select: function(event, ui) {
        if (ui.item) {
          var form = $(event.target).closest('form');
          form.find('#course_id').val(ui.item.id);
        }
      },

      source: function(request, response) {
        var term = request.term;
        if (term in cache) {
          response(cache[term]);
          return;
        }

        lastXhr = $.getJSON('/courses/search', request,
          function(data, status, xhr) {
            cache[term] = data;
            if (xhr === lastXhr) {
              response(data);
            }
          }
        );
      }
    });
  };

  window.makeDraggable = function(el) {
    $(el).draggable({
      connectToSortable: '.courses',
      helper: 'clone',
      cursorAt: {left: 5, top: 5}
    }).disableSelection();
  };

  window.makeSortable = function(el) {
    $(el).sortable({
      receive: function(event) {
        var semester_id, course_id;
        var $el = $(event.originalEvent.target).closest('.course');
        var container = $(event.target);

        if ($el.is('.new')) {
          course_id   = $el.data('id');
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
          course_id = $(event.originalEvent.target).closest('.course').data('id');
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
        var course = $(event.originalEvent.target).closest('.course');
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
})();