class Integer
  def jagger_to_time
    if self >= 1000000000000 && self < 10000000000000
      return Time.at(self / 1000.0)
    else
      return Time.at(self)
    end
  end
end