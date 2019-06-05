Sequel.extension :inflector
Sequel.extension :pagination


module MigrationUtils
  def self.shorten_table(name)
    name.to_s.split("_").map {|s| s[0...3]}.join("_")
  end
end


module EachByPage

  def each_by_page(page_size = 1000)
    self.extension(:pagination).each_page(page_size) do |page_ds|
      page_ds.each do |row|
        yield(row)
      end
    end
  end

end


module Sequel
  class Dataset
    include EachByPage
  end
end


def blobify(db, s)
  (db.database_type == :derby) ? s.to_sequel_blob : s
end


def create_editable_enum(name, values, default = nil, opts = {})
  create_enum(name, values, default, true, opts)
end

def get_enum_value_id(enum_name, enum_value)
  enum_id = self[:enumeration].filter(:name => enum_name).select(:id).first[:id]

  if enum_id
    enum_value_id = self[:enumeration_value].filter(:value => enum_value, 
                                                    :enumeration_id => enum_id)
                                            .select(:id)
                                            .first[:id]

    enum_value_id = -1 unless enum_value_id
    return enum_value_id
  else
    return -1
  end
end

def create_enum(name, values, default = nil, editable = false, opts = {})
  id = self[:enumeration].insert(:name => name,
                                 :json_schema_version => 1,
                                 :editable => editable ? 1 : 0,
                                 :create_time => Time.now,
                                 :system_mtime => Time.now,
                                 :user_mtime => Time.now)

  id_of_default = nil

  readonly_values = Array(opts[:readonly_values])
  # we updated the schema to include ordering for enum values. so, we will need
  # those for future adding enums
  include_position = self.schema(:enumeration_value).flatten.include?(:position)
  
  values.each_with_index do |value, i|
    props = { :enumeration_id => id, :value => value, :readonly => readonly_values.include?(value) ? 1 : 0 } 
    props[:position] = i if include_position

    id_of_value =  self[:enumeration_value].insert(props)
                                       
    id_of_default = id_of_value if value === default
  end

  if !id_of_default.nil?
    self[:enumeration].where(:id => id).update(:default_value => id_of_default)
  end
end

def fits_structured_date_format?(expr)
  matches_y           = (expr =~ /^[\d]{1}$/) == 0
  matches_y_mm        = (expr =~ /^[\d]{1}-[\d]{2}$/) == 0
  matches_yy          = (expr =~ /^[\d]{2}$/) == 0
  matches_yy_mm       = (expr =~ /^[\d]{2}-[\d]{2}$/) == 0
  matches_yyy         = (expr =~ /^[\d]{3}$/) == 0
  matches_yyy_mm      = (expr =~ /^[\d]{3}-[\d]{2}$/) == 0
  matches_yyyy        = (expr =~ /^[\d]{4}$/) == 0
  matches_yyyy_mm     = (expr =~ /^[\d]{4}-[\d]{2}$/) == 0
  matches_yyyy_mm_dd  = (expr =~ /^[\d]{4}-[\d]{2}-[\d]{2}$/) == 0
  matches_mm_yyyy     = (expr =~ /^[\d]{2}-[\d]{4}$/) == 0
  matches_mm_dd_yyyy = (expr =~ /^[\d]{4}-[\d]{2}-[\d]{2}$/) == 0

  return matches_yyyy || matches_yyyy_mm || matches_yyyy_mm_dd || matches_yyy || matches_yy || matches_y || matches_yyy_mm || matches_yy_mm || matches_y_mm || matches_mm_yyyy || matches_mm_dd_yyyy
end

def create_structured_dates(r, std_begin, std_end, rel)
  #look up the right value of the role and type from the enum values table
  role_id_begin = get_enum_value_id("date_role_enum", "begin")
  role_id_end = get_enum_value_id("date_role_enum", "end")
  type_id_single = get_enum_value_id("date_type_enum", "single")
  type_id_range = get_enum_value_id("date_type_enum", "range")

  type_id = std_end ? type_id_range : type_id_single

  l = self[:structured_date_label].insert(:date_label_id => r[:label_id],
                                          :date_type_enum_id => type_id,
                                          :create_time => Time.now,
                                          :system_mtime => Time.now,
                                          :user_mtime => Time.now)

  # in all cases, create a begin date record for the expression if one is present
  if r[:expression]
    self[:structured_date].insert(:date_role_enum_id => role_id_begin,
                                  :date_expression => r[:expression],
                                  :structured_date_label_id => l,
                                  :create_time => Time.now,
                                  :system_mtime => Time.now,
                                  :user_mtime => Time.now)
  end

  # create standardized date record for begin if present
  if std_begin
    self[:structured_date].insert(:date_role_enum_id => role_id_begin,
                                  :date_standardized => std_begin,
                                  :date_certainty_id => r[:certainty_id],
                                  :date_era_id => r[:era_id],
                                  :date_calendar_id => r[:calendar_id],
                                  :structured_date_label_id => l,
                                  :create_time => Time.now,
                                  :system_mtime => Time.now,
                                  :user_mtime => Time.now)
  end

  # create standardized date record for if present
  if std_end
    self[:structured_date].insert(:date_role_enum_id => role_id_end,
                                  :date_standardized => std_end,
                                  :date_certainty_id => r[:certainty_id],
                                  :date_era_id => r[:era_id],
                                  :date_calendar_id => r[:calendar_id],
                                  :structured_date_label_id => l,
                                  :create_time => Time.now,
                                  :system_mtime => Time.now,
                                  :user_mtime => Time.now)
  end

  # create records in join tables
  if rel == :agent_person_id || rel == :agent_family_id || rel == :agent_corporate_entity_id || rel == :agent_software_id

      self[:structured_date_agent_rlshp].insert(rel => r[rel],
                                                :structured_date_label_id => l,
                                                :create_time => Time.now,
                                                :system_mtime => Time.now,
                                                :user_mtime => Time.now)

  elsif rel == :name_person_id || rel == :name_family_id || rel == :name_corporate_entity_id || rel == :name_software_id

     self[:structured_date_name_rlshp].insert(rel => r[rel],
                              :structured_date_label_id => l,
                              :create_time => Time.now,
                              :system_mtime => Time.now,
                              :user_mtime => Time.now)

  elsif rel == :related_agents_rlshp_id

     self[:structured_date_related_agents_rlshp].insert(rel => r[rel],
                              :structured_date_label_id => l,
                              :create_time => Time.now,
                              :system_mtime => Time.now,
                              :user_mtime => Time.now)
  end
end
