require_relative 'spec_helper'

describe 'Structured Date model' do
  it "label record is invalid without a date subrecord" do
    sdl = StructuredDateLabel.new(:date_label => "other", 
                                  :date_type_enum => "single")

    expect(sdl.valid?).to eq(false)
  end

  it "single date labels can have multiple begin subrecords" do
    sdl = StructuredDateLabel.new(:date_label => "other", 
                                  :date_type_enum => "single",
                                  :structured_dates_attributes => [
                                    {:date_role_enum => "begin",
                                    :date_expression => "Yesterday"},
                                    {:date_role_enum => "begin",
                                    :date_standardized => "2019-01-01"},
                                    ]
                                  )

    sdl.save
  
    expect(sdl.valid?).to eq(true)
  end

  it "ranged date labels can have multiple begin subrecords" do
    sdl = StructuredDateLabel.new(:date_label => "other", 
                                  :date_type_enum => "range",
                                  :structured_dates_attributes => [
                                    {:date_role_enum => "begin",
                                    :date_expression => "Yesterday"},
                                    {:date_role_enum => "begin",
                                    :date_standardized => "2019-01-01"},
                                    {:date_role_enum => "begin",
                                    :date_standardized => "2019-01-01"},
                                    {:date_role_enum => "end",
                                    :date_standardized => "2019-01-01"},
                                    {:date_role_enum => "end",
                                    :date_standardized => "2019-01-01"},
                                    ]
                                  )

    sdl.save
  
    expect(sdl.valid?).to eq(true)
  end

  it "single date labels should not have and end date subrecord" do
    sdl = StructuredDateLabel.new(:date_label => "other", 
                                  :date_type_enum => "single",
                                  :structured_dates_attributes => [
                                    {:date_role_enum => "begin",
                                    :date_expression => "Yesterday"},
                                    {:date_role_enum => "end",
                                    :date_standardized => "2019-01-01"},
                                    ]
                                  )

    expect(sdl.valid?).to eq(false)
  end

  it "ranged date labels should have begin and end subrecords" do
    sdl = StructuredDateLabel.new(:date_label => "other", 
                                  :date_type_enum => "range",
                                  :structured_dates_attributes => [
                                    {:date_role_enum => "begin",
                                    :date_expression => "Yesterday"},
                                    {:date_role_enum => "end",
                                    :date_expression => "Tomorrow"}
                                  ])

    sdl.save
  
    expect(sdl.valid?).to eq(true)
  end

  it "ranged date labels without begin subrecords are invalid" do
    sdl = StructuredDateLabel.new(:date_label => "other", 
                                  :date_type_enum => "range",
                                  :structured_dates_attributes => [
                                    {:date_role_enum => "end",
                                    :date_expression => "Yesterday"},
                                    {:date_role_enum => "end",
                                    :date_expression => "Tomorrow"},
                                    {:date_role_enum => "end",
                                    :date_expression => "Tomorrow"}
                                  ])

    expect(sdl.valid?).to eq(false)
  end

  it "ranged date labels without end subrecords are invalid" do
    sdl = StructuredDateLabel.new(:date_label => "other", 
                                  :date_type_enum => "range",
                                  :structured_dates_attributes => [
                                    {:date_role_enum => "begin",
                                    :date_expression => "Yesterday"},
                                    {:date_role_enum => "begin",
                                    :date_expression => "Tomorrow"},
                                    {:date_role_enum => "begin",
                                    :date_expression => "Tomorrow"}
                                  ])

    expect(sdl.valid?).to eq(false)
  end

  it "is invalid unless a date is present in the subrecord" do
    sdl = StructuredDateLabel.new(:date_label => "other", 
                                  :date_type_enum => "single",
                                  :structured_dates_attributes => [
                                    {:date_role_enum => "begin"}
                                  ])
  
    expect(sdl.valid?).to eq(false)
  end

  it "is invalid unless a role is present in the subrecord" do
    sdl = StructuredDateLabel.new(:date_label => "other", 
                                  :date_type_enum => "single",
                                  :structured_dates_attributes => [
                                    {:date_expression => "begin"}
                                  ])
  
    expect(sdl.valid?).to eq(false)
  end

  it "is valid if date expression is present in the subrecord" do
    sdl = StructuredDateLabel.new(:date_label => "other", 
                                  :date_type_enum => "single",
                                  :structured_dates_attributes => [
                                    {:date_role_enum => "begin",
                                    :date_expression => "Yesterday"}
                                  ])

    sdl.save
  
    expect(sdl.valid?).to eq(true)
  end

  it "is valid if standardized date is present" do
    sdl = StructuredDateLabel.new(:date_label => "other", 
                                  :date_type_enum => "single",
                                  :structured_dates_attributes => [
                                    {:date_role_enum => "begin",
                                    :date_standardized => "1995" }
                                  ])

    sdl.save
  
    expect(sdl.valid?).to eq(true)
  end

  it "is valid if standardized date is in YYYY-MM format" do
    sdl = StructuredDateLabel.new(:date_label => "other", 
                                  :date_type_enum => "single",
                                  :structured_dates_attributes => [
                                    {:date_role_enum => "begin",
                                    :date_standardized => "1995-01" }
                                  ])

    sdl.save
  
    expect(sdl.valid?).to eq(true)
  end

  it "is valid if standardized date is in YYYY-MM-DD format" do
    sdl = StructuredDateLabel.new(:date_label => "other", 
                                  :date_type_enum => "single",
                                  :structured_dates_attributes => [
                                    {:date_role_enum => "begin",
                                    :date_standardized => "1995-01-03" }
                                  ])

    sdl.save
  
    expect(sdl.valid?).to eq(true)
  end

  it "is valid if standardized date is in YYY" do
    sdl = StructuredDateLabel.new(:date_label => "other", 
                                  :date_type_enum => "single",
                                  :structured_dates_attributes => [
                                    {:date_role_enum => "begin",
                                    :date_standardized => "199" }
                                  ])

    sdl.save
  
    expect(sdl.valid?).to eq(true)
  end

  it "is valid if standardized date is in YY" do
    sdl = StructuredDateLabel.new(:date_label => "other", 
                                  :date_type_enum => "single",
                                  :structured_dates_attributes => [
                                    {:date_role_enum => "begin",
                                    :date_standardized => "19" }
                                  ])

    sdl.save
  
    expect(sdl.valid?).to eq(true)
  end

  it "is valid if standardized date is in Y" do
    sdl = StructuredDateLabel.new(:date_label => "other", 
                                  :date_type_enum => "single",
                                  :structured_dates_attributes => [
                                    {:date_role_enum => "begin",
                                    :date_standardized => "1" }
                                  ])

    sdl.save
  
    expect(sdl.valid?).to eq(true)
  end

  it "is valid if standardized date is in YYY-MM" do
    sdl = StructuredDateLabel.new(:date_label => "other", 
                                  :date_type_enum => "single",
                                  :structured_dates_attributes => [
                                    {:date_role_enum => "begin",
                                    :date_standardized => "199-12" }
                                  ])

    sdl.save
  
    expect(sdl.valid?).to eq(true)
  end

  it "is valid if standardized date is in YY-MM" do
    sdl = StructuredDateLabel.new(:date_label => "other", 
                                  :date_type_enum => "single",
                                  :structured_dates_attributes => [
                                    {:date_role_enum => "begin",
                                    :date_standardized => "19-04" }
                                  ])

    sdl.save
  
    expect(sdl.valid?).to eq(true)
  end

  it "is valid if standardized date is in Y-MM" do
    sdl = StructuredDateLabel.new(:date_label => "other", 
                                  :date_type_enum => "single",
                                  :structured_dates_attributes => [
                                    {:date_role_enum => "begin",
                                    :date_standardized => "1-06" }
                                  ])

    sdl.save
  
    expect(sdl.valid?).to eq(true)
  end

  it "is invalid if standardized date is not in YYYY, YYYY-MM, YYYY-MM-DD format" do
    sdl = StructuredDateLabel.new(:date_label => "other", 
                                  :date_type_enum => "single",
                                  :structured_dates_attributes => [
                                    {:date_role_enum => "begin",
                                    :date_standardized => "1995/01/03" }
                                  ])

    expect(sdl.valid?).to eq(false)
  end

  it "is invalid if standardized date is not in YYYY, YYYY-MM, YYYY-MM-DD, etc format" do
    sdl = StructuredDateLabel.new(:date_label => "other", 
                                  :date_type_enum => "single",
                                  :structured_dates_attributes => [
                                    {:date_role_enum => "begin",
                                    :date_standardized => "1995/01/03" }
                                  ])

    expect(sdl.valid?).to eq(false)
  end

  it "is valid if all begin standardized date are chronologically after all end standardized date" do
    sdl = StructuredDateLabel.new(:date_label => "other", 
                                  :date_type_enum => "range",
                                  :structured_dates_attributes => [
                                    {:date_role_enum => "begin",
                                    :date_standardized => "1995-01-03" },
                                    {:date_role_enum => "end",
                                    :date_standardized => "1995-01-01" },
                                    {:date_role_enum => "begin",
                                    :date_standardized => "1995-01-03" },
                                    {:date_role_enum => "end",
                                    :date_standardized => "1995-01-01" }
                                  ])

    expect(sdl.valid?).to eq(false)
  end

  it "is invalid if any begin standardized date is chronologically after end standardized date" do
    sdl = StructuredDateLabel.new(:date_label => "other", 
                                  :date_type_enum => "range",
                                  :structured_dates_attributes => [
                                    {:date_role_enum => "begin",
                                    :date_standardized => "1995-01-03" },
                                    {:date_role_enum => "end",
                                    :date_standardized => "1995-01-01" },
                                    {:date_role_enum => "begin",
                                    :date_standardized => "1995-01-03" },
                                    {:date_role_enum => "end",
                                    :date_standardized => "1993-01-01" }
                                  ])

    expect(sdl.valid?).to eq(false)
  end
end
