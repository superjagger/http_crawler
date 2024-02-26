
module HttpCrawler
  module Proxy
    module TestProxyApi
      class Client < HttpCrawler::Proxy::Client



        # 这是个错误代码 http类不能唯一，如果唯一的话高并发情况下会导致前一个请求未结束，下一个请求已经在发送，会出现冲突
        # class << self
        #   def new(*args)
        #     @client ||= super(*args)
        #   end
        # end

        def init_uri
          @uri = URI("http://127.0.0.1:1111/")
        end

        # http://39.108.59.38:7772/Tools/proxyIP.ashx?OrderNumber=ccd4c8912691f28861a1ed048fec88dc&poolIndex=22717&cache=1&qty=2
        def get_proxy(parameter = {})
          r = http.get("/api/get_proxy")
          r.extend(HttpCrawler::Proxy::TestProxyApi::Response::GetProxy)
        end

      end
    end # module BiQuGe_DuQuanBen
  end # module Web
end # module HttpCrawler

load File.dirname(__FILE__) + '/response/get_proxy.rb'
