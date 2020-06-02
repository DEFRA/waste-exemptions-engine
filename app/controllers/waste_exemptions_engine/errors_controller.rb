# frozen_string_literal: true

module WasteExemptionsEngine
  class ErrorsController < ::WasteExemptionsEngine::ApplicationController
    def show
      render(
        template: file_for(template),
        locals: { message: exception.try(:message) },
        status: (template_exists(error_code) ? error_code : "500")
      )
    end

    protected

    def error_code
      @error_code ||= params[:status]
    end

    # def render_error

    #   # --- FOR RAILS 4: ---
    #   ## @exception = env["action_dispatch.exception"]
    #   ## exception_wrapper = ActionDispatch::ExceptionWrapper.new(env, @exception)

    #   # --- FOR RAILS 5: ---
    #   @exception = request.env["action_dispatch.exception"]
    #   exception_wrapper = ActionDispatch::ExceptionWrapper.new(request.env['action_dispatch.backtrace_cleaner'], @exception)

    #   trace = exception_wrapper.application_trace

    #   # Custom notifications and stuff...

    # end

    def template_exists(name)
      File.exist?(template_path(name))
    end

    def template_path(name)
      File.expand_path(
        "app/views/#{file_for(name)}.html.erb",
        WasteExemptionsEngine::Engine.root
      )
    end

    def template
      @template ||= template_exists(error_code) ? error_code : "generic"
    end

    def file_for(name)
      "waste_exemptions_engine/errors/error_#{name}"
    end

    def exception
      request.env["action_dispatch.exception"]
    end
  end
end
