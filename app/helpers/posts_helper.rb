module PostsHelper

  def remove_markup(text)
    text.gsub!(/(<[^>]*>)|\n|\t/s, ' ')
    text.gsub('&#8217;', "'")
  end

  #
  # Uses Hpricot to count the number of Textile structure tags and determine
  # where to stop and add a more link.
  #
  def render_slim_body( post )
    html = ""
    max_lines = 10
    lines = 0
    Hpricot( RedCloth.new(post.body||'').to_html ).search( "/*" ).each do |part|
      # XXX: make this recursively check for child tags?
      if part.elem?
        if part.name == "p" or part.name == "pre" or part.name == "code"
          lines += 3
        elsif part.name =~ /$h[1-9]/
          lines += 2
        elsif part.name == "ul"
          lines += part.search( "//li").size
        elsif part.name == "table"
          lines += part.search( "//tr").size
        end

        lines += part.search( "//br").size
      else
        lines += part.search( "//br").size
      end

      html += part.to_html

      if html.size != 0 and lines >= max_lines
        html += "<p>#{link_to "&#8230; more", "/posts/#{post.document_id}" }</p>"
        break
      end
    end

    html
  end

  def render_body( post, is_render_slim = false )
    if is_render_slim
      render_slim_body( post )
    else
      RedCloth.new( post.body || '' ).to_html
    end
  end
end
