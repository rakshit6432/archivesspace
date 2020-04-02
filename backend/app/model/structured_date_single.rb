class StructuredDateSingle < Sequel::Model(:structured_date_single)
  include ASModel

  corresponds_to JSONModel(:structured_date_single)

  set_model_scope :global

  def after_create
    update_associated_name_forms
  end

  def after_update
    update_associated_name_forms
  end

  # ANW-429: This code (and it's sister method in StructuredDateRange#update_associated_name_forms) runs when a single or ranged date is updated.
  # If the date is attached to a date of existence for an agent, that agent's display name is pulled and updated with data from this date.
  # It would be really nice to do this at the JSONModel layer instead of with Sequel calls like here below... But I couldn't figure out a way to do that.
  # As far as I can tell, there isn't a way to get the ID of the parent date label object from the AutoGenerator in the Name classes.
  # Also tried getting this data from a after_save/update hook in the parent label class, but these date subrecords were not accessible -- it looks like they weren't created yet from the context of inside that hook.
  # TODO: There are some places where JSONModel calls are used. Maybe this is unnecessary -- I wanted to rely on Sequel as little as possible so it's only used for queries, not updates.

  def update_associated_name_forms

    sdl = StructuredDateLabel.first(:id => self.structured_date_label_id)

    # See if label object is attached directly to an agent, which indicates a date of existence
    if sdl.agent_person_id
      agent_id = sdl.agent_person_id
      agent_name = NamePerson.first(:agent_person_id => agent_id, :is_display_name => 1) 
      name_json = NamePerson.to_jsonmodel(agent_name.id)

    elsif sdl.agent_family_id
      agent_id = sdl.agent_family_id
      agent_name = NameFamily.first(:agent_family_id => agent_id, :is_display_name => 1) 
      name_json = NameFamily.to_jsonmodel(agent_name.id)

    elsif sdl.agent_corporate_entity_id
      agent_id = sdl.agent_corporate_entity_id
      agent_name = NameCorporateEntity.first(:agent_corporate_entity_id => agent_id, :is_display_name => 1) 
      name_json = NameCorporateEntity.to_jsonmodel(agent_name.id)

    elsif sdl.agent_software_id
      agent_id = sdl.agent_software_id
      agent_name = NameSoftware.first(:agent_software_id => agent_id, :is_display_name => 1) 
      name_json = NameSoftware.to_jsonmodel(agent_name.id)
    end

    # This code runs if we find an agent display name directly attached to this date subrecord. We'll then generate the string for the name, and update it. 
    if name_json
      sds_json = StructuredDateSingle.to_jsonmodel(self.id)

      name_json['sort_name_date_string'] = stringify_structured_dates_for_sort_name(sds_json)

      agent_name.update_from_json(name_json)
    end
  end

  def stringify_structured_dates_for_sort_name(json)
    date_string = ""

    std = json['date_standardized']
    exp = json['date_expression']

    std = std.split("-")[0] unless std.nil?

    # either the standardized date or expression should have some content
    if std
      date_string = std
    elsif exp
      date_string = exp
    end

    return date_string
  end
end

