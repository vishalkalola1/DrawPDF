Pod::Spec.new do |s|
s.name             = 'DrawPDF'
s.version          = '1.0'
s.summary          = 'Draw PDF below of iOS 11'

s.description      = <<-DESC
Draw PDF below of iOS 11
DESC

s.homepage         = 'https://github.com/vishalkalola1/DrawPDF.git'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'vishal patel' => 'vishalkalola196@gmail.com' }
s.source           = { :git => 'https://github.com/vishalkalola1/DrawPDF.git', :commit=> "8b6aa147c56d2e1685d4ffb15ed6d689d67f4c4d" }

s.ios.deployment_target = '8.0'
s.source_files = 'DrawPDF/VTablePDFCreationSwift/VTablePDFCreation/VPDFTableCreation/*.{swift}'

end
