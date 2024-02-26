require_dependency File.dirname(__FILE__) + '/http/response.rb'

module HttpCrawler
  class Client

    class << self

      # 接收格式
      # web_name = "biquge_duquanben"
      # 返回 HttpCrawler::Web::BiqugeDuquanben::Client 实例
      #
      def for(web_name, args = {})
        "HttpCrawler::Web::#{web_name.camelize}::Client".constantize.new(args)
      end

      #
      # 接收格式
      # module_name = "HttpCrawler::Web::BiqugeDuquanben"
      # 返回 HttpCrawler::Web::BiqugeDuquanben::Client 实例
      #
      def for_module(module_name, args = {})
        "#{module_name}::Client".constantize.new(args)
      end

      def for_uri(path)
        self.new(uri: path)
      end
    end

    #
    #  init_uri 如果未初始化@uri,则会报错
    #  继承类需要重定义 init_uri
    #
    def initialize(parameter = {})
      parameter = parameter.symbolize_keys

      parameter[:uri_or_path] = parameter[:url] || parameter[:uri]

      if parameter[:uri_or_path]
        # 如果自定义uri
        raise "Client uri为重复初始化" if uri
        update_uri(parameter[:uri_or_path])
      else
        # 初始化 uri
        init_uri
      end

      # 初始化超时时间
      init_timeout

      # 初始化 ssl 协议
      init_ssl unless uri.blank?

      # 初始化一些 client 自定义参数
      init_client

      self.redirect = true
      # 初始化 代理参数
      @proxy_params = {key: "#{self.class.to_s.gsub(":", "_")}"}
    end

    attr_accessor :max_error_num
    # 最大错误重试次数
    def max_error_num
      @max_error_num ||= 2
    end

    attr_reader :uri
    #  init_uri 如果未初始化@uri,则会报错
    #  继承类需要实现 @uri = URI("http://host")
    #
    def init_uri
      @uri = nil
    end

    # 更新uri
    def update_uri(uri_or_path)
      case uri_or_path
      when URI
        @uri = uri_or_path
      when String
        if uri_or_path =~ /^http/
          @uri = URI(uri_or_path)
        else
          @uri = @uri + uri_or_path
        end
      else
        raise ArgumentError, uri_or_path
      end
      # 初始化 ssl 协议
      self.init_ssl
      self.uri
    end

    attr_accessor :connect_time, :write_time, :read_time, :all_timeout
    # 初始化超时时间
    def init_timeout
      @connect_time = 5
      @write_time = 5
      @read_time = 5
      @all_timeout = nil
    end

    # 初始化 ssl 协议
    def init_ssl
      if (@uri.scheme == "https")
        # ssl 协议
        @ctx = OpenSSL::SSL::SSLContext.new
        @ctx.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
    end

    attr_accessor :redirect

    attr_accessor :header
    # 创建时间: 2019/9/16 17:11
    # 更新时间: 2019/9/16
    # 作者: Jagger
    # 方法名称: header
    # 方法说明: 返回头文件
    # 调用方式: #header
    #
    # @return
    def header
      @header ||= init_header
    end

    # 创建时间: 2019/9/16 17:08
    # 更新时间: 2019/9/16
    # 作者: Jagger
    # 方法名称: init_header
    # 方法说明: 初始化头文件
    # 调用方式: #init_header
    #
    # @return
    #
    def init_header
      @header = {
          "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8",
          "Accept-Encoding": "gzip, br",
          "Accept-Language": "zh-CN,zh;q=0.9",
          "Connection": "keep-alive",
          "Upgrade-Insecure-Requests": "1",
          "User-Agent": " Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.88 Safari/537.36",
      }
    end

    # 创建时间: 2019/9/16 17:08
    # 更新时间: 2019/9/16
    # 作者: Jagger
    # 方法名称: update_header
    # 方法说明: 更新头文件，局部更新
    # 调用方式: #update_header
    #
    # @return 
    #
    def update_header(parameter = {})
      @header = @header.merge(parameter.symbolize_keys)
    end

    # 创建时间: 2019/9/16 17:10
    # 更新时间: 2019/9/16
    # 作者: Jagger
    # 方法名称: replace_header
    # 方法说明: 替换头文件
    # 调用方式: #replace_header
    #
    # @option parameter [Hash]	Hash模式传参
    # @param parameter [Hash] 
    #         {
    #             "": ,  # 参数说明
    #         }
    #
    # @return 
    #
    def replace_header(parameter = {})
      @header = parameter.symbolize_keys
    end


    attr_accessor :cookies
    # 创建时间: 2019/9/16 17:12
    # 更新时间: 2019/9/16
    # 作者: Jagger
    # 方法名称: cookies
    # 方法说明: 返回头文件
    # 调用方式: #cookies
    #
    # @return
    #
    def cookies
      @cookies ||= init_cookies
    end

    # 创建时间: 2019/9/16 17:13
    # 更新时间: 2019/9/16
    # 作者: Jagger
    # 方法名称: init_cookies
    # 方法说明: 初始化头文件
    # 调用方式: #init_cookies
    #
    # @return
    #
    def init_cookies
      @cookies = {}
    end
    
    # 创建时间: 2020/4/7 16:54
    # 更新时间: 2020/4/7
    # 作者: Jagger
    # 方法名称: remove_traces
    # 方法说明: 清除痕迹
    # 调用方式: #remove_traces
    #
    # @return 
    #
    def remove_traces
      @response = nil
      self.init_cookies
    end

    # 创建时间: 2019/9/16 17:13
    # 更新时间: 2019/9/16
    # 作者: Jagger
    # 方法名称: update_cookies
    # 方法说明: 更新cookies，局部替换
    # 调用方式: #update_cookies
    #
    # @option parameter [Hash]	Hash模式传参
    # @param parameter [Hash]
    #         {
    #             "": ,  # 参数说明
    #         }
    #
    # @return
    #
    def update_cookies(parameter = {})
      case parameter
      when String
        hash = {}
        parameter.scan(/([^=]*)=([^;]*);? ?/) do |m|
          hash[:"#{m[0]}"] = m[1]
        end
        self.cookies = cookies.merge(hash.symbolize_keys)
      when Hash
        self.cookies  = cookies.merge(parameter.symbolize_keys)
      else
        raise "cookies传入格式错误"
      end
      self.cookies
    end

    # 创建时间: 2019/9/16 17:20
    # 更新时间: 2019/9/16
    # 作者: Jagger
    # 方法名称: inheritance_cookies
    # 方法说明: 继承上一个请求的set-cookies
    # 调用方式: #inheritance_cookies
    #
    # @return 
    #
    def inheritance_cookies
      @response.cookies.each do |cookie|
        @cookies[:"#{cookie.name}"] = cookie.value
      end unless @response.blank?
      @cookies
    end

    # 创建时间: 2019/9/16 17:19
    # 更新时间: 2019/9/16
    # 作者: Jagger
    # 方法名称: auto_proxy=
    # 方法说明: 自动更新代理设置
    # 调用方式: #auto_proxy=
    #
    # @return
    #
    def auto_proxy=(value)
      Rails.logger.debug "自动更新代理"
      @auto_proxy = value
      update_proxy if (value == true && @proxy.blank?)
    end

    # 创建时间: 2019/9/16 17:23
    # 更新时间: 2019/9/16
    # 作者: Jagger
    # 方法名称: proxy_api
    # 方法说明: 代理使用的api方法名
    # 调用方式: #proxy_api
    #
    # @return
    #
    def proxy_api
      @proxy_api ||= "my"
    end

    # 创建时间: 2019/9/16 17:24
    # 更新时间: 2019/9/16
    # 作者: Jagger
    # 方法名称: proxy_params
    # 方法说明: 调用代理 api使用的参数
    # 调用方式: #proxy_params
    #
    # @return
    def proxy_params
      @proxy_params ||= {key: "default"}
    end

    # 创建时间: 2019/9/16 17:24
    # 更新时间: 2019/9/16
    # 作者: Jagger
    # 方法名称: update_proxy
    # 方法说明: 更新代理，如果未传入代理则自动获取代理
    # 调用方式: #update_proxy
    #
    # @option proxy [Hash]	Hash模式传参
    # @param proxy [Hash]
    #
    # @return
    def update_proxy(proxy = {})
      proxy = proxy.symbolize_keys
      if (proxy.blank?)
        @proxy = get_proxy
      else
        @proxy = proxy
      end
      # @http.update_proxy(proxy)
    end


    # 创建时间: 2019/9/16 17:25
    # 更新时间: 2019/9/16
    # 作者: Jagger
    # 方法名称: update_proxy?
    # 方法说明: 是否自动更新代理，如果自动更新代理 则更新代理返回 true，否则返回false
    # 调用方式: #update_proxy?
    #
    # @return
    def update_proxy?
      if @auto_proxy
        self.update_proxy
        return true
      else
        return false
      end
    end


    # 获取proxy
    # 通过调用 api 获取代理或者通过自定义设置代理
    # 创建时间: 2019/9/16 17:26
    # 更新时间: 2019/9/16
    # 作者: Jagger
    # 方法名称: get_proxy
    # 方法说明: 获取proxy、通过调用 api 获取代理或者通过自定义设置代理
    # 调用方式: #get_proxy
    #
    # @return
    #
    def get_proxy
      proxy_ip = nil
      begin
        Rails.logger.debug("开始获取代理IP")
        proxy_client = HttpCrawler::Proxy.for(proxy_api)
        proxy_r = proxy_client.get_proxy(proxy_params.symbolize_keys)
        proxy_ip = proxy_r.results unless proxy_r.results.blank?
        # 测试本地代理
        # proxy_ip = {p_addr: "127.0.0.1", p_port: 8888} if "production" =! Rails.env
        if proxy_ip.blank?
          Rails.logger.warn "无最新代理等待5秒后重新获取:proxy 为空"
        else
          break
        end
        sleep(5)
      end while true
      proxy_ip = proxy_ip.symbolize_keys

      unless proxy_ip[:p_addr] && proxy_ip[:p_port]
        Rails.logger.warn "无最新代理等待5秒后重新获取:p_addr 或 p_port 为空"
        sleep(5)
        proxy_ip = get_proxy
      end

      Rails.logger.info("当前IP => #{@proxy},切换至代理 => #{proxy_ip}")
      proxy_ip
    end

    attr_accessor :error_urls

    def error_urls
      @error_urls ||= []
    end

    # 添加错误的url地址，表示这里面的url都是异常地址，存的是正则
    def add_error_url(url_string)
      self.error_urls << url_string
    end


    # 初始化init_client参数
    def init_client
      nil
    end

    # 初始化http请求前置条件
    # 创建时间: 2019/9/16 17:27
    # 更新时间: 2019/9/16
    # 作者: Jagger
    # 方法名称: http
    # 方法说明: 创建Http的对象，用于发送请求
    # 调用方式: #http
    #
    # @return HTTP
    def http

      h = HTTP
      # 自动重定向。最大重定向次数 max_hops: 5
      h = h.follow(max_hops: 5) if self.redirect == true

      # 添加代理
      h = h.via(@proxy[:p_addr], @proxy[:p_port].to_i, @proxy[:p_user], @proxy[:p_pass]) unless (@proxy.blank?)

      # 添加头文件
      h = h.headers(header) if header

      # 添加cookies
      h = h.cookies(cookies) if cookies

      # 添加超时时间
      if (@all_timeout)
        # 整体总计超时时间
        h = h.timeout(@all_timeout)
      else
        # 指定每个处理超时时间
        h = h.timeout(connect: @connect_time, write: @write_time, read: @read_time)
      end

      h
    end


    # 创建时间: 2019/9/16 17:27
    # 更新时间: 2019/9/16
    # 作者: Jagger
    # 方法名称: get
    # 方法说明: 发送get请求
    # 调用方式: #get
    #
    # @param path [String]  uri路由地址
    # @param params [Hash]  get参数
    # @param limit [Integer]  错误递归次数
    #
    # @return
    #
    def get(path, params = {}, limit = 3)
      raise "Client uri为空" unless self.uri
      request do
        r = http.get((self.uri + path).to_s, :params => params, :ssl_context => @ctx)
        return r if limit < 0
        r.html.at_xpath("//meta[@http-equiv='Refresh']").jagger_blank do |objc|
          r = self.get(objc.to_html[/(?:URL|url)="?(.*)[^";>]/, 1], params, limit - 1)
        end
        r
      end
    end

    # 创建时间: 2019/9/16 17:29
    # 更新时间: 2019/9/16
    # 作者: Jagger
    # 方法名称: get_uri
    # 方法说明: 直接发送uri的get请求
    # 调用方式: #get_uri
    #
    # @return
    def get_uri
      raise "Client uri为空" unless self.uri
      request {http.get(self.uri.to_s, :ssl_context => @ctx)}
    end

    # 发送 post 请求
    # 创建时间: 2019/9/16 17:29
    # 更新时间: 2019/9/16
    # 作者: Jagger
    # 方法名称: post
    # 方法说明: 发送 post 请求
    # 调用方式: #post
    #
    # @param path [String]  uri路由地址
    # @param params [Hash]  get参数
    # @param format []  请求参数的模式：:params、:form、:body、:json、:form。
    #
    # @return
    def post(path, params = {}, format = :form)
      raise "Client uri为空" unless self.uri
      request {http.post((self.uri + path).to_s, format => params, :ssl_context => @ctx)}
    end

    # 请求的响应
    attr_accessor :response
    protected :response=

    # 出现如果验证码,切换代理
    # 创建时间: 2019/9/16 17:31
    # 更新时间: 2019/9/16
    # 作者: Jagger
    # 方法名称: validation_to_proxy?
    # 方法说明: 验证是否出现验证码，出现如果验证码,切换代理
    # 调用方式: #validation_to_proxy?
    #
    # @param r 默认为本身的 @response
    #
    # @return
    def validation_to_proxy?(r = response)
      # 判断是否出现验证码
      if r.validation_page?
        # 触发验证码切换代理
        self.update_proxy?
        # 成功处理
        return true
      else
        return false
      end
    end

    protected


    # 创建时间: 2019/9/16 18:01
    # 更新时间: 2019/9/16
    # 作者: Jagger
    # 方法名称: request
    # 方法说明: 发送请求，所有请求都会走该方法
    # 调用方式: #request
    #
    # @return
    #
    def request(&block)
      raise "必须定义块" unless block_given?
      n = max_error_num
      begin
        r = block.call
        if r.status.success? || (redirect == false && r.status.redirect?)
          return r
        else
          raise "请求失败(#{r.code}):#{r.uri.to_s}"
        end
      rescue => error
        Rails.logger.debug error.class
        # 错误尝试次数
        if n <= 0
          # 错误尝试次数小于等于0就结束尝试
          raise error
        else
          # 每次错误次数尝试 -1
          n -= 1
          # self.update_proxy?
          retry
        end
      end
    end # def request(&block)
  end
end

