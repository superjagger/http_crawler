require 'json'
require 'digest/md5'
require 'nokogiri'

# 此段代码用于解决 require_dependency 是 rails 的内置方法 必须要先引用 Rails的包才能用的bug
class << self.class
  # require 取别名 require_dependency
  def rename_require
    alias_method :require_dependency, :require
  end
end

unless defined? require_dependency
  # 如果方法不存在则使用别名
  self.class.rename_require
end

# 千万不能使用 require 或者 load,这样的话 Rails 调试的时候就不能热加载了
require_dependency 'http_crawler/errors.rb'
require_dependency 'http_crawler/common.rb'
require_dependency 'http_crawler/client.rb'
require_dependency 'http_crawler/web.rb'
require_dependency 'http_crawler/proxy.rb'
require_dependency 'http_crawler/decryption.rb'

module HttpCrawler
  # Your code goes here...
end
