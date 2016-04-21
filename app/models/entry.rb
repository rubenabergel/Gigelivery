class Entry < ActiveRecord::Base
  belongs_to :feed

  require 'open-uri'

  CL_URL = [
    SOFT_JOB_NYC = "https://newyork.craigslist.org/search/mnh/sof?format=rss",
    SOFT_JOB_BROOKLYN = "https://newyork.craigslist.org/search/brk/sof?format=rss",
    WEB_JOB_NYC = "https://newyork.craigslist.org/search/mnh/web?format=rss",
    WEB_JOB_BROOKLYN = "https://newyork.craigslist.org/search/brk/web?format=rss",
    IT_JOB_NYC ="https://newyork.craigslist.org/search/mnh/sad?format=rss",
    IT_JOB_BROOKLYN = "https://newyork.craigslist.org/search/brk/sad?format=rss",
    IT_GIG_NYC = "https://newyork.craigslist.org/search/mnh/cpg?format=rss",
    IT_GIG_BROOKLYN = "https://newyork.craigslist.org/search/brk/cpg?format=rss",
  ]

  REDDIT_URL = [
    FORHIRE = "https://www.reddit.com/r/forhire"
  ]

  def self.run_feed
    cl_job
    reddit_job
  end

  def self.cl_job
    urls = Entry::CL_URL
    urls.each do |url|
      rss = Feedjira::Feed.fetch_and_parse url
      rss.entries.each do |entry|
        obj = Entry.find_or_create_by(title: entry.title)
        obj.update_attributes(content: entry.summary, url: entry.url, published: entry.published, location: "nyc")
        obj.save
      end
    end
  end

  def self.reddit_job
    doc = Nokogiri::HTML(open(Entry::FORHIRE))
    posts = doc.css(".link.self")
    posts.each do |post|
      next if !(post.css("a.title").text.include?("[Hiring]"))
        content = post.css("a.title")
        title = content.text
        url = "https://www.reddit.com" + content.xpath("@href").text
        submitted = post.css(".tagline time @title").text
        obj = Entry.find_or_create_by(title: title)
        obj.update_attributes(url: url, published: submitted)
        obj.save
      end
  end

end
