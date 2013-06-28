 # -*- encoding: utf-8 -*-

 Gem::Specification.new do |gem|
   gem.authors       = ["Ben Mills"]
   gem.email         = ["ben@bmdev.org"]
   gem.description   = %q{Chatbot}
   gem.summary       = %q{Extensible XMPP chatbot}
   gem.homepage      = "https://github.com/benmills/dog"

   gem.files         = `git ls-files`.split($\)
   gem.executables   = ["dog"]
   gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
   gem.name          = "dog-bot"
   gem.require_paths = ["lib"]
   gem.version       = "0.1.3"

   gem.add_dependency "blather", "~> 0.8.0"
   gem.add_dependency "google_image_api", "~> 0.0.1"

   gem.add_development_dependency "rake", "~> 0.9.2.2"
 end
