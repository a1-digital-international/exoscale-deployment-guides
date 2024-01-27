# Jekyll Lightbox Plugin
#
# Bart Vandeweerdt | www.appfoundry.be
#
# Example usage: {% lightbox images/appfoundry.png --thumb="images/thumbs/appfoundry.png" --data="some data" --title="some title" --alt="some alt" --img-style="css styling" --class="yourclass"%}
module Jekyll
    class LightboxTag < Liquid::Tag
  
      def initialize(tag_name, text, token)
        super
  
        # The path to our image
        @path = Liquid::Template.parse(
          # Regex: split on first whitespace character while allowing double quoting for surrounding spaces in a file path
          text.split(/\s(?=(?:[^"]|"[^"]*")*$)/)[0].strip
        ).render(@context)
  
        # Defaults
        @title = ''
        @alt = ''
        @img_style = ''
        @class = ''
        @data = ''
        @thumb = @path
        @wrapper = false
        @wrapper_class = ''
  
        # Parse Options
        if text =~ /--title="([^"]*)"/i
          @title = text.match(/--title="([^"]*)"/i)[1]
        end
        if text =~ /--alt="([^"]*)"/i
          @alt = text.match(/--alt="([^"]*)"/i)[1]
        end
        if text =~ /--img-style="([^"]*)"/i
          @img_style = text.match(/--img-style="([^"]*)"/i)[1]
        end
        if text =~ /--class="([^"]*)"/i
          @class = text.match(/--class="([^"]*)"/i)[1]
        end
        if text =~ /--data="([^"]*)"/i
          @data = text.match(/--data="([^"]*)"/i)[1]
        end
        if text =~ /--thumb="([^"]*)"/i
          @thumb = text.match(/--thumb="([^"]*)"/i)[1]
        end

        # Add --wrapper and --wrapper-class parameters to the lightbox liquid tag
        if text =~ /--wrapper/i
            @wrapper = true
        end
        if text =~ /--wrapper-class="([^"]*)"/i 
            @wrapper = true 
            @wrapper_class = text.match(/--wrapper-class="([^"]*)"/i)[1]
        end

      end

      # Check if the given URL is external (simplified here to checking for http or https URL)
      def is_external_url?(url)
        url.match(/^https?:\/\/.*/)
      end
  
      def render(context)
        url = context.registers[:page]["url"]
        relative = "../" * (url.split("/").length-1)
        # Keep external src and thumbSrc URLs; check if data is given and otherwise set to default
        src = is_external_url?(@path) ? @path : File.join(relative, @path == nil ? '' : @path);
        thumbSrc = is_external_url?(@thumb) ? @thumb : File.join(relative, @thumb == nil ? '' : @thumb);
        data = @data.to_s.empty? ? @path : @data
  
        # Conditionally wrap in a div and pass wrapper class
        if @wrapper
          %{<div class="#{@wrapper_class}"><a href="#{src}" data-lightbox="#{data}" data-title="#{@title}"><img src="#{thumbSrc}" alt="#{@alt || @title}" class="#{@class}" style="#{@img_style}"/></a></div>}
        else
          %{<a href="#{src}" data-lightbox="#{data}" data-title="#{@title}"><img src="#{thumbSrc}" alt="#{@alt || @title}" class="#{@class}" style="#{@img_style}"/></a>}
        end
      end
    end
  end
  
  Liquid::Template.register_tag('lightbox', Jekyll::LightboxTag)