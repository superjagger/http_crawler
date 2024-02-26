# HttpCrawler

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/http_crawler`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'http_crawler'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install http_crawler


## 示例：百度爬虫维护


### 通过对象调用

```ruby
client = HttpCrawler::Client::Baidu::Client.new
client.index  # 抓取首页
```

### 通过别名调用
```ruby
client = HttpCrawler::Client.for("baidu") # 
client.index   # 抓取首页
```


## 示例：测试API


### 通过对象调用

```ruby
client = HttpCrawler::Proxy::TestProxyApi::Client.new
```

### 通过别名调用
```ruby
client = HttpCrawler::Proxy.for("test_proxy_api") # 
```
