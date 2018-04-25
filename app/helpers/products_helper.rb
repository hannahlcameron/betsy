module ProductsHelper
  def star_rating(rating)
    stars = ""
    rating.times do
      stars += "#{ image_tag 'lightening-bolt.png', alt: 'lightening bolt', width: 20, height: 20}"
    end
    (5 - rating).times do
      stars += "#{ image_tag 'grey-lightening-bolt.jpg', alt: 'grey lightening bolt', width: 20, height: 20}"
    end
    return (stars).html_safe
  end
end
