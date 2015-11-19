require 'nokogiri'
require 'open-uri'
require 'sinatra'
require 'sass'


get '/' do
  erb :welcome_page
end

post '/wishlist/' do
  @wishlist_url = params[:wishlist][:url]
  @wishlist_detail = parse_wishlist(@wishlist_url)
  puts @wishlist_url
  puts @wishlist_detail
  erb :wishlist, locals: {wishlist_data: @wishlist_detail}
end




def parse_wishlist(wishlist_url)
  doc = Nokogiri::HTML(open(wishlist_url))
  wishlist_item_data = []
  # doc.css('[id^=itemName]').each do |link|
  #   puts link.content
  # end
  doc.css('[id^=item_]').each do |info|
    name = info.css('[id^=itemName]').text.strip
    price = info.css('[id^=itemPrice]').text.strip
    image = info.css('[id^=itemImage] img')
    a_tag = info.css('[id^=itemImage] a')
    link_val = a_tag.xpath('@href').first
    link = "https://amzn.com#{link_val}/?tag=blilis-20"

    one_rating = info.css('.a-star-1').text
    onehalf_rating = info.css('.a-star-1-5').text
    two_rating = info.css('.a-star-2').text
    twohalf_rating = info.css('.a-star-2-5').text
    three_rating = info.css('.a-star-3').text
    threehalf_rating = info.css('.a-star-3-5').text
    four_rating = info.css('.a-star-4').text
    fourhalf_rating = info.css('.a-star-4-5').text
    five_rating = info.css('.a-star-5').text

    puts "&&&&&&&&&&&&&&&&&&&&&&&&&&&&  rating #{fourhalf_rating}"
    puts "&&&&&&&&&&&&&&&&&&&&&&&&&&&&  rating #{four_rating}"
    puts "&&&&&&&&&&&&&&&&&&&&&&&&&&&&  rating #{five_rating}" 

    wishlist_item_data.push({name: name, price: price, image: image, link: link})
  end

  return wishlist_item_data
end
