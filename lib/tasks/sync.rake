# namespace :sync do
#   task feeds: [:environment] do
#     Feed.all.each do |feed|
#       content = Feedjira::Feed.fetch_and_parse "https://newyork.craigslist.org/search/sof?format=rss"
#       content.entries.each do |entry|
#         local_entry = feed.entries.where(title: entry.title).first_or_initialize
#         local_entry.update_attributes(content: entry.content, publisher: entry.publisher, url: entry.url, published_at: entry.published_at)
#         p "Synced Entry - #{entry.title}"
#       end
#       p "Synced Feed - #{feed.name}"
#     end
#   end
# end
