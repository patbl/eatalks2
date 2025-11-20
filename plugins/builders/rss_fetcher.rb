require 'net/http'
require 'uri'

class Builders::RssFetcher < SiteBuilder
  def build
    hook :site, :pre_render do |site|
      # Fetch RSS from S3
      rss_url = 'https://eatalks.s3.us-east-2.amazonaws.com/1755269.rss'

      begin
        uri = URI.parse(rss_url)
        response = Net::HTTP.get_response(uri)

        if response.is_a?(Net::HTTPSuccess)
          rss_content = response.body

          # Create a static resource for the RSS feed
          add_resource :rss, '1755269.rss' do
            layout :none
            content rss_content
            permalink '/1755269.rss'
          end

          Bridgetown.logger.info "RSS Feed:", "Successfully fetched from S3"
        else
          Bridgetown.logger.warn "RSS Feed:", "Failed to fetch from S3 (HTTP #{response.code})"
        end
      rescue => e
        Bridgetown.logger.error "RSS Feed:", "Error fetching from S3: #{e.message}"
      end
    end
  end
end
