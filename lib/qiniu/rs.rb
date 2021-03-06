# -*- encoding: utf-8 -*-

require 'qiniu/rs/version'

module Qiniu
  module RS
    autoload :Config, 'qiniu/rs/config'
    autoload :Log, 'qiniu/rs/log'
    autoload :Exception, 'qiniu/rs/exceptions'
    autoload :Utils, 'qiniu/rs/utils'
    autoload :Auth, 'qiniu/rs/auth'
    autoload :IO, 'qiniu/rs/io'
    autoload :RS, 'qiniu/rs/rs'
    autoload :Image, 'qiniu/rs/image'

    class << self

      StatusOK = 200

      def establish_connection!(opts = {})
        Config.initialize_connect opts
      end

      def login!(user, pwd)
        code, data = Auth.exchange_by_password!(user, pwd)
        code == StatusOK
      end

      def put_auth(expires_in = nil, callback_url = nil)
        code, data = IO.put_auth(expires_in, callback_url)
        code == StatusOK ? data["url"] : false
      end

      def upload opts = {}
        code, data = IO.put_file(opts[:url],
                                 opts[:file],
                                 opts[:bucket],
                                 opts[:key],
                                 opts[:mime_type],
                                 opts[:note],
                                 opts[:callback_params],
                                 opts[:enable_crc32_check])
        code == StatusOK
      end

      def stat(bucket, key)
        code, data = RS.stat(bucket, key)
        code == StatusOK ? data : false
      end

      def get(bucket, key, save_as = nil, expires_in = nil, version = nil)
        code, data = RS.get(bucket, key, save_as, expires_in, version)
        code == StatusOK ? data : false
      end

      def download(bucket, key, save_as = nil, expires_in = nil, version = nil)
        code, data = RS.get(bucket, key, save_as, expires_in, version)
        code == StatusOK ? data["url"] : false
      end

      def delete(bucket, key)
        code, data = RS.delete(bucket, key)
        code == StatusOK
      end

      def batch(command, bucket, keys)
        code, data = RS.batch(command, bucket, keys)
        code == StatusOK ? data : false
      end

      def batch_stat(bucket, keys)
        code, data = RS.batch_stat(bucket, keys)
        code == StatusOK ? data : false
      end

      def batch_get(bucket, keys)
        code, data = RS.batch_get(bucket, keys)
        code == StatusOK ? data : false
      end

      def batch_download(bucket, keys)
        code, data = RS.batch_get(bucket, keys)
        return false unless code == StatusOK
        links = []
        data.each { |e| links << e["data"]["url"] }
        links
      end

      def batch_delete(bucket, keys)
        code, data = RS.batch_delete(bucket, keys)
        code == StatusOK ? data : false
      end

      def publish(domain, bucket)
        code, data = RS.publish(domain, bucket)
        code == StatusOK
      end

      def unpublish(domain)
        code, data = RS.unpublish(domain)
        code == StatusOK
      end

      def drop(bucket)
        code, data = RS.drop(bucket)
        code == StatusOK
      end

      def image_info(url)
        code, data = Image.info(url)
        code == StatusOK ? data : false
      end

      def image_preview_url(url, spec)
        Image.preivew_url(url, spec)
      end

    end

  end
end
