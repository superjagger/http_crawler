
module HttpCrawler
  module Web
    module Httpbin
      class Client < HttpCrawler::Web::Client

        def init_client
          # 设置整体超时时间 3 秒
          @all_timeout = 3
        end

        def init_uri
          @uri = URI("http://httpbin.org/")
        end

        def ip(parameter = {})
          r = get("ip")
          r.extend(HttpCrawler::Web::Httpbin::Response::Ip)
        end

      end
    end # module Baidu
  end # module Web
end # module HttpCrawler

