Pod::Spec.new do |s|
  s.name         = "ISO8601Duration"
  s.version      = "1.0"
  s.summary      = "ISO 8601 duration implementation for Swift using Codable"
  s.description  = <<-DESC
This micro-framework should help with handling duration written using the ISO 8601 standard. It allows parsing a string like "P3Y6M4DT12H30M5S" to TimeInterval.
  DESC
  
  s.homepage     = "https://github.com/MaciejGad/Duration"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Maciej Gad" => "https://github.com/MaciejGad" }
  s.social_media_url   = "https://twitter.com/maciej_gad"
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/MaciejGad/Duration.git", :tag => 'v1.0' }
  s.source_files  =  "Duration/Duration.swift"
  s.swift_version = "4.2"

end