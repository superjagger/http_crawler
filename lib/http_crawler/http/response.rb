module HTTP
  class Response

    # 解压并转码 body 数据
    def decoding_body
      return @decoding_body if defined? @decoding_body

      # 数据解压
      case self.headers['Content-Encoding']
      when 'gzip' then
        @decoding_body = Zlib::GzipReader.new(StringIO.new(self.body.to_s), encoding: "ASCII-8BIT").read
      when 'br'
        @decoding_body = Brotli.inflate(self.body.to_s)
        # when 'deflate'
        #   # 可能错误代码 暂时没解决 deflate 编码格式
        #   @decoding_body = Zlib::Inflate.inflate(self.body.to_s)
      else
        @decoding_body = self.body.to_s
      end

      # 判断解压后数据编码格式

      # 从header取编码格式, self.headers['Content-Type'].to_s 是为了解决可能出现self.headers['Content-Type']是数组的情况
      encoding = self.headers['Content-Type'].to_s[/charset=([^, ;"]*)/, 1] if self.headers['Content-Type']

      # 从html中的 charset 取编码格式
      # 不能使用，因为 decoding_body 还未转码，直接使用可能报错: ArgumentError: invalid byte sequence in UTF-8
      # encoding = @decoding_body[/charset=([^, ;"]*)/, 1] unless encoding

      # 通过 CharDet 判断编码格式
      encoding = CharDet.detect(@decoding_body)["encoding"] unless encoding


      # 进行转码
      begin
        @decoding_body.force_encoding(encoding).encode!('utf-8',invalid: :replace) if encoding && encoding != @decoding_body.encoding
      rescue => e
        # 转码错误后再次使用 CharDet 判断编码格式后进行转码
        cd = CharDet.detect(@decoding_body)["encoding"]
        if (cd && cd != encoding)
          @decoding_body.force_encoding(cd).encode!('utf-8',invalid: :replace) if encoding != @decoding_body.encoding
        else
          # 还是转码错误则抛出源码转字符串内容
          self.body.to_s
        end
      end

    end

    alias_method :dec, :decoding_body


    # 转换html格式
    # @return [Nokogiri::HTML::Document]
    def html(data = nil)

      if (data.blank? && defined? @html)
        # 如果 data 为空 并且 @html 有值，直接返回 @html
        return @html
      end

      # 如果data为空初始化为 self.dec
      data ||= self.dec
      if (Nokogiri::HTML::Document === data)
        @html = data
      else
        @html = Nokogiri::HTML(data)
      end
      @html

      return @html if defined? @html
      self.html = self.dec
      self.html
    end


    # 转换json格式
    # @return [Hash]
    def json(data = nil)
      if (data.blank? && defined? @json)
        # 如果 data 为空 并且 @json 有值，直接返回 @json
        return @json
      end

      # 如果data为空初始化为 self.dec
      data ||= self.dec
      if (Hash === data)
        @json = data
      else
        @json = JSON.parse(data)
        @json = JSON.parse(@json) if String === @json
      end
      @json
    end

    # 通过readability 解析数据
    # @return [Readability::Document]
    def readability(data = nil)
      if (data.blank? && defined? @readability)
        # 如果 data 为空 并且 @readability 有值，直接返回 @readability
        return @readability
      end

      # 如果data为空初始化为 self.dec
      data ||= self.dec
      if (Readability::Document === data)
        @readability = data
      else
        @readability = Readability::Document.new(data, {do_not_guess_encoding: true})
      end
      @readability
    end

    # 获取正文内容
    def content(data = nil)
      if(data.blank?)
        data = readability.content
      else
        data = readability(data).content
      end
      Nokogiri::HTML(data).text.jagger_del_inter
    end

    # 解析
    # 默认使用 json 的值
    def parsing(parameter = {})
      self.json
    end

    # 获取解析结果
    def results(parameter = {})
      @results ||= parsing(parameter)
    end

    def get_date(str)
      time = Time.now
      case str
      when /^(\d{1,2})小时前$/
        time = time - $1.to_i.hours
      when /^(\d{1,2})月(\d{1,2})日$/
        time = Time.local(time.year, $1.to_i, $2.to_i)
      when /^(\d{4})年(\d{1,2})月(\d{1,2})日$/
        time = Time.local($1.to_i, $2.to_i, $3.to_i)
      when /^(\d{1,2})月(\d{1,2})日[ ]{0,3}(\d{1,2}):(\d{1,2})$/ # 09月30日 12:04
        time = Time.local(time.year, $1.to_i, $2.to_i, $3.to_i, $4.to_i)
      end
      return time
    end


    # 验证码判断
    attr_accessor :validations

    def validations
      @validations ||= []
    end

    # 是否验证码界面
    def validation_page?
      # 正则匹配数组 validations 的所有匹配值
      validations.each do |regular|
        regular_num = decoding_body =~ regular
        if regular_num
          Rails.logger.warn("触发验证信息")
          Rails.logger.warn(decoding_body[regular_num..(regular_num + 300)])
          return true
        end
      end
      return false
    end

  end # class Net::HTTPResponse
end