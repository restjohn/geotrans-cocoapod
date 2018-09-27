# GEOTRANS CocoaPod Distribution

The product was developed using GEOTRANS, a product of the National Geospatial-Intelligence Agency (NGA) and U.S. Army Engineering Research and Development Center.

This project is a packaging of the National Geospatial-Intelligence Agency (NGA) Mensuration Services Program (MSP) [GEOTRANS](http://earth-info.nga.mil/GandG/update/index.php?dir=wgs84&action=wgs84#tab_geotrans) software library as
a [CocoaPod](https://cocoapods.org/).  The purpose of this project is to facilitate the integration of GEOTRANS's 
capabilities into iOS and macOS projects.

This project references the entire [GEOTRANS source](https://github.com/restjohn/geotrans) as a [submodule](https://git-scm.com/book/en/v2/Git-Tools-Submodules) of this project, extracted from the [Linux Developer](http://earth-info.nga.mil/GandG/update/wgs84/apps/geotrans/current-version/sw/linux_dev.tgz) package available from the NGA MSP web site. 

This project also aims to provide some Objective-C-friendly [utility APIs](GEOTRANS/Classes) in front of the GEOTRANS C++ APIs.

[![CI Status](https://img.shields.io/travis/restjohn/GEOTRANS.svg?style=flat)](https://travis-ci.org/restjohn/GEOTRANS)
[![Version](https://img.shields.io/cocoapods/v/GEOTRANS.svg?style=flat)](https://cocoapods.org/pods/GEOTRANS)
[![License](https://img.shields.io/cocoapods/l/GEOTRANS.svg?style=flat)](https://cocoapods.org/pods/GEOTRANS)
[![Platform](https://img.shields.io/cocoapods/p/GEOTRANS.svg?style=flat)](https://cocoapods.org/pods/GEOTRANS)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.
When you clone this repository, you'll need to initialize the GEOTRANS submodule:
```shell
$ git clone --recurse-submodules https://github.com/restjohn/geotrans-cocoapod
```

## Requirements

## Installation

GEOTRANS is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'GEOTRANS', :git => 'https://github.com/restjohn/geotrans-cocoapod', :branch => 'master'
```

## Author

restjohn, restjohn@users.noreply.github.com

## License

GEOTRANS Cocoapod is available under the MIT license. See the LICENSE file for more info.
Please also see the [GEOTRANS Terms of Use](https://github.com/restjohn/geotrans/GEOTRANS3/docs/MSP_Geotrans_Terms_Of_Use.txt) contained therein.
