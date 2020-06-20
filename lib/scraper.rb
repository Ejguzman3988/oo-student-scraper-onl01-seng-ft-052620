require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    
    array_students_hashs = []

    html = open(index_url)
    doc = Nokogiri::HTML(html)
    
    student_profiles = doc.css('.student-card')

    # binding.pry
    student_profiles.each do |student_info|
      hash_info = 
      {
        :name => student_info.css('.student-name').text,
        :location => student_info.css('.student-location').text,
        :profile_url => student_info.css('a')[0]['href']
      }

      array_students_hashs << hash_info
    end

    array_students_hashs


  end

  def self.scrape_profile_page(profile_url)
    
    html = open(profile_url)
    doc = Nokogiri::HTML(html)
    
    student_profile = doc.css('.main-wrapper')
    url_holder = student_profile.css('.social-icon-container a')

    social_media = []

    url_holder.each_with_index do |url, index|
      social_media << url_holder[index]['href']
    end
   
    
    hash_info = {}

    social_media.each do |url|
      hash_info[format_url(url).to_sym] = url
    end
    

    hash_info[:profile_quote] = student_profile.css('.profile-quote').text
    hash_info[:bio] = student_profile.css('p').text
    name = student_profile.css('.profile-name').text
    

    websites = [:twitter, :linkedin, :github, :profile_quote, :bio]

    hash_info.keys.each do |key|
      if !websites.include?(key)
        hash_info[:blog] = hash_info.delete(key)
      end
    end
   
    

    hash_info
    
  end

  def self.format_url(url)
    url = url.split('.')

    if url.length == 3
      url[1]
    else
      url.first.split('/').last
    end
  end
end

