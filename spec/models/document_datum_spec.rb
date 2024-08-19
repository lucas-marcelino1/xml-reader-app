require 'rails_helper'

RSpec.describe DocumentDatum, type: :model do
  subject { build(:document_datum, :invoice) }

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without document" do
    subject.document = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a kind" do
    subject.kind = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without data" do
    subject.data = nil
    expect(subject).to_not be_valid
  end
end
