class ActiveSupport::TimeZone
  @country_zones = ThreadSafe::Cache.new

  def self.country_zones(country_code)
    code = country_code.to_s.upcase
    @country_zones[code] ||=
        TZInfo::Country.get(code).zone_identifiers.select do |tz_id|
          MAPPING.key(tz_id)
        end.map do |tz_id|
          self[MAPPING.key(tz_id)]
        end
  end
end