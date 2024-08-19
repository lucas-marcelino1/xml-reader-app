FactoryBot.define do
  factory :document do
    name { "Anything" }
    upload { Rack::Test::UploadedFile.new('spec/fixtures/files/example.xml', 'text/xml') }
  end
end