class Object
  def jagger_blank(&block)
    if (self.blank?)
      nil
    else
      if block_given?
        block.call self
      else
        self
      end
    end
  end
end
