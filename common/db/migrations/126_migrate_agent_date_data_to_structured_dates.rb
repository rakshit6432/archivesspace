require_relative 'utils'

Sequel.migration do
  up do
    $stderr.puts("Migrating agent dates from 'date' to 'structured_date' table")

    # figure out which FK is defined, so we can create the right relationship later
    self[:date].all.each do |r|
      if r[:agent_person_id]
        rel = :agent_person_id
      elsif r[:agent_family_id]
        rel = :agent_family_id
      elsif r[:agent_corporate_entity_id]
        rel = :agent_corporate_entity_id
      elsif r[:agent_software_id]
        rel = :agent_software_id
      elsif r[:name_person_id]
        rel = :name_person_id
      elsif r[:name_family_id]
        rel = :name_family_id
      elsif r[:name_corporate_entity_id]
        rel = :name_corporate_entity_id
      elsif r[:name_software_id]
        rel = :name_software_id
      elsif r[:related_agents_rlshp_id]
        rel = :related_agents_rlshp_id
      else
        next
      end

      # no begin or end, only expr
      # create begin date with expr
      # Maybe we can parse structured date to try to figure out what's in there?

      # begin only
      if r[:begin] && !r[:end]
        if fits_structured_date_format?(r[:begin])
          std_begin = r[:begin]
        else
          std_begin = nil
        end

        create_structured_dates(r, std_begin, nil, rel)
      end

      # end only
      if !r[:begin] && r[:end]
        if fits_structured_date_format?(r[:end])
          std_end = r[:end]
        else
          std_end = nil
        end

        create_structured_dates(r, nil, std_end, rel)
      end

      # begin and end present
      if r[:begin] && r[:end]
        if fits_structured_date_format?(r[:begin])
          std_begin = r[:begin]
        else
          std_begin = nil
        end

        if fits_structured_date_format?(r[:end])
          std_end = r[:end]
        else
          std_end = nil
        end

        create_structured_dates(r, std_begin, std_end, rel)
      end # of if
    end # of loop
  end # of up
end # of migration
