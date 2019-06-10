require_relative 'spec_helper'

describe 'Structured Date model' do
  before :all do
    JSONModel::strict_mode(false)
  end

  it "label record is invalid without a date subrecord" do
    expect {
      StructuredDateLabel.create_from_json(
        JSONModel(:structured_date_label).from_hash(
          {:date_label => "other", 
          :date_type_enum => "single"}
          )
        )
    }.to raise_error(JSONModel::ValidationException)

  end

  it "single date labels can have multiple begin subrecords" do
    expect {
      StructuredDateLabel.create_from_json(
        JSONModel(:structured_date_label).from_hash(
          :date_label => "other", 
          :date_type_enum => "single",
          :structured_dates => 
          [
            {:date_role_enum => "begin",
            :date_expression => "Yesterday"},
            {:date_role_enum => "begin",
             :date_standardized => "2019-01-01"}
          ]
        )
      )
    }.to_not raise_error
  end

  it "ranged date labels can have multiple begin subrecords" do
    expect {
      StructuredDateLabel.create_from_json(
        JSONModel(:structured_date_label).from_hash(
          :date_label => "other", 
          :date_type_enum => "range",
          :structured_dates => [
            {:date_role_enum => "begin",
            :date_expression => "Yesterday"},
            {:date_role_enum => "begin",
            :date_standardized => "2019-01-01"},
            {:date_role_enum => "begin",
            :date_standardized => "2019-01-01"},
            {:date_role_enum => "end",
            :date_standardized => "2019-01-02"},
            {:date_role_enum => "end",
            :date_standardized => "2019-01-02"}
            ]
          )
        )
      }.to_not raise_error
  end

  it "single date labels should not have and end date subrecord" do
    expect {
      StructuredDateLabel.create_from_json(
        JSONModel(:structured_date_label).from_hash(
          :date_label => "other", 
          :date_type_enum => "single",
          :structured_dates => [
            {:date_role_enum => "begin",
            :date_expression => "Yesterday"},
            {:date_role_enum => "end",
            :date_standardized => "2019-01-01"},
            ]
          )
        )
    }.to raise_error(JSONModel::ValidationException)
  end

  it "ranged date labels should have begin and end subrecords" do
    expect {
      StructuredDateLabel.create_from_json(
        JSONModel(:structured_date_label).from_hash(
          :date_label => "other", 
          :date_type_enum => "range",
          :structured_dates => [
            {:date_role_enum => "begin",
            :date_expression => "Yesterday"},
            {:date_role_enum => "end",
            :date_expression => "Tomorrow"}
          ]
        )
      )
    }.to_not raise_error
  end

  it "ranged date labels without begin subrecords are invalid" do
    expect {
      StructuredDateLabel.create_from_json(
        JSONModel(:structured_date_label).from_hash(
          :date_label => "other", 
          :date_type_enum => "range",
          :structured_dates => [
            {:date_role_enum => "end",
            :date_expression => "Yesterday"},
            {:date_role_enum => "end",
            :date_expression => "Tomorrow"},
            {:date_role_enum => "end",
            :date_expression => "Tomorrow"}
          ]
        )
      )
    }.to raise_error(JSONModel::ValidationException)
  end

  it "ranged date labels without end subrecords are invalid" do
    expect {
      StructuredDateLabel.create_from_json(
        JSONModel(:structured_date_label).from_hash(
                  :date_label => "other", 
                  :date_type_enum => "range",
                  :structured_dates => [
                    {:date_role_enum => "begin",
                    :date_expression => "Yesterday"},
                    {:date_role_enum => "begin",
                    :date_expression => "Tomorrow"},
                    {:date_role_enum => "begin",
                    :date_expression => "Tomorrow"}
                  ]
                )
              )
            }.to raise_error(JSONModel::ValidationException)
  end

  it "is invalid unless a date is present in the subrecord" do
    expect {
      StructuredDateLabel.create_from_json(
        JSONModel(:structured_date_label).from_hash(
                  :date_label => "other", 
                  :date_type_enum => "single",
                  :structured_dates => [
                    {:date_role_enum => "begin"}
                  ]
                )
              )
            }.to raise_error(JSONModel::ValidationException)
  end

  it "is invalid unless a role is present in the subrecord" do
    expect {
      StructuredDateLabel.create_from_json(
        JSONModel(:structured_date_label).from_hash(   
          :date_label => "other", 
          :date_type_enum => "single",
          :structured_dates => [
            {:date_expression => "begin"}
          ]
        )
      )
    }.to raise_error(JSONModel::ValidationException)
  end

  it "is valid if date expression is present in the subrecord" do
    expect {
      StructuredDateLabel.create_from_json(
        JSONModel(:structured_date_label).from_hash(
          :date_label => "other", 
          :date_type_enum => "single",
          :structured_dates => [
            {:date_role_enum => "begin",
            :date_expression => "Yesterday"}
          ]
        )
      )
    }.to_not raise_error
  end

  it "is valid if standardized date is present" do
    expect {
      StructuredDateLabel.create_from_json(
        JSONModel(:structured_date_label).from_hash(
          :date_label => "other", 
          :date_type_enum => "single",
          :structured_dates => [
            {:date_role_enum => "begin",
            :date_standardized => "1995" }
          ]
        )
      )
    }.to_not raise_error
  end

  it "is valid if standardized date is in YYYY-MM format" do
    expect {
      StructuredDateLabel.create_from_json(
        JSONModel(:structured_date_label).from_hash(   
          :date_label => "other", 
          :date_type_enum => "single",
          :structured_dates => [
            {:date_role_enum => "begin",
            :date_standardized => "1995-01" }
          ]
        )
      )
    }.to_not raise_error
  end

  it "is valid if standardized date is in YYYY-MM-DD format" do
    expect {
      StructuredDateLabel.create_from_json(
        JSONModel(:structured_date_label).from_hash(   
          :date_label => "other", 
          :date_type_enum => "single",
          :structured_dates => [
            {:date_role_enum => "begin",
            :date_standardized => "1995-01-03" }
          ]
        )
      )
    }.to_not raise_error
  end


  it "is valid if standardized date is in YYY" do
    expect {
      StructuredDateLabel.create_from_json(
        JSONModel(:structured_date_label).from_hash(   
          :date_label => "other", 
          :date_type_enum => "single",
          :structured_dates => [
            {:date_role_enum => "begin",
            :date_standardized => "199" }
          ]
        )
      )
    }.to_not raise_error
  end

  it "is valid if standardized date is in YY" do
    expect {
      StructuredDateLabel.create_from_json(
        JSONModel(:structured_date_label).from_hash(   
          :date_label => "other", 
          :date_type_enum => "single",
          :structured_dates => [
            {:date_role_enum => "begin",
            :date_standardized => "19" }
          ]
        )
      )
    }.to_not raise_error
  end

  it "is valid if standardized date is in Y" do
    expect {
      StructuredDateLabel.create_from_json(
        JSONModel(:structured_date_label).from_hash(   
          :date_label => "other", 
          :date_type_enum => "single",
          :structured_dates => [
            {:date_role_enum => "begin",
            :date_standardized => "1" }
          ]
        )
      )
    }.to_not raise_error
  end


  it "is valid if standardized date is in YYY-MM" do
    expect {
      StructuredDateLabel.create_from_json(
        JSONModel(:structured_date_label).from_hash(   
          :date_label => "other", 
          :date_type_enum => "single",
          :structured_dates => [
            {:date_role_enum => "begin",
            :date_standardized => "199-12" }
          ]
        )
      )
    }.to_not raise_error
  end

  it "is valid if standardized date is in YY-MM" do
   expect {
      StructuredDateLabel.create_from_json(
        JSONModel(:structured_date_label).from_hash(   
          :date_label => "other", 
          :date_type_enum => "single",
          :structured_dates => [
            {:date_role_enum => "begin",
            :date_standardized => "19-12" }
          ]
        )
      )
    }.to_not raise_error
  end

  it "is valid if standardized date is in Y-MM" do
    expect {
      StructuredDateLabel.create_from_json(
        JSONModel(:structured_date_label).from_hash(   
          :date_label => "other", 
          :date_type_enum => "single",
          :structured_dates => [
            {:date_role_enum => "begin",
            :date_standardized => "1-12" }
          ]
        )
      )
    }.to_not raise_error
  end

  it "is invalid if standardized date is not in YYYY, YYYY-MM, YYYY-MM-DD format" do
    expect {
      StructuredDateLabel.create_from_json(
        JSONModel(:structured_date_label).from_hash(   
          :date_label => "other", 
          :date_type_enum => "single",
          :structured_dates => [
            {:date_role_enum => "begin",
            :date_standardized => "10/12/1993" }
          ]
        )
      )
    }.to raise_error(JSONModel::ValidationException)
  end

  it "is valid if all begin standardized date are chronologically after all end standardized date" do
    expect {
      StructuredDateLabel.create_from_json(
        JSONModel(:structured_date_label).from_hash(
          :date_label => "other", 
          :date_type_enum => "range",
          :structured_dates => [
            {:date_role_enum => "begin",
            :date_standardized => "1995-01-01" },
            {:date_role_enum => "end",
            :date_standardized => "1995-01-03" },
            {:date_role_enum => "begin",
            :date_standardized => "1995-01-01" },
            {:date_role_enum => "end",
            :date_standardized => "1995-01-03" }
          ]
        )
      )
    }.to_not raise_error
  end

  it "is invalid if any begin standardized date is chronologically after end standardized date" do
    expect {
      StructuredDateLabel.create_from_json(
        JSONModel(:structured_date_label).from_hash(
          :date_label => "other", 
          :date_type_enum => "range",
          :structured_dates => [
            {:date_role_enum => "begin",
            :date_standardized => "1995-01-03" },
            {:date_role_enum => "end",
            :date_standardized => "1995-01-01" },
            {:date_role_enum => "begin",
            :date_standardized => "1995-01-03" },
            {:date_role_enum => "end",
            :date_standardized => "1993-01-01" }
          ]
        )
      )
    }.to raise_error(JSONModel::ValidationException)
  end
end
