xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
xml.feed("xmlns" => "http://www.w3.org/2005/Atom", "xmlns:itunes" => "http://www.itunes.com/dtds/podcast-1.0.dtd") do
  xml.title @show.first.title
  xml.id "http://binaergewitter.de/"
  xml.updated Date.parse(@episodes.first.date).to_datetime.rfc3339 unless @episodes.empty?
  xml.author { xml.name @show.first.author }

  xml.tag!("itunes:summary", "")
  xml.tag!("itunes:author", @show.first.author)
  xml.tag!("itunes:explicit", "no")

  xml.tag!("itunes:image", {"href" => @show.first.cover_url})
  xml.tag!("itunes:category", {"text" => "Technology"})
  
  xml.tag!("itunes:owner"){
    xml.tag!("itunes:name", @show.first.author)
    xml.tag!("itunes:email", "info@binaergewitter.de")
  }


  @episodes.each do |episode|
    if !episode.meta_data[@audio_format].nil?
      xml.entry do
        xml.title episode.title
        xml.link "rel" => "alternate", "href" => episode.full_url
        xml.link "href" => episode.meta_data[@audio_format], 'rel' => 'enclosure', 'type' => "audio/mpeg"
        xml.id episode.meta_data[@audio_format]
        xml.published Date.parse(episode.date).to_datetime.rfc3339
        xml.updated Date.parse(episode.date).to_datetime.rfc3339
        xml.author { xml.name @show.first.author }
        xml.summary markdown episode.content
        xml.content markdown episode.content
      end
    end
  end
end
