require_dependency File.dirname(__FILE__) + '/decryption/node.rb'
module HttpCrawler
  module Decryption
    class << self
      def node(path)
        HttpCrawler::Decryption::Node.decryption(path)
      end
    end
  end
end
