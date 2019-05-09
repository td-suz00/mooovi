class RankingController < ApplicationController
  layout 'review_site'

  before_action :ranking
  def ranking
    #レビュー数の多いproductのid上位5つが、多い順に並んだ配列を用意
    product_ids = Review.group(:product_id).order('count_product_id DESC').limit(5).count(:product_id).keys
    @ranking = product_ids.map { |id| Product.find(id) }
  end
end
