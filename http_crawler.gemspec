# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "http_crawler/version"

Gem::Specification.new do |spec|
  spec.name          = "http_crawler"
  spec.version       = HttpCrawler::VERSION
  spec.authors       = ["jagger"]
  spec.email         = ["1336098842@qq.com"]

  spec.summary       = %q{http 爬虫。}
  spec.description   = %q{初级开发工程师，基于 http 写的爬虫扩展包。请不要随意下载里面有很多坑。}
  spec.homepage      = "https://rubygems.org/gems/http_crawler"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.files += Dir['lib/**/*.rb']

  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rspec", "~> 3.8"
  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency "http", "~> 4.4", ">= 4.4.1"
  spec.add_dependency "rchardet", "~> 1.8"
  spec.add_dependency "nokogiri", "~> 1.8"
  spec.add_dependency "ruby-readability", "~> 0.7.0"
  spec.add_dependency "brotli", "~> 0.2.1"
end
