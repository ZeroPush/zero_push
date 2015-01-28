module ZeroPush
  module Compatibility
    def notify(params)
      params.symbolize_keys!
      if (params[:info] || params[:data]).is_a?(String)
        warn "[DEPRECATION] `info` or `data` should not be passed in as encoded strings."
        http_config[:request_encoding] = :url_encoded
      end
      super
    end

    def broadcast(params)
      params.symbolize_keys!
      if (params[:info] || params[:data]).is_a?(String)
        warn "[DEPRECATION] `info` or `data` should not be passed in as encoded strings."
        http_config[:request_encoding] = :url_encoded
      end
      super
    end
  end
end
