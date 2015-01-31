module ZeroPush
  module Compatibility
    def warn_on_deprecated_parameters(params)
      value = (params[:info] || params['info'] || params[:data] || params['data'])
      if value.is_a?(String)
        warn "[DEPRECATION] `info` or `data` encoded as a string will not be supported in version 3.0.0; Use a hash instead."
        http_config[:request_encoding] = :url_encoded
      end
    end

    def notify(params)
      warn_on_deprecated_parameters(params)
      super
    end

    def broadcast(params)
      warn_on_deprecated_parameters(params)
      super
    end
  end
end
