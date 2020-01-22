# Error handling
module Error
  module ErrorHandler
    def self.included(clazz)
      clazz.class_eval do
        rescue_from Mongoid::Errors::DocumentNotFound do |e|
          respond(404, "Document not found!")
        end
      end
    end

    private

    def respond(_status, _message)
      render :json => {:error => _message}.to_json, :status => _status
    end
  end
end