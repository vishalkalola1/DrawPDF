Pod::Spec.new do |s|
s.name             = 'DrawPDF'
s.version          = '1.1'
s.summary          = 'Draw PDF below of iOS 11'

s.description      = <<-DESC
Draw PDF below of iOS 11
DESC

s.homepage         = 'https://github.com/vishalkalola1/DrawPDF.git'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'vishal patel' => 'vishalkalola196@gmail.com' }
s.source           = { :git => 'https://github.com/vishalkalola1/DrawPDF.git', :tag => s.version }
s.source_files = 'VPDFTableCreation/*.{swift}'
s.resources     = ["VPDFTableCreation/*.png"]

end
