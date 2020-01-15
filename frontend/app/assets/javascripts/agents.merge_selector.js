//= require form
//= require agents.crud
//= require agents.show
//= require merge_dropdown
//= require subrecord_merge.crud
//= require notes_merge.crud
//= require dates.crud
//= require related_agents.crud
//= require rights_statements.crud
//= require add_event_dropdown
//= require notes_override.crud
//= require embedded_search

$(function() {
  console.log($(this))
  $("button.preview-merge").on("click", function() {
    var $form = $( "form:eq( 4 )" )
    AS.openCustomModal("mergePreviewModal", $(this).text(), "<div class='alert alert-info'>Loading...</div>", {}, this);
    $.ajax({
      url: $form.attr("action") + "?dry_run=true",
      type: "POST",
      data:  $form.serializeArray(),
      success: function (html) {
        $(".alert", "#mergePreviewModal").replaceWith(AS.renderTemplate("modal_quick_template", {message: html}));
        $(window).trigger("resize");
      }
    });
  });

  $("button.do-merge").on("click", function() {
    $("form:eq( 4 )").submit();
  });

  // run target side code to color replaceable items
  $(function() {
    // disable reorder handle, but only for target side
    $('.merge-group-left .drag-handle').removeClass('drag-handle');

    // set first element of all target lists to color coordinate
    $('.merge-group-left li:nth-of-type(1)').addClass('merge-group-first');
  });

  // run victim side code to color replaceable items
  $(function() {

    var enableReplace = function(items) {
      items.each(function() {
        $(this).addClass('merge-group-first');
        $(this).find('.replace-control').show();
      });
    };

    var disableReplace = function(items) {
      items.each(function() {
        $(this).removeClass('merge-group-first');
        $(this).find('.replace-control').hide();
      });
    };

    // for victim lists, only first item in list should have replace boxes and colors
    disableReplace($('.merge-group-right li'));
    enableReplace($('.merge-group-right .merge-replace-enabled li:nth-of-type(1)'));

    $('.merge-group-right .merge-replace-enabled .subrecord-form-list').on("mergesubformchanged.aspace", function(event) {
      disableReplace($(this).find('li'));
      enableReplace($(this).find('li:nth-of-type(1)'));
    });
  });


  // run code to match up section heights
  $(function() {
    // this is basically a rewrite of JQuery's matchHeight() function. Not sure why it's not working in some cases
    var equalHeightId = function(div1, div2) {
      var div1h = div1.height();
      var div2h = div2.height();

      if (div1h > div2h) {
        div2.height(div1h);
      } 
      else {
        div1.height(div2h);
      }
    };

    equalHeightId($('#title_left'), 
                  $('#title_right'));

    equalHeightId($('#basic_information_left'), 
                  $('#basic_information_right'));

    equalHeightId($('#agent_agent_record_identifier_left'), 
                  $('#agent_agent_record_identifier_right'));

    equalHeightId($('#agent_agent_record_control_left'), 
                  $('#agent_agent_record_control_right'));

    equalHeightId($('#agent_agent_other_agency_code_left'), 
                  $('#agent_agent_other_agency_code_right'));

    equalHeightId($('#agent_agent_conventions_declaration_left'), 
                  $('#agent_agent_conventions_declaration_right'));

    equalHeightId($('#agent_agent_maintenance_history_left'), 
                  $('#agent_agent_maintenance_history_right'));

    equalHeightId($('#agent_agent_source_left'), 
                  $('#agent_agent_source_right'));

    equalHeightId($('#agent_agent_alternate_set_left'), 
                  $('#agent_agent_alternate_set_right'));

    equalHeightId($('#agent_agent_identifier_left'), 
                  $('#agent_agent_identifier_right'));

    equalHeightId($('#agent_names_left'), 
                  $('#agent_names_right'));

    equalHeightId($('#agent_dates_of_existence_left'), 
                  $('#agent_dates_of_existence_right'));

    equalHeightId($('#agent_agent_gender_left'), 
                  $('#agent_agent_gender_right'));

    equalHeightId($('#agent_agent_place_left'), 
                  $('#agent_agent_place_right'));

    equalHeightId($('#agent_agent_occupation_left'), 
                  $('#agent_agent_occupation_right'));

    equalHeightId($('#agent_agent_function_left'), 
                  $('#agent_agent_function_right'));

    equalHeightId($('#agent_agent_topic_left'), 
                  $('#agent_agent_topic_right'));

    equalHeightId($('#agent_used_language_left'), 
                  $('#agent_used_language_right'));

    equalHeightId($('#agent_contact_details_left'), 
                  $('#agent_contact_details_right'));

    equalHeightId($('#agent_notes_left'), 
                  $('#agent_notes_right'));

    equalHeightId($('#agent_related_agents_left'), 
                  $('#agent_related_agents_right'));

    equalHeightId($('#agent_external_documents_left'), 
                  $('#agent_external_documents_right'));

    equalHeightId($('#agent_agent_resources_left'), 
                  $('#agent_agent_resources_right'));

  });
});
