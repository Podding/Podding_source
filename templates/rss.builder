xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
xml.feed("xml:lang" => 'de',"xmlns" => "http://www.w3.org/2005/Atom", "xmlns:itunes" => "http://www.itunes.com/dtds/podcast-1.0.dtd") do
  xml.title @show ? @show.title : settings.title

  xml.id "http://binaergewitter.de/"
  xml.updated @episodes.first.date.rfc3339 unless @episodes.empty?
  xml.author { xml.name(@show ? @show.author : settings.author) }
  xml.tag!("itunes:summary", "")
  xml.tag!("itunes:author", "author")
  xml.tag!("itunes:explicit", "no")

  xml.tag!("itunes:image", {"href" => @show ? @show.cover_url : settings.cover_url})
  xml.tag!("itunes:category", {"text" => "Technology"})

  xml.tag!("itunes:owner"){
    xml.tag!("itunes:name", "author")
    xml.tag!("itunes:email", "info@binaergewitter.de")
  }

  xml.link({"rel" => "self", "href" => request.url})
  @episodes.each do |episode|
    if !episode.meta_data["audioformats"].nil?
      xml.tag!("debug", episode.meta_data["audioformats"][@audio_format])

      if !episode.meta_data["audioformats"][@audio_format].nil?
        xml.entry do
          xml.title episode.title
          xml.link "rel" => "alternate", "href" => episode.meta_data["full_url"]
          xml.link "href" => episode.meta_data["audioformats"][@audio_format], 'rel' => 'enclosure', 'type' => "audio/mpeg"
          xml.id episode.meta_data["audioformats"][@audio_format]
          xml.published episode.date.rfc3339
          xml.updated episode.date.rfc3339
          xml.author { xml.name("author") }
          xml.summary do
            xml.cdata!(render_content(episode.content))
          end
          xml.content do
            xml.cdata!(render_content(episode.content))
          end
        end

      end
    end
  end
end