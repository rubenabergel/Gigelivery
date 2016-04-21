class Entry < ActiveRecord::Base
  belongs_to :feed

  require 'open-uri'

# add url rss feed for other Craigslist cities
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
    FORHIRE = "https://www.reddit.com/r/forhire",
  ]

  AUTHENTICJOB_URL = [
    NYC_GIGS = "https://www.authenticjobs.com/rss/custom.php?location=NewYork",
  ]

  JOBSPRESSO_URL = [
    REMOTE_SOFTWARE = "https://jobspresso.co/?feed=job_feed&job_types=developer&search_location&job_categories&search_keywords",
    REMOTE_WEB = "https://jobspresso.co/?feed=job_feed&job_types=designer&search_location&job_categories&search_keywords",
  ]

  STACKOVERFLOW_URL = [
    CONTRACT_SOFTWARE ="https://stackoverflow.com/jobs/feed?type=Contract",
    PERMANENT_SOFTWARE = "https://stackoverflow.com/jobs/feed?type=Permanent",
  ]

  WORDPRESS_URL =

  def self.run_feed
    cl_job(Entry::JOBSPRESSO_URL)
    reddit_job
  end

  def self.cl_job(urls)
    urls = urls
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

  def self.weekly_posts
    Entry.where(published: 1.week.ago..Date.today)
  end

  def self.today_post
      Entry.where(published: Date.today)
  end

  

end
