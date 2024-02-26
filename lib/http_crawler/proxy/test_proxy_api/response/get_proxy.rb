# 查询
module HttpCrawler
  module Proxy
    module TestProxyApi
      module Response
        module GetProxy
          def parsing
            array = []
            decoding_body.scan(/([^\n\r:]*):([^\n\r]*)/) do |v1, v2|
              if v1 =~ /\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/
                array[array.length] = {"p_addr" => v1, "p_port" => v2, "p_user" => nil, "p_pass" => nil}
              else
                Rails.logger.warn decoding_body
              end
            end
            array
          end
        end # module GetProxy
      end # module Response
    end # module Laofu
  end # module Proxy
end # module HttpCrawler


