puts "*"*80
puts "Populating Bakery Cupcake Data"
puts "*"*80

cupcake_count = 50_000
# cupcake_count = 50
cupcake_collection_name = "bakery_cupcakes"
cupcake_collection = Mongoid.default_client.collections.select { |col| col.name == cupcake_collection_name }

if cupcake_collection.present?
  puts "  Dropping existing collection: #{cupcake_collection_name}"
  cupcake_collection.drop
else
  puts "  Initializing collection: #{cupcake_collection_name}"
end

puts "  Seeding #{cupcake_count} Cupcake records"
(0..(cupcake_count - 1)).each { |count| Bakery::CupcakeFactory.call(cc_id: count).save! }

puts ""
puts "End of Cupcake seed"
puts "*"*80
