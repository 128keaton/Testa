Pod::Spec.new do |spec|
  spec.name = "Testa"
  spec.version = "0.0.1"
  spec.summary = "Simple framework to run tests on an iOS device."
  spec.homepage = "https://github.com/128keaton/Testa"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Keaton Burleson" => 'keaton.burleson@me.com' }
  spec.social_media_url = "http://twitter.com/128keaton"

  spec.platform = :ios, "8.0"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/128keaton/Testa.git", tag: "#{spec.version}", submodules: true }
  spec.source_files = "Source/**/*.{h,swift}"
end
