
module HttpCrawler
  # 通用的错误类型
  class Error < StandardError; end

  # 验证码错误
  class VerificationError < Error; end

end