class StructuredDateRange < Sequel::Model(:structured_date_range)
  include ASModel

  corresponds_to JSONModel(:structured_date_range)

  set_model_scope :global

  def after_create
    update_associated_name_forms
  end

  def after_update
    update_associated_name_forms
  end

  # Look at StructuredDateSingle#update_associated_name_forms for comments about this and it's sister method
  def update_associated_name_forms
    # load name, update JSON, save. Should trigger autogenerate code

    sdl = StructuredDateLabel.first(:id => self.structured_date_label_id)

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

    if name_json
      sdr_json = StructuredDateRange.to_jsonmodel(self.id)
      
      name_json['sort_name_date_string'] = stringify_structured_dates_for_sort_name(sdr_json)

      agent_name.update_from_json(name_json)
    end
  end

  def stringify_structured_dates_for_sort_name(json)
    date_string = ""

    b_std = json['begin_date_standardized']
    b_exp = json['begin_date_expression']
    e_std = json['end_date_standardized']
    e_exp = json['end_date_expression']

    b_std = b_std.split("-")[0] unless b_std.nil?
    e_std = e_std.split("-")[0] unless e_std.nil?

    if b_std && e_std
      date_string = b_std + "-" + e_std
    elsif b_exp && e_exp
      date_string = b_exp + "-" + e_exp
    end

    return date_string
  end
end

