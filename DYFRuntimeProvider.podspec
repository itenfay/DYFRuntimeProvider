
Pod::Spec.new do |spec|


  spec.name         = "DYFRuntimeProvider"
  spec.version      = "1.0.0"
  spec.summary      = "DYFRuntimeProvider wraps the runtime.(Objective-C)"

  spec.description  = <<-DESC
	DYFRuntimeProvider wraps the runtime, and can quickly use for the transformation of the dictionary and model, archiving and unarchiving, adding a method, exchanging two methods, replacing a method, and getting all the variable names, property names and method names of a class.

                   DESC

  spec.homepage       = "https://github.com/dgynfi/DYFRuntimeProvider"
  # spec.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  spec.license      = { :type => "MIT", :file => "LICENSE" }


  spec.author             = { "dgynfi" => "vinphy.teng@foxmail.com" }
  # Or just: spec.author    = "dgynfi"
  # spec.authors            = { "dgynfi" => "vinphy.teng@foxmail.com" }
  # spec.social_media_url   = "https://twitter.com/dgynfi"


  spec.platform     = :ios

  spec.ios.deployment_target = "7.0"
  # spec.osx.deployment_target = "10.7"
  # spec.watchos.deployment_target = "2.0"
  # spec.tvos.deployment_target = "9.0"


  spec.source = { :git => "https://github.com/dgynfi/DYFRuntimeProvider.git", :tag => spec.version }


  spec.source_files  = "RuntimeProvider/*.{h,m}"
  spec.public_header_files = "RuntimeProvider/*.h"


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
