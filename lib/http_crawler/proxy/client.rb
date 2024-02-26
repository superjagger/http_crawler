module HttpCrawler
  module Proxy
    class Client < HttpCrawler::Client

      class << self

        # 接收格式
        # web_name = "test_proxy_api"
        # 返回 HttpCrawler::Proxy::TestProxyApi::Client 实例
        #
        def for(web_name, *arg)
          "HttpCrawler::Proxy::#{web_name.camelize}::Client".constantize.new(*arg)
        end

      end

      def max_error_num
        @max_error_num ||= 0
      end

    end
  end
end

load File.dirname(__FILE__) + '/test_proxy_api/client.rb'