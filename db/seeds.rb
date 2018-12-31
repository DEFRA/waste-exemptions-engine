# frozen_string_literal: true

require "csv"

print "Seeding exemptions..."

WasteExemptionsEngine::Exemption.destroy_all

if ActiveRecord::Base.connection.instance_values["config"][:adapter].in? %w[postgres postgresql postgis]
  ActiveRecord::Base.connection.reset_pk_sequence! WasteExemptionsEngine::Exemption.table_name
end

csv_text = File.read(WasteExemptionsEngine::Engine.root.join("db", "exemptions.csv"))
csv = CSV.parse(csv_text, headers: true)

csv.each do |row|
  e = WasteExemptionsEngine::Exemption.new
  e.code = row["code"].strip
  e.category = row["category"].strip.parameterize.underscore.to_sym
  e.url = row["url"].strip
  e.summary = row["summary"].strip
  e.description = row["description"].strip
  e.guidance = row["guidance-desc"].strip
  e.save!
end

puts "There are now #{WasteExemptionsEngine::Exemption.count} rows in the exemptions table"
