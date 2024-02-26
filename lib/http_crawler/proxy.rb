module HttpCrawler
  module Proxy
    class << self

      # 接收格式
      # web_name = "test_proxy_api"
      # 返回 HttpCrawler::Proxy::TestProxyApi::Client 实例
      #
      def for(web_name, *arg)
        "HttpCrawler::Proxy::#{web_name.camelize}::Client".constantize.new(*arg)
      end
    end
  end
end

require_dependency File.dirname(__FILE__) + '/proxy/client.rb'