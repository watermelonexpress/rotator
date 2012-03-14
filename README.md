# Rotator

Rotator is a file rotation library mainly build for rotating log files written purely in Ruby.

## Rotator - installation

``` ruby
## using Bundler
gem 'rotator', git: 'git@github.com:rubymaniac/rotator.git'
```

## Rotator - dependencies
Rotator depends only on the aws/s3 gem and only if you use the S3 uploader (currently the only one supported).

## Rotator - user manual
The process that Rotator follows in order to rotate a file is the following:

```
 _________            ____________________
|         |          |                    |
|  FILE   |          |        RENAME      |
| foo.log | -------> | foo-2012-03-14.log |
|_________|          |____________________|         __________
                                |                  |          |
                                | ---------------> | TRANSFER |
                                |                  |__________|
                      _______________________
                     |                       |
                     |         GZIP          |
                     | foo-2012-03-14.log.gz |
                     |_______________________|
```

The transfer method the Rotator currently supports is S3 uploading only.

Using the rotate method

``` ruby
Rotator.rotate("/path/to/file", options_hash)
```
