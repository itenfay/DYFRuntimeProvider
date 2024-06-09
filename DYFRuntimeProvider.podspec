
Pod::Spec.new do |spec|

  spec.name         = "DYFRuntimeProvider"
  spec.version      = "2.1.0"
  spec.summary      = "DYFRuntimeProvider wraps the runtime, and provides some common usages."

  spec.description  = <<-DESC
  DYFRuntimeProvider wraps the runtime, and provides some common usages.
  DESC

  spec.homepage       = "https://github.com/itenfay/DYFRuntimeProvider"
  # spec.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author             = { "Tenfay" => "hansen981@126.com" }
  # Or just: spec.author    = "Tenfay"
  # spec.authors            = { "Tenfay" => "hansen981@126.com" }
  # spec.social_media_url   = "https://twitter.com/Tenfay"

  # spec.platform     = :ios
  spec.ios.deployment_target = "7.0"
  # spec.osx.deployment_target = "10.7"
  # spec.watchos.deployment_target = "2.0"
  # spec.tvos.deployment_target = "9.0"

  spec.source = { :git => "https://github.com/itenfay/DYFRuntimeProvider.git", :tag => spec.version.to_s }

  spec.source_files  = "Classes/*.{h,m}"
  spec.public_header_files = "Classes/*.h"
  # spec.resource  = "icon.png"
  # spec.resources = "Resources/*.png"

  # spec.framework  = "SomeFramework"
  # spec.frameworks = "SomeFramework", "AnotherFramework"

  # spec.library   = "iconv"
  # spec.libraries = "iconv", "xml2"

  spec.requires_arc = true

  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # spec.dependency "JSONKit", "~> 1.4"

end
