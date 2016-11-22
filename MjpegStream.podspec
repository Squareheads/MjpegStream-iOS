Pod::Spec.new do |s|
 
  s.platform = :ios
  s.ios.deployment_target = '9.0'
  s.name = "MjpegStream-SQH"
  s.summary = "Mjpeg Stream"
  s.requires_arc = true
 
  s.version = "0.0.2"
 
  s.license = { :type => "Private", :file => "LICENSE" }
 
  s.author = { "Owen Worley" => "owen@squareheads.io]" }
 
  s.homepage = "https://github.com/squareheads/MjpegStream-iOS"
 
  s.source = { :git => "git@github.com:Squareheads/MjpegStream-iOS", :tag => s.version.to_s}
 
  s.framework = "Foundation"

  s.source_files = "MjpegStream/**/*.{m,mm,h,swift}"
end
