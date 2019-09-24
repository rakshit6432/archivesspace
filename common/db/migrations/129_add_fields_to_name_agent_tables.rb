require_relative 'utils'

Sequel.migration do

  up do
    alter_table(:name_family) do
      add_column(:family_type, String)
      add_column(:location, String)
    end

    alter_table(:name_corporate_entity) do
      add_column(:location, String)
      add_column(:jurisdiction, Integer, :default => 0)
      add_column(:conference_meeting, Integer, :default => 0)
    end
  end
end