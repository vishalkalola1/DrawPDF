Pod::Spec.new do |s|
s.name             = 'DrawPDF'
s.version          = '1.5'
s.summary          = 'Draw PDF below of iOS 11'
s.description      = <<-DESC
Draw PDF below of iOS 11 you can use this to draw PDF
DESC
s.homepage         = 'https://github.com/vishalkalola1/DrawPDF.git'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'vishal patel' => 'vishalkalola196@gmail.com' }
s.source           = { :git => 'https://github.com/vishalkalola1/DrawPDF.git', :branch => "master", :tag => "1.5"}
s.platform     = :ios
s.ios.deployment_target = "8.0"
s.source_files	   = "VPDFTableCreation/*.swift"
s.requires_arc = true
end
