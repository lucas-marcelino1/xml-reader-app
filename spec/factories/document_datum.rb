FactoryBot.define do
  factory :document_datum do
    document { create(:document) }
    data { { a: 1 } }

    trait :invoice do
      kind { :invoice }
      data {
        {
          "nNF"=> "777778",
          "dest"=> {
            "CNPJ"=>"08370779000149",
            "xNome"=>"XXXAAA CLIENTE"
          },
          "emit"=> {
            "CNPJ"=> "12312352000107",
            "xFant"=> "XXXAAA SISTEMAS",
            "xNome"=> "XXXAAA SISTEMAS DE INFORMATICA LTD"
          },
          "dhEmi"=> "2024-08-12T14:21:59-03:00",
          "serie"=> "5"
        }
      }
    end

    trait :invoice_2 do
      kind { :invoice }
      data {
        {
          "nNF"=> "777778",
          "dest"=> {
            "CNPJ"=>"08370779000149",
            "xNome"=>"A1 CLIENTE"
          },
          "emit"=> {
            "CNPJ"=> "12312352000107",
            "xFant"=> "A1 SISTEMAS",
            "xNome"=> "A1 SISTEMAS DE INFORMATICA LTD"
          },
          "dhEmi"=> "2024-08-12T14:21:59-03:00",
          "serie"=> "5"
        }
      }
    end

    trait :product do
      kind { :product }
      data {
        [
          {
            "NCM"=>"02013000",
            "CFOP"=>"6102",
            "qCom"=>"100.0000",
            "uCom"=>"BALDE",
            "vIPI"=>"250.00",
            "vPIS"=>nil,
            "vICMS"=>"330.00",
            "xProd"=>"Tigrinho Dourado",
            "vUnCom"=>"25.0000000000",
            "vCOFINS"=>nil
          },
          {
            "NCM"=>"34013000",
            "CFOP"=>"6102",
            "qCom"=>"1.0000",
            "uCom"=>"UN",
            "vIPI"=>nil,
            "vPIS"=>nil,
            "vICMS"=>"0.25",
            "xProd"=>"Bailarina Prateada",
            "vUnCom"=>"2.0600000000",
            "vCOFINS"=>nil
          }
        ]
      }
    end

    trait :totalizer do
      kind { :totalizer }
      data {
        {
          "vNF"=>"2752.06",
         "vIPI"=>"250.00",
         "vPIS"=>"0.00",
         "vICMS"=>"330.25",
         "vProd"=>"2502.06",
         "vCOFINS"=>"0.00",
         "vTotTrib"=>"405.00"
        }
      }
    end
  end
end