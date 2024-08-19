require 'rails_helper'

RSpec.describe Document, type: :model do
  subject { create(:document) }

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without a name" do
    subject.name = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a upload" do
    subject.upload = nil
    expect(subject).to_not be_valid
  end
end
