# 示例：httpbin爬虫维护


### 通过对象调用

```ruby
client = HttpCrawler::Client::Httpbin::Client.new
client.index  # 抓取首页
```

### 通过别名调用
```ruby
client = HttpCrawler::Client.for("baidu") # 
client.index   # 抓取首页
```


### response.rb
用于维护不同响应结果的处理方法