class StyleTagRemoverInterceptor
  def self.delivering_email(message)
    doc = Nokogiri::HTML(message.html_part.body.to_s)
    doc.search('style').remove
    message.html_part.body = doc.to_s
  end
end
