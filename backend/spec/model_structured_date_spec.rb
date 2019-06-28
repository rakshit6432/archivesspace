require_relative 'spec_helper'

describe 'Structured Date model' do
  before :all do
    JSONModel::strict_mode(false)
  end

  it "creates valid label record with single date" do
    sd = build(:json_structured_date_label)
    errs = JSONModel::Validations.check_structured_date_label(sd)

    expect(errs.length > 0).to eq(false)
  end

  it "creates valid label record with range date" do
    sd = build(:json_structured_date_label_range)
    errs = JSONModel::Validations.check_structured_date_label(sd)

    expect(errs.length > 0).to eq(false)
  end

  it "label record is invalid without a date subrecord" do
    sd = build(:json_structured_date_label, :structured_date_single => nil)
    errs = JSONModel::Validations.check_structured_date_label(sd)

    expect(errs.length > 0).to eq(true)

  end

  it "label record is invalid if it has a single subrecord but type == range" do
    sd = build(:json_structured_date_label, :date_type_enum => "range")
    errs = JSONModel::Validations.check_structured_date_label(sd)

    expect(errs.length > 0).to eq(true)

  end

  it "label record is invalid if it has a range subrecord but type == single" do
    sd = build(:json_structured_date_label_range, :date_type_enum => "single")
    errs = JSONModel::Validations.check_structured_date_label(sd)

    expect(errs.length > 0).to eq(true)

  end

  it "label record is invalid both single and range subrecords are defined" do
    sdr = build(:json_structured_date_range)
    sd = build(:json_structured_date_label, :structured_date_range => sdr)
    errs = JSONModel::Validations.check_structured_date_label(sd)

    expect(errs.length > 0).to eq(true)

  end

  it "single dates are invalid unless a date is present in the subrecord" do
    sds = build(:json_structured_date_single, :date_expression => nil, :date_standardized => nil)
  
    errs = JSONModel::Validations.check_structured_date_single(sds)
    expect(errs.length > 0).to eq(true)
  end

  it "single dates are invalid if standardized dates do not fit format" do
    sds = build(:json_structured_date_single, :date_standardized => "Dec 12, 1928")
  
    errs = JSONModel::Validations.check_structured_date_single(sds)
    expect(errs.length > 0).to eq(true)
  end

  it "single dates are invalid if role is missing" do
    sds = build(:json_structured_date_single, :date_role_enum => nil)
  
    errs = JSONModel::Validations.check_structured_date_single(sds)
    expect(errs.length > 0).to eq(true)
  end

  it "range dates are invalid if begin standardized dates do not fit format" do
    sdr = build(:json_structured_date_range, :begin_date_standardized => "Dec 12, 1928")
  
    errs = JSONModel::Validations.check_structured_date_range(sdr)
    expect(errs.length > 0).to eq(true)
  end

  it "range dates are invalid if end standardized dates do not fit format" do
    sdr = build(:json_structured_date_range, :end_date_standardized => "Dec 12, 1928")
  
    errs = JSONModel::Validations.check_structured_date_range(sdr)
    expect(errs.length > 0).to eq(true)
  end

  it "range dates are valid with just a begin date expression" do
    sdr = build(:json_structured_date_range, 
        :begin_date_expression => "Dec 12, 1928", 
        :begin_date_standardized => nil, 
        :end_date_expression => nil, 
        :end_date_standardized => nil)
  
    errs = JSONModel::Validations.check_structured_date_range(sdr)
    expect(errs.length > 0).to eq(false)
  end

  it "range dates are invalid if end expression present with no begin" do
    sdr = build(:json_structured_date_range, 
        :begin_date_expression => nil, 
        :begin_date_standardized => nil, 
        :end_date_expression => "Foo", 
        :end_date_standardized => nil)
  
    errs = JSONModel::Validations.check_structured_date_range(sdr)
    expect(errs.length > 0).to eq(true)
  end

  it "range dates are invalid if end standardized date present with no begin" do
    sdr = build(:json_structured_date_range, 
        :begin_date_expression => nil, 
        :begin_date_standardized => nil, 
        :end_date_expression => nil, 
        :end_date_standardized => "2001-01-01")
  
    errs = JSONModel::Validations.check_structured_date_range(sdr)
    expect(errs.length > 0).to eq(true)
  end

  it "range dates are invalid if begin standardized date present with no end" do
    sdr = build(:json_structured_date_range, 
        :begin_date_expression => nil, 
        :begin_date_standardized => "2001-01-01", 
        :end_date_expression => nil, 
        :end_date_standardized => nil)
  
    errs = JSONModel::Validations.check_structured_date_range(sdr)
    expect(errs.length > 0).to eq(true)
  end

  it "range dates are invalid end date is after begin" do
    sdr = build(:json_structured_date_range, 
        :begin_date_expression => nil, 
        :begin_date_standardized => "2001-01-02", 
        :end_date_expression => nil, 
        :end_date_standardized => "2001-01-01")
  
    errs = JSONModel::Validations.check_structured_date_range(sdr)
    expect(errs.length > 0).to eq(true)
  end
end
