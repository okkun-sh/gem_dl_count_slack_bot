require "net/https"
require "json"
require "open-uri"
require "nokogiri"

class SlackBot
  attr_reader :slack_uri, :gem_uri
  def initialize(slack_uri:, gem_uri:)
    @slack_uri = slack_uri
    @gem_uri = gem_uri
  end

  def post_slack
    uri = URI.parse(slack_uri)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    req = Net::HTTP::Post.new(uri.request_uri)
    req["Content-Type"] = "application/json"

    dl_count = fetch_gem_dl_count
    payload = {
      "text" => "TOTAL DOWNLOADS : #{dl_count}"
    }.to_json
    req.body = payload
    res = https.request(req)
  end

  private
    def fetch_gem_dl_count
      html = Nokogiri::HTML(open(gem_uri))
      dl_count = html.css('.gem__downloads').first.content
    end
end
