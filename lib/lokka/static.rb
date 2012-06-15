module Lokka
  module StaticPage
    def self.registered(app)
      view_path = File.expand_path(File.dirname(__FILE__) + '/../../views')

      Dir.glob(view_path + "/*.{html,erb,haml,slim,erubis}").each do |f|
        base_name = File.basename(f, ".*")
        ext_name = File.extname(f)[1..-1].to_sym

        app.get "/#{base_name}" do
          case ext_name
          when :html
            File.read(view_path + "/#{base_name}.html")
          else
            dir = "theme/#{@theme.name}"
            layout = "#{dir}/layout"
            options = {}
            options[:layout] = layout.to_sym
            send :render, ext_name, "plugin/lokka-static/views/#{base_name}".to_sym, options
            # options[:layout] = false
            # send :render, ext_name, "plugin/lokka-static/views/#{base_name}".to_sym, options
          end
        end
      end

      app.helpers do
        def assets_path(file_path)
          "/plugin/lokka-static/views/#{request.path[1..-1]}/#{file_path}"
        end
      end
    end
  end
end
