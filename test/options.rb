# Simple stupid factory girl inspired way to easily setup
# option hashes across the tests. 
# 
# Setup like:
# 
# Options.define(:address, :defaults => {
#   :street => "1234 somewhere lane",
#   :city   => "right here town",
#   :zip    => "12345"
# })
# 
# Use like:
# 
# Options(:address)
# 
# Over ride defaults like:
# 
# Options(:address, :street => "4321 somewhere else")
# 
# Provide nil to remove an option:
# 
# Options(:address, :street => nil) => {:city => "right here town", :zip => "12345"}
# 
# Option hashes can have parent hashes:
# 
# Options.define(:new_address, {
#   :parent => :address,
#   :defaults => {
#     :street => "4321 somewhere else",
#     :apartment => "3"
#   }
# })
# Options(:new_address) => {
#   :street => "4321 somewhere else", :apartment => "3", :city => "right here town", :zip => "12345"
# }
# 
# Multiple parents can be combined:
# 
# Options.define(:name, :defaults => {
#   :first_name => "joe", 
#   :last_name => "smith"
# })
# 
# Options.define(:full_address, :parent => [ :name, :address ], :defaults => {
#   :phone_number => "5555555555"
# })
# 
# Options(:full_address) => {
#   :street=>"1234 somewhere lane", :zip=>"12345", :city=>"right here town", 
#   :first_name=>"joe", :phone_number=>"5555555555", :last_name=>"smith"
# }
# 
class Options
  class << self
    def define(name, options={})
      self[name] = (self[options[:parent]] || {}).merge(options[:defaults] || {})
    end

    def [](k)
      return {} if k.nil?

      if k.is_a?(Array)
        Hash[*k.map { |default| 
          self[default].map { |k,v| 
            [k,v] 
          } 
        }.flatten]
      else
        factories[k.to_sym]
      end
    end

    def []=(k,v)
      factories[k.to_sym] = v
    end

    def factories
      @@_factories ||= {}
    end
  end
end

def Options(name, options={})
  Options[name].merge(options).delete_if { |k,v| v.nil? }
end
