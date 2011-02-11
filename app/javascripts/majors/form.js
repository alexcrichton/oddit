//= require <jquery>
//= require <jquery/ui>
//= require <jquery/tokeninput>

$(function() {

  // Binding the autocomplete of each class search list
  function bindAutocomplete(el) {
    $(el).tokenInput('/courses/search', {
      classes: {
          tokenList: "token-input-list-facebook",
          token: "token-input-token-facebook",
          tokenDelete: "token-input-delete-token-facebook",
          selectedToken: "token-input-selected-token-facebook",
          highlightedToken: "token-input-highlighted-token-facebook",
          dropdown: "token-input-dropdown-facebook",
          dropdownItem: "token-input-dropdown-item-facebook",
          dropdownItem2: "token-input-dropdown-item2-facebook",
          selectedDropdownItem: "token-input-selected-dropdown-item-facebook",
          inputToken: "token-input-input-token-facebook"
      },
      prePopulate: $(el).data('courses')
    });
  }

  // Adding groups
  $('dl a').click(function() {
    var new_el = $($('#new-group').html().replace(/CHANGEME/g,
        new Date().getTime()));

    $('#groups').prepend(new_el);
    return false;
  });

  // Adding a requirement
  $('fieldset .add-req').live('click', function() {
    var area = $(this).closest('fieldset');
    var selector = '.new-requirement[data-id=' + area.data('id') + ']';
    var new_el = $(selector).html().replace(/ALTERME/g, new Date().getTime());
    new_el = $(new_el);

    area.find('.requirements').append(new_el);
    bindAutocomplete(new_el.find('.autocomplete'));
    return false;
  });

  // Removing courses
  $('.course a').live('click', function() {
    $(this).closest('dd').remove();

    return false;
  });

  // Tokenizers
  $(':text.autocomplete').each(function(_, el) {
    bindAutocomplete(el);
  });
});
