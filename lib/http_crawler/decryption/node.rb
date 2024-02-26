module HttpCrawler
  module Decryption
    module Node

      # def method_missing(methodname, *args)
        # http_crawler = HttpCrawler::Client.new(url: "http://127.0.0.1:8080/");
        # r = http_crawler.get("/#{self.to_s.gsub("HttpCrawler::Decryption::Node::", "").underscore}/#{methodname}.js");
        # r.dec
      # end

      class << self
        def decryption(path)
          path = path + ".js" unless path =~ /\.js$/
          # p path
          http_crawler = HttpCrawler::Client.new(url: "http://127.0.0.1:9080/");
          r = http_crawler.get(path);
          r.dec
        end
      end
    end
  end
end
