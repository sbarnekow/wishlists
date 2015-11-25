require 'nokogiri'
require 'open-uri'
require 'sinatra'
require 'sass'


get '/' do
  erb :welcome_page
end

post '/wishlist/' do
  @wishlist_url = params[:wishlist][:url]
  @wishlist_items = get_wishlist_items(@wishlist_url)
  @wishlist_deets = get_wishlist_details(@wishlist_url)
  erb :wishlist, locals: { wishlist_items: @wishlist_items, wishlist_details: @wishlist_deets }
end

def get_wishlist_details(wishlist_url)
  doc = Nokogiri::HTML(open(wishlist_url))
  wishlist_details = {}
  doc.css('[id^=reg-info]').each do |info|
    wishlist_title = info.css('h1').text.strip
    baby_deets = []
    for nth_child in 1..5
      detail = info.css("div.a-row.a-spacing-top-none.a-size-base.reg-meta-data > span:nth-child(#{nth_child})").text.strip
      baby_deets.push(detail)
    end
    wishlist_details[:title] = wishlist_title
    wishlist_details[:due_date] = baby_deets[1]
    wishlist_details[:time_until] = baby_deets[2]
    wishlist_details[:location] = baby_deets[4]
  end
  return wishlist_details
end

def get_wishlist_items(wishlist_url)
  doc = Nokogiri::HTML(open(wishlist_url))
  wishlist_items = []
  doc.css('[id^=item_I]').each do |info|
    # name = info.css('[id^=itemName]').text.strip
    # price = info.css('[id^=itemPrice]').text.strip
    # image = info.css('[id^=itemImage] img')
    # a_tag = info.css('[id^=itemImage] a')
    # link_val = a_tag.xpath('@href').first
    # link = "https://amzn.com#{link_val}/?tag=blilis-20"

    name = info.css('[id^=item_title]').text.strip
    price = info.css('[id^=item_price]').text.strip
    image = info.css('[id^=item-img] img')
    a_tag = info.css('[id^=item-img] a')
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

    wishlist_items.push({name: name, price: price, image: image, link: link})
  end
  return wishlist_items
end
