require 'net/http'
require 'api-auth'

@access_id = 'd09a632b366b'
@secret_key = '1UoH+ZBR4xazJPb4M/mm5JRWRXsyws9p4jP+UH3c0BGw28PfuBjIYazt0VpX8p2YYD/5nzQSJxbnkTYt3XipKA=='

headers = {
  'Accept' => "Accept: application/rs.theleadershipcircle.com; version=1", 
  'Content-Type' =>'application/json'
}

# pobieranie wersji API
# base_uri = URI('http://localhost:3000/version')

# pobieranie info o produkcie
base_uri = URI('http://localhost:3000/products/2')

@request = Net::HTTP::Get.new(base_uri.path,
  'Accept' => "Accept: application/agh.edu.pl; version=1"
)

# pobieranie listy produktów
# base_uri = URI('http://localhost:3000/products')

# @request = Net::HTTP::Get.new(base_uri.path,
#   'Accept' => "Accept: application/agh.edu.pl; version=1"
# )

# wykonanie update produktu

# base_uri = URI('http://localhost:3000/products/2.json')

# @request = Net::HTTP::Patch.new(base_uri.path, headers)
# data = { product: { 
#     name: 'updated product' 
#   }
# }
# @request.body = data.to_json

@signed_request = ApiAuth.sign!(@request, @access_id, @secret_key)

puts "**** TEST RESPONSE\n\n"
res = Net::HTTP.start(base_uri.hostname, base_uri.port) {|http|
  puts http.request(@signed_request).body
}
puts "\n**** END OF TEST RESPONSE"