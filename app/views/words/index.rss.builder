xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Recent Words"
    xml.description "Latest words added to leximo"
    xml.link formatted_words_url(:rss)
    
    for word in @words
      xml.item do
        xml.title "#{word.word} (#{word.language})"
        xml.description word.definition
        xml.pubDate word.created_at.to_s(:rfc822)
        xml.link word_url(word)
        xml.guid word_url(word)
      end
    end
  end
end
