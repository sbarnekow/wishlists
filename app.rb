require 'nokogiri'
require 'open-uri'
require 'sinatra'
require 'sass'


get '/hello' do
  erb :wishlist, locals: {wishlist_data: parse_wishlist}
end

def parse_wishlist
  doc = Nokogiri::HTML(open('https://www.amazon.com/gp/registry/ref=cm_wl_edit_bck?ie=UTF8&id=3E7U1ZB9G2JA6&type=giftlist'))
  wishlist_item_data = []
  # doc.css('[id^=itemName]').each do |link|
  #   puts link.content
  # end
  doc.css('[id^=item_]').each do |info|
    name = info.css('[id^=itemName]').text.strip
    price = info.css('[id^=itemPrice]').text.strip
    image = info.css('[id^=itemImage]')
    # puts image
    ratings = []
    rating = info.css('div > div.a-column.a-span12.g-span12when-narrow.g-span7when-wide > div:nth-child(2) > a.a-link-normal.a-declarative.g-visible-js.reviewStarsPopoverLink > i.a-icon.a-icon-star.a-star-5 > span').text

    wishlist_item_data.push({name: name, price: price, rating: rating})
  end

  return wishlist_item_data
end
