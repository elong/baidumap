# Baidumap


## Installation

Add this line to your application's Gemfile:

    gem 'baidumap'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install baidumap

## Usage

```ruby
ak = 'aaaaaaaaaa' #assigned by baidu
place = Baidumap::Request::Place.new(ak)
response = place.subject.search_by_region('饭店','北京')
response = place.search_by_bounds('银行',39.915,116.404,39.975,116.414)
response = place.search_by_radius('银行',39.915,116.404,2000)
p response.status
p response.result


geocoder = Baidumap::Request::Geocoder.new(ak)
response = geocoder.encode('酒仙桥中路10号','北京')
response = geocoder.decode('39.983424','116.322987')
p response.status
p response.result

```




## 返回码 定义 英文返回描述

* 0 正常 ok
* 2 请求参数非法 Parameter Invalid
* 3 权限校验失败 Verify Failure
* 4 配额校验失败 Quota Failure
* 5 ak不存在或者非法 AK Failure
* 2xx 无权限
* 3xx 配额错误


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
