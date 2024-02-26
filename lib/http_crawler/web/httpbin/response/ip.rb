# 查询
module HttpCrawler
  module Web
    module Httpbin
      module Response
        module Ip

          # 创建时间: 2019/4/28 21:03
          # 作者: Jagger
          # 方法名称: parsing
          # 方法说明: 解析数据
          # 调用方式: #results
          #
          # @option parameter [Hash]	Hash模式传参
          # @param parameter [Hash]
          #         {
          #             "": ,  # 参数说明
          #         }
          #
          # @return JSON
          #
          def parsing(parameter = {})
            self.json
          end
        end # module Index
      end # module Response
    end # module Baidu
  end # module Web
end # module HttpCrawler


