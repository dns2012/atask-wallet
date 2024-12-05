stocks = [
  { name: "Astra Agro Lestari Tbk.", description: "Stock of Astra Agro Lestari Tbk.", code: "AALI", available_lot: 100, current_price_per_lot: 1000 },
  { name: "Mahaka Media Tbk.", description: "Stock of Mahaka Media Tbk.", code: "ABBA", available_lot: 150, current_price_per_lot: 1500 },
  { name: "Asuransi Bina Dana Arta Tbk.", description: "Stock of Asuransi Bina Dana Arta Tbk.", code: "ABDA", available_lot: 200, current_price_per_lot: 2000 },
  { name: "Aspirasi Hidup Indonesia Tbk.", description: "Stock of Aspirasi Hidup Indonesia Tbk.", code: "ABMM", available_lot: 250, current_price_per_lot: 2500 },
  { name: "Acset Indonusa Tbk.", description: "Stock of Acset Indonusa Tbk.", code: "ACST", available_lot: 300, current_price_per_lot: 3000 }
]

stocks.each do |stock_attributes|
  AtaskStock::Models::Stock.find_or_create_by!(code: stock_attributes[:code]) do |stock|
    stock.name = stock_attributes[:name]
    stock.description = stock_attributes[:description]
    stock.available_lot = stock_attributes[:available_lot]
    stock.current_price_per_lot = stock_attributes[:current_price_per_lot]
  end
end
