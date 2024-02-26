# 示例：测试API


### 通过对象调用

```ruby
client = HttpCrawler::Proxy::TestProxyApi::Client.new
client.get_proxy  # 获取代理
```

### 通过别名调用
```ruby
client = HttpCrawler::Proxy.for("test_proxy_api") # 
client.get_proxy   # 获取代理
```

### response.rb
用于维护不同响应结果的处理方法