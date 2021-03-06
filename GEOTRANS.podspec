
Pod::Spec.new do |s|
    s.name             = 'GEOTRANS'
    s.version          = '3.7'
    s.summary          = 'National Geospatial-Intelligence Agency (NGA) Mensuration Services Program (MSP) GEOTRANS library'
  
  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  
    s.description      = <<-DESC
  This pod is a simple wrapped distribution of the National Geospatial-Intelligence Agency (NGA) Mensuration Services Program (MSP)
  GEOTRANS library, available at http://earth-info.nga.mil/GandG/update/index.php?dir=wgs84&action=wgs84#tab_geotrans.  
                         DESC
  
    s.homepage         = 'http://earth-info.nga.mil/GandG/update/index.php?dir=wgs84&action=wgs84#tab_geotrans'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'restjohn' => 'restjohn@users.noreply.github.com' }
    s.source           = { :git => 'https://github.com/restjohn/geotrans-cocoapod.git', :tag => s.version, :submodules => true }
    s.social_media_url = 'https://twitter.com/NGA_GEOINT'
  
    s.ios.deployment_target = '9.0'
    s.macos.deployment_target = '10.10'
  
    s.source_files = [
      'geotrans-src/CCS/src/**/*.{h,cpp}'
    ]

    s.resource_bundles = {
      'GEOTRANS-TestData' => ['geotrans-src/SpreadsheetTester/TestFiles/outputs/output/*']
    }

    s.library = 'c++'
    s.pod_target_xcconfig = {
      'CLANG_CXX_LANGUAGE_STANDARD' => 'c++98',
      'CLANG_CXX_LIBRARY' => 'libc++'
    }
  end
