xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
xml.rss("version" => "2.0",
  "xmlns:content" => "http://purl.org/rss/1.0/modules/content/",
  "xmlns:wfw" => "http://wellformedweb.org/CommentAPI/",
  "xmlns:dc" => "http://purl.org/dc/elements/1.1/",
  "xmlns:atom" => "http://www.w3.org/2005/Atom",
  "xmlns:sy" => "http://purl.org/rss/1.0/modules/syndication/",
  "xmlns:slash" => "http://purl.org/rss/1.0/modules/slash/",
  "xmlns:itunes" => "http://www.itunes.com/dtds/podcast-1.0.dtd",
"xmlns:rawvoice" => "http://www.rawvoice.com/rawvoiceRssModule/") do
  xml.channel do
    xml.title @show ? @show.title : settings.title
    xml.tag! "atom:link",{"rel" => "self", "href" => request.url}
    xml.link Settings.base_url
    xml.language Settings.language
    xml.copyright Settings.copyright
    xml.tag! "itunes:subtitle", Settings.subtitle
    xml.tag! "itunes:author", Settings.author
    xml.tag!("itunes:explicit", Settings[:explicit] ? Settings[:explicit] : "no")
    xml.tag! "itunes:summary", @show ? @show.description : Settings.description
    xml.description @show ? @show.description : Settings.description
    xml.tag!("itunes:owner") do
      xml.tag! "itunes:name", Settings.author
      xml.tag! "itunes:email", Settings.mail
    end
    xml.tag! "itunes:image", { "href" => Settings.cover_url }
    xml.tag!( "itunes:category", { "text" => Settings.category })

    @episodes.each do |episode|
      xml.item do
        xml.title episode.title
        xml.guid episode.name, {"isPermaLink" => "false"}
        xml.tag! "itunes:author", @show ? @show.author : Settings.author
        xml.tag! "itunes:subtitle", episode.subtitle if episode.subtitle
        xml.pubDate episode.date.rfc822
        xml.tag! "itunes:summary", episode.teaser
        xml.enclosure "url" => episode.audio_file_by_format(@audioformat), 'type' => @audioformat.mime_type
        xml.content do
          xml.cdata!(render_content(episode.teaser) + "\n" + render_content(episode.content))
        end
      end
    end
  end
end