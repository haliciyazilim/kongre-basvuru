class Hash
  def retrieve(*keys)
    new_hash = Hash.new
    self.keys.each do |key|
      if keys.include? key
        new_hash[key] = self[key]
      end
    end
    new_hash
  end
end