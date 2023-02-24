
Pod::Spec.new do |spec|

  spec.name         = "DYFRuntimeProvider"
  spec.version      = "2.0.2"
  spec.summary      = "DYFRuntimeProvider wraps the runtime of Objective-C, and provides some common usages."

  spec.description  = <<-DESC
	    DYFRuntimeProvider wraps the runtime of Objective-C, and provides some common usages.
                   DESC

  spec.homepage       = "https://github.com/chenxing640/DYFRuntimeProvider"
  # spec.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author             = { "chenxing" => "chenxing640@foxmail.com" }
  # Or just: spec.author    = "chenxing"
  # spec.authors            = { "chenxing" => "chenxing640@foxmail.com" }
  # spec.social_media_url   = "https://twitter.com/chenxing"

  # spec.platform     = :ios
  spec.ios.deployment_target = "7.0"
  # spec.osx.deployment_target = "10.7"
  # spec.watchos.deployment_target = "2.0"
  # spec.tvos.deployment_target = "9.0"

  spec.source = { :git => "https://github.com/chenxing640/DYFRuntimeProvider.git", :tag => spec.version.to_s }

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
