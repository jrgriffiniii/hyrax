require 'noid'

module PSU
  class IdService    
    def self.mint
      label = "ark"
      authority = "42409"
      id = Noid::Minter.new(:template => '.reeddeeddk')
      return "#{label}:/#{authority}/#{id}"
    end    
  end
end
