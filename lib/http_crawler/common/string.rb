class String
  # 清除干扰数据
  # 清除包含: 空格,回车
  #
  def jagger_del_inter
    self.gsub(/(?:\n|\t|\r| | |　|)/, "")
  end

  # 创建时间: 2019/5/6 18:11
  # 更新时间: 2019/5/6
  # 作者: Jagger
  # 方法名称: jagger_to_array
  # 方法说明: 字符串分割成数组
  # 调用方式: #jagger_to_array
  #
  # @return Array
  #
  def jagger_to_array
    self.split(/(?:\n|\t|\r| | |　)+/)
  end

  # 创建时间: 2020/5/16 15:19
  # 更新时间: 2020/5/16
  # 作者: Jagger
  # 方法名称: jagger_to_i
  # 方法说明: 转整型
  # 调用方式: #jagger_to_i
  #
  # @return 
  #
  def jagger_to_i
    case self
    when /^\d+十亿$/
      num = self[/^(\d+)亿$/, 1].to_i * 1000000000
    when /^\d+亿$/
      num = self[/^(\d+)亿$/, 1].to_i * 100000000
    when /^\d+千万$/
      num = self[/^(\d+)千万$/, 1].to_i * 10000000
    when /^\d+百万$/
      num = self[/^(\d+)百万$/, 1].to_i * 1000000
    when /^\d+十万$/
      num = self[/^(\d+)十万$/, 1].to_i * 100000
    when /^\d+万$/
      num = self[/^(\d+)万$/, 1].to_i * 10000
    when /^\d+千$/
      num = self[/^(\d+)千$/, 1].to_i * 1000
    when /^\d+百$/
      num = self[/^(\d+)百$/, 1].to_i * 100
    when /^\d+十$/
      num = self[/^(\d+)十$/, 1].to_i * 10
    else
      num = self.to_i
    end
    return num
  end

  # 创建时间: 2020/5/16 15:24
  # 更新时间: 2020/5/16
  # 作者: Jagger
  # 方法名称: jagger_to_f
  # 方法说明: 转浮点型
  # 调用方式: #jagger_to_f
  #
  # @return
  #
  def jagger_to_f(parameter = {})
    case self
    when /^\d+十亿$/
      num = self[/^(\d+)亿$/, 1].to_f * 1000000000
    when /^\d+亿$/
      num = self[/^(\d+)亿$/, 1].to_f * 100000000
    when /^\d+千万$/
      num = self[/^(\d+)千万$/, 1].to_f * 10000000
    when /^\d+百万$/
      num = self[/^(\d+)百万$/, 1].to_f * 1000000
    when /^\d+十万$/
      num = self[/^(\d+)十万$/, 1].to_f * 100000
    when /^\d+万$/
      num = self[/^(\d+)万$/, 1].to_f * 10000
    when /^\d+千$/
      num = self[/^(\d+)千$/, 1].to_f * 1000
    when /^\d+百$/
      num = self[/^(\d+)百$/, 1].to_f * 100
    when /^\d+十$/
      num = self[/^(\d+)十$/, 1].to_f * 10
    else
      num = self.to_f
    end
    return num
  end

  
  
  # 转换成时间格式
  def jagger_to_time

    # 然后先遍历所有格式
    # 模糊匹配格式，放前面的优先匹配
    # 如果 "%Y年%m月%d日%H:%M" 在 "%Y年%m月%d日%H:%M:%S" 前面
    # 则 "2018年01月01日12:01:30".jagger_to_time => 2018-01-01 12:01:00 +0800
    # 秒会被去掉
    [
        "%Y年%m月%d日%H:%M:%S",
        "%Y年%m月%d日%H:%M",


        "%Y年%m月%d日 %H:%M:%S",
        "%Y年%m月%d日 %H:%M",

        "%Y-%m-%d %H:%M:%S",
        "%Y-%m-%d %H:%M",

        "%Y-%m-%d%H:%M:%S",
        "%Y-%m-%d%H:%M",

        "%Y%m%d%H%M%S",
        "%Y%m%d%H%M",

        "%m月%d日 %H%M%S",
        "%m月%d日 %H%M",

        "%m月%d日%H%M%S",
        "%m月%d日%H%M",

        "%m月%d日 %H:%M:%S",
        "%m月%d日 %H:%M",

        "%m月%d日%H:%M:%S",
        "%m月%d日%H:%M",

        "%Y-%m-%d",
        "%Y%m%d",

        "%Y年%m月%d日",
        "%Y.%m.%d",

        "%Y年%m月",
        "%m月%d日",

        "%Y/%m/%d",
        "%Y/%m",

    ].each do |v|
      begin
        return Time.strptime(self, v)
      rescue => error

      end
    end

    case self
    when /^\d+分钟前$/
      num = self[/^(\d+)分钟前$/, 1].to_i
      return Time.now - num.minute
    when /^\d+小时前$/
      num = self[/^(\d+)小时前$/, 1].to_i
      return Time.now - num.hour
    when /^\d+天前$/
      num = self[/^(\d+)天前$/, 1].to_i
      return Time.now - num.day
    when /^\d+年前$/
      num = self[/^(\d+)年前$/, 1].to_i
      return Time.now - num.year
    end

    return Time.at(self.to_i / 1000.0) if self.length == 13
    return Time.at(self.to_i) if self.length == 10

    # 最后用 Time通用类型尝试
    return Time.parse(self)
  end

end